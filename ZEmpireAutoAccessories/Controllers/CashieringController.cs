using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Authorization;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;
using ZEmpireAutoAccessories.Services.Interfaces;

namespace ZEmpireAutoAccessories.Controllers
{
    /// <summary>
    /// Cashiering is a read-only collections view: it merges product sales
    /// (sales.Sales) and service invoices (sales.ServiceInvoice) into one
    /// list so a cashier can close out a day. Recording and editing either
    /// document stays in SalesController / ServiceInvoiceController; the rows
    /// here link back to those screens.
    ///
    /// It deliberately has no module row of its own in sec.Module: it shows
    /// nothing that Sales and Service Invoices do not already own, so it is
    /// gated on those two and needs no database change to switch on. Holding
    /// either one opens the screen, and the user sees only the half they
    /// hold - a Sales-only user gets sales, and never service invoice rows.
    /// </summary>
    [ModuleAuthorize("Sales", "Service Invoices")]
    public class CashieringController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly ICashieringService _cashieringService;

        public CashieringController(ApplicationDbContext context, ICashieringService cashieringService)
        {
            _context = context;
            _cashieringService = cashieringService;
        }

        // GET: Cashiering?from=...&to=...&q=...&paymentModeId=...&userId=...&source=Sale
        public async Task<IActionResult> Index(
            DateOnly? from,
            DateOnly? to,
            string? q,
            int? paymentModeId,
            string? userId,
            CashierSource? source)
        {
            // A cashier opens this to close out the current shift, so default
            // to today rather than to the whole table.
            var today = DateOnly.FromDateTime(DateTime.Now);
            var dateFrom = from ?? today;
            var dateTo = to ?? today;

            // The filter says what was asked for; the claims say what may be
            // answered. Someone holding only one of the two modules is pinned
            // to that source, whatever arrives on the query string - the
            // ModuleAuthorize above lets either module in, so this is what
            // keeps the other half out.
            var canSeeSales = User.HasClaim(AppClaims.ModuleAccess, "Sales");
            var canSeeInvoices = User.HasClaim(AppClaims.ModuleAccess, "Service Invoices");

            var effectiveSource = source;
            if (!canSeeSales)
                effectiveSource = CashierSource.ServiceInvoice;
            else if (!canSeeInvoices)
                effectiveSource = CashierSource.Sale;

            var model = await _cashieringService.GetCashiering(
                dateFrom, dateTo, q, paymentModeId, userId, effectiveSource);

            model.CanSeeSales = canSeeSales;
            model.CanSeeServiceInvoices = canSeeInvoices;

            await LoadFilterDropdowns(model);

            return View(model);
        }

        private async Task LoadFilterDropdowns(CashieringViewModel model)
        {
            ViewData["PaymentModeID"] = new SelectList(
                await _context.PaymentModes
                    .OrderBy(p => p.PaymentModeName)
                    .ToListAsync(),
                "PaymentModeID", "PaymentModeName", model.PaymentModeID);

            // Only users who have actually recorded a sale or an invoice -
            // listing every account would bury the handful of real cashiers.
            // Drawn from the same sources the user is allowed to see, so the
            // filter never names someone who only appears on the other half.
            IQueryable<string>? cashierIdQuery = null;

            if (model.CanSeeSales)
                cashierIdQuery = _context.Sales.Select(s => s.UserId);

            if (model.CanSeeServiceInvoices)
            {
                var invoiceUsers = _context.ServiceInvoices.Select(i => i.UserId);
                cashierIdQuery = cashierIdQuery == null
                    ? invoiceUsers
                    : cashierIdQuery.Union(invoiceUsers);
            }

            var cashierIds = cashierIdQuery == null
                ? new List<string>()
                : await cashierIdQuery.ToListAsync();

            var cashiers = await _context.Users
                .Where(u => cashierIds.Contains(u.Id))
                .OrderBy(u => u.FullName)
                .Select(u => new
                {
                    u.Id,
                    Display = u.FullName != null && u.FullName != "" ? u.FullName : u.UserName
                })
                .ToListAsync();

            ViewData["UserId"] = new SelectList(cashiers, "Id", "Display", model.UserId);
        }
    }
}
