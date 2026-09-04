using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Authorization;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Controllers
{
    [ModuleAuthorize("Warranty")]
    public class WarrantyController : Controller
    {
        private readonly ApplicationDbContext _context;

        private static readonly string[] StatusOptions = { "Active", "Expired", "Voided", "Claimed" };

        public WarrantyController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Warranty?status=Active
        public async Task<IActionResult> Index(string? status)
        {
            var warranties = await _context.Warranties
                .Include(w => w.SalesDetail).ThenInclude(d => d!.Sale)
                .Include(w => w.SalesDetail).ThenInclude(d => d!.Product)
                .Include(w => w.ServiceInvoiceDetail).ThenInclude(d => d!.ServiceInvoice)
                .Include(w => w.JobOrder)
                .Where(w => status == null || w.WarrantyStatus == status)
                .OrderByDescending(w => w.WarrantyID)
                .ToListAsync();

            ViewData["Status"] = status;
            return View(warranties);
        }

        // GET: Warranty/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
                return NotFound();

            var warranty = await _context.Warranties
                .Include(w => w.SalesDetail).ThenInclude(d => d!.Sale)
                .Include(w => w.SalesDetail).ThenInclude(d => d!.Product)
                .Include(w => w.ServiceInvoiceDetail).ThenInclude(d => d!.ServiceInvoice)
                .Include(w => w.ServiceInvoiceDetail).ThenInclude(d => d!.Product)
                .Include(w => w.ServiceInvoiceDetail).ThenInclude(d => d!.Service)
                .Include(w => w.JobOrder).ThenInclude(j => j!.Customer)
                .FirstOrDefaultAsync(w => w.WarrantyID == id);

            if (warranty == null)
                return NotFound();

            return View(warranty);
        }

        // GET: Warranty/Create
        public async Task<IActionResult> Create()
        {
            await LoadDropdowns();
            return View();
        }

        // POST: Warranty/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(
            [Bind("SalesDetailID,ServiceInvoiceDetailID,JobOrderID,WarrantyStartDate,WarrantyEndDate,WarrantyTerms,WarrantyStatus,Remarks")]
            Warranty warranty)
        {
            if (warranty.SalesDetailID == null && warranty.ServiceInvoiceDetailID == null && warranty.JobOrderID == null)
            {
                ModelState.AddModelError(string.Empty, "Link the warranty to a sale item, a service invoice item, or a job order.");
            }

            if (!ModelState.IsValid)
            {
                await LoadDropdowns(warranty);
                return View(warranty);
            }

            warranty.CreatedBy = User.FindFirst(AppClaims.FullName)?.Value ?? User.Identity?.Name;

            _context.Warranties.Add(warranty);
            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Details), new { id = warranty.WarrantyID });
        }

        // GET: Warranty/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
                return NotFound();

            var warranty = await _context.Warranties.FindAsync(id);
            if (warranty == null)
                return NotFound();

            await LoadDropdowns(warranty);
            return View(warranty);
        }

        // POST: Warranty/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(
            int id,
            [Bind("WarrantyID,SalesDetailID,ServiceInvoiceDetailID,JobOrderID,WarrantyStartDate,WarrantyEndDate,WarrantyTerms,WarrantyStatus,Remarks")]
            Warranty warranty)
        {
            if (id != warranty.WarrantyID)
                return NotFound();

            if (warranty.SalesDetailID == null && warranty.ServiceInvoiceDetailID == null && warranty.JobOrderID == null)
            {
                ModelState.AddModelError(string.Empty, "Link the warranty to a sale item, a service invoice item, or a job order.");
            }

            if (!ModelState.IsValid)
            {
                await LoadDropdowns(warranty);
                return View(warranty);
            }

            try
            {
                _context.Update(warranty);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!await _context.Warranties.AnyAsync(w => w.WarrantyID == id))
                    return NotFound();

                throw;
            }

            return RedirectToAction(nameof(Details), new { id });
        }

        // GET: Warranty/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
                return NotFound();

            var warranty = await _context.Warranties
                .Include(w => w.SalesDetail).ThenInclude(d => d!.Sale)
                .Include(w => w.ServiceInvoiceDetail).ThenInclude(d => d!.ServiceInvoice)
                .Include(w => w.JobOrder)
                .FirstOrDefaultAsync(w => w.WarrantyID == id);

            if (warranty == null)
                return NotFound();

            return View(warranty);
        }

        // POST: Warranty/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var warranty = await _context.Warranties.FindAsync(id);
            if (warranty == null)
                return RedirectToAction(nameof(Index));

            try
            {
                _context.Warranties.Remove(warranty);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                TempData["DeleteError"] =
                    "Can't delete this warranty. It still has related records elsewhere in the system.";
                return RedirectToAction(nameof(Delete), new { id });
            }

            return RedirectToAction(nameof(Index));
        }

        private async Task LoadDropdowns(Warranty? warranty = null)
        {
            ViewData["StatusOptions"] = StatusOptions;

            var saleDetails = await _context.SalesDetails
                .Include(d => d.Sale)
                .Include(d => d.Product)
                .OrderByDescending(d => d.SalesDetailID)
                .Select(d => new
                {
                    d.SalesDetailID,
                    Display = d.Sale.InvoiceNumber + " — " + d.Product.ProductName + " (Qty " + d.Quantity + ")"
                })
                .ToListAsync();
            ViewData["SalesDetailID"] = new SelectList(saleDetails, "SalesDetailID", "Display", warranty?.SalesDetailID);

            var invoiceDetails = await _context.ServiceInvoiceDetails
                .Include(d => d.ServiceInvoice)
                .OrderByDescending(d => d.ServiceInvoiceDetailID)
                .Select(d => new
                {
                    d.ServiceInvoiceDetailID,
                    Display = d.ServiceInvoice.InvoiceNumber + " — " + d.Description
                })
                .ToListAsync();
            ViewData["ServiceInvoiceDetailID"] = new SelectList(invoiceDetails, "ServiceInvoiceDetailID", "Display", warranty?.ServiceInvoiceDetailID);

            var jobOrders = await _context.JobOrders
                .Include(j => j.Customer)
                .OrderByDescending(j => j.JobOrderID)
                .Select(j => new
                {
                    j.JobOrderID,
                    Display = j.JobOrderNumber + " — " + j.Customer.FullName
                })
                .ToListAsync();
            ViewData["JobOrderID"] = new SelectList(jobOrders, "JobOrderID", "Display", warranty?.JobOrderID);
        }
    }
}