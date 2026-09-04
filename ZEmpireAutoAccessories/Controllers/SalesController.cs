using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Authorization;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;
using ZEmpireAutoAccessories.Services.Interfaces;

namespace ZEmpireAutoAccessories.Controllers
{
    [ModuleAuthorize("Sales")]
    public class SalesController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly ISalesService _salesService;
        private readonly IQuotationService _quotationService; // GetNextInvoiceNumber lives here

        public SalesController(
            ApplicationDbContext context,
            ISalesService salesService,
            IQuotationService quotationService)
        {
            _context = context;
            _salesService = salesService;
            _quotationService = quotationService;
        }

        // GET: Sale
        public async Task<IActionResult> Index()
        {
            var sales = await _salesService.GetSales();
            return View(sales);
        }

        // GET: Sale/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
                return NotFound();

            var sale = await _salesService.GetSale(id.Value);
            if (sale == null)
                return NotFound();

            return View(sale);
        }

        // GET: Sale/Create
        public async Task<IActionResult> Create()
        {
            await LoadDropdowns();
            return View();
        }

        // POST: Sale/Create
        // Bound as parallel flat lists (not List<SaleLineRequest>) since the Create
        // view builds rows client-side with plain repeated input names - simpler
        // than indexed complex-object binding for a small line-item table.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(
            int customerId,
            int? vehicleId,
            int paymentModeId,
            List<int> productId,
            List<int> quantity,
            List<decimal> unitPrice)
        {
            var items = new List<SaleLineRequest>();
            for (int i = 0; i < productId.Count; i++)
            {
                if (productId[i] > 0 && quantity[i] > 0)
                {
                    items.Add(new SaleLineRequest
                    {
                        ProductID = productId[i],
                        Quantity = quantity[i],
                        UnitPrice = unitPrice[i]
                    });
                }
            }

            if (items.Count == 0)
            {
                ModelState.AddModelError(string.Empty, "Add at least one line item.");
                await LoadDropdowns();
                return View();
            }

            try
            {
                var (invoiceNumber, _) = await _quotationService.GetNextInvoiceNumber(CurrentUserId);
                var sale = await _salesService.CreateSale(
                    CurrentUserId, customerId, paymentModeId, invoiceNumber, vehicleId, items);

                return RedirectToAction(nameof(Details), new { id = sale.SalesID });
            }
            catch (Exception ex)
            {
                ModelState.AddModelError(string.Empty, ex.Message);
                await LoadDropdowns();
                return View();
            }
        }

        // GET: Sale/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
                return NotFound();

            var sale = await _context.Sales
                .Include(s => s.Customer)
                .Include(s => s.PaymentMode)
                .FirstOrDefaultAsync(s => s.SalesID == id);

            if (sale == null)
                return NotFound();

            ViewData["BlockReason"] = await BuildBlockReason(id.Value);

            return View(sale);
        }

        // POST: Sale/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var sale = await _context.Sales.FindAsync(id);
            if (sale == null)
                return RedirectToAction(nameof(Index));

            var blockReason = await BuildBlockReason(id);
            if (blockReason != null)
            {
                TempData["DeleteError"] = blockReason;
                return RedirectToAction(nameof(Delete), new { id });
            }

            try
            {
                _context.Sales.Remove(sale);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                TempData["DeleteError"] =
                    "Can't delete this sale. It still has related records elsewhere in the system.";
                return RedirectToAction(nameof(Delete), new { id });
            }

            return RedirectToAction(nameof(Index));
        }

        // Sale -> SaleDetail cascades, but a Warranty referencing one of those
        // lines is ON DELETE RESTRICT, which blocks the cascade. Note: deleting a
        // sale does NOT reverse the inventory OUT transactions it posted.
        private async Task<string?> BuildBlockReason(int saleId)
        {
            var warranties = await _context.Warranties
                .CountAsync(w => w.SalesDetail != null && w.SalesDetail.SalesID == saleId);

            if (warranties == 0)
                return null;

            return $"Can't delete this sale. {warranties} warranty record{(warranties == 1 ? "" : "s")} " +
                   "still reference its line items. Remove those first.";
        }

        private string CurrentUserId =>
            User.FindFirstValue(ClaimTypes.NameIdentifier)!;

        private async Task LoadDropdowns()
        {
            ViewData["CustomerID"] = new SelectList(
                await _context.Customers.OrderBy(c => c.FullName).ToListAsync(),
                "CustomerID", "FullName");

            var vehicles = await _context.Vehicles
                .Include(v => v.Customer)
                .OrderBy(v => v.PlateNumber)
                .Select(v => new
                {
                    v.VehicleID,
                    Display = (v.PlateNumber ?? "No Plate") + " - " + v.Brand + " " + v.Model + " (" + v.Customer.FullName + ")"
                })
                .ToListAsync();
            ViewData["VehicleID"] = new SelectList(vehicles, "VehicleID", "Display");

            ViewData["PaymentModeID"] = new SelectList(
                await _context.PaymentModes.OrderBy(p => p.PaymentModeName).ToListAsync(),
                "PaymentModeID", "PaymentModeName");

            ViewData["Products"] = await _context.Products
                .Where(p => p.IsActive)
                .OrderBy(p => p.ProductName)
                .ToListAsync();
        }
    }
}