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
    /// </summary>
    [ModuleAuthorize("Cashiering")]
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

            var model = await _cashieringService.GetCashiering(
                dateFrom, dateTo, q, paymentModeId, userId, source);

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
            var cashierIds = await _context.Sales
                .Select(s => s.UserId)
                .Union(_context.ServiceInvoices.Select(i => i.UserId))
                .ToListAsync();

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
