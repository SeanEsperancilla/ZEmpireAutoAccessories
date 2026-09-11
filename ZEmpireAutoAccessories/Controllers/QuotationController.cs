using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Authorization;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;
using ZEmpireAutoAccessories.Services;
using ZEmpireAutoAccessories.Services.Interfaces;

namespace ZEmpireAutoAccessories.Controllers
{
    [ModuleAuthorize("Quotation")]
    public class QuotationController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly IQuotationService _quotationService;

        public QuotationController(ApplicationDbContext context, IQuotationService quotationService)
        {
            _context = context;
            _quotationService = quotationService;
        }

        // GET: Quotation?status=Draft&q=...
        public async Task<IActionResult> Index(string? status, string? q)
        {
            var query = _context.Quotations
                .Include(quotation => quotation.Customer)
                .Include(quotation => quotation.Vehicle)
                .Include(quotation => quotation.JobOrder)
                .Where(quotation => status == null || quotation.Status == status);

            if (!string.IsNullOrWhiteSpace(q))
            {
                var term = q.Trim();
                query = query.Where(quotation =>
                    quotation.QuotationNumber.Contains(term) ||
                    quotation.Customer.FullName.Contains(term) ||
                    (quotation.Vehicle.PlateNumber != null && quotation.Vehicle.PlateNumber.Contains(term)));
            }

            var quotations = await query
                .OrderByDescending(quotation => quotation.QuotationDate)
                .ToListAsync();

            ViewData["Status"] = status;
            ViewData["Search"] = q;
            return View(quotations);
        }

        // GET: Quotation/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
                return NotFound();

            var quotation = await _quotationService.GetQuotation(id.Value);
            if (quotation == null)
                return NotFound();

            await LoadLineDropdowns();
            return View(quotation);
        }

        // GET: Quotation/VehiclesForCustomer?customerId=5
        public async Task<IActionResult> VehiclesForCustomer(int customerId)
        {
            var vehicles = await _context.Vehicles
                .Where(v => v.CustomerID == customerId)
                .OrderBy(v => v.PlateNumber)
                .Select(v => new
                {
                    value = v.VehicleID,
                    text = (v.PlateNumber ?? "No Plate") + " - " + v.Brand + " " + v.Model
                })
                .ToListAsync();

            return Json(vehicles);
        }

        // GET: Quotation/Pdf/5
        public async Task<IActionResult> Pdf(int? id)
        {
            if (id == null)
                return NotFound();

            var quotation = await _quotationService.GetQuotation(id.Value);
            if (quotation == null)
                return NotFound();

            var pdf = DocumentPdfBuilder.BuildQuotationPdf(quotation);
            return File(pdf, "application/pdf", $"{quotation.QuotationNumber}.pdf");
        }

        // GET: Quotation/Create
        public async Task<IActionResult> Create()
        {
            await LoadHeaderDropdowns();
            return View(new Quotation { QuotationDate = DateTime.Now });
        }

        // POST: Quotation/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(
            [Bind("CustomerID,VehicleID,JobTypeID,ValidUntil,Remarks")] Quotation quotation)
        {
            ModelState.Remove(nameof(Quotation.QuotationNumber));
            ModelState.Remove(nameof(Quotation.UserId));
            ModelState.Remove(nameof(Quotation.Customer));
            ModelState.Remove(nameof(Quotation.Vehicle));
            ModelState.Remove(nameof(Quotation.User));

            if (!ModelState.IsValid)
            {
                await LoadHeaderDropdowns(quotation);
                return View(quotation);
            }

            quotation.UserId = CurrentUserId;
            quotation.QuotationDate = DateTime.Now;
            quotation.Status = "Draft";
            quotation.QuotationNumber = "PENDING";
            quotation.CreatedAt = DateTime.Now;

            _context.Quotations.Add(quotation);
            await _context.SaveChangesAsync();

            // Number depends on the generated ID, so it's set in a second save.
            quotation.QuotationNumber = $"QT-{quotation.QuotationID:D6}";
            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Details), new { id = quotation.QuotationID });
        }

        // GET: Quotation/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
                return NotFound();

            var quotation = await _context.Quotations.FindAsync(id);
            if (quotation == null)
                return NotFound();

            if (quotation.Status == "Posted")
            {
                TempData["LockError"] = "This quotation is posted and can no longer be edited.";
                return RedirectToAction(nameof(Details), new { id });
            }

            await LoadHeaderDropdowns(quotation);
            return View(quotation);
        }

        // POST: Quotation/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(
            int id,
            [Bind("QuotationID,CustomerID,VehicleID,JobTypeID,ValidUntil,DiscountAmount,TaxAmount,Remarks")] Quotation quotation)
        {
            if (id != quotation.QuotationID)
                return NotFound();

            ModelState.Remove(nameof(Quotation.QuotationNumber));
            ModelState.Remove(nameof(Quotation.UserId));
            ModelState.Remove(nameof(Quotation.Customer));
            ModelState.Remove(nameof(Quotation.Vehicle));
            ModelState.Remove(nameof(Quotation.User));

            if (!ModelState.IsValid)
            {
                await LoadHeaderDropdowns(quotation);
                return View(quotation);
            }

            var existing = await _context.Quotations
                .Include(q => q.Details)
                .FirstOrDefaultAsync(q => q.QuotationID == id);
            if (existing == null)
                return NotFound();

            if (existing.Status == "Posted")
            {
                TempData["LockError"] = "This quotation is posted and can no longer be edited.";
                return RedirectToAction(nameof(Details), new { id });
            }

            existing.CustomerID = quotation.CustomerID;
            existing.VehicleID = quotation.VehicleID;
            existing.JobTypeID = quotation.JobTypeID;
            existing.ValidUntil = quotation.ValidUntil;
            existing.DiscountAmount = quotation.DiscountAmount;
            existing.TaxAmount = quotation.TaxAmount;
            existing.Remarks = quotation.Remarks;

            RecalculateTotals(existing);
            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Details), new { id });
        }

        // GET: Quotation/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
                return NotFound();

            var quotation = await _context.Quotations
                .Include(q => q.Customer)
                .Include(q => q.Vehicle)
                .Include(q => q.JobOrder)
                .FirstOrDefaultAsync(q => q.QuotationID == id);

            if (quotation == null)
                return NotFound();

            return View(quotation);
        }

        // POST: Quotation/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var quotation = await _context.Quotations
                .Include(q => q.JobOrder)
                .FirstOrDefaultAsync(q => q.QuotationID == id);

            if (quotation == null)
                return RedirectToAction(nameof(Index));

            if (quotation.JobOrder != null)
            {
                TempData["DeleteError"] =
                    "Can't delete this quotation. It has already been converted to a job order.";
                return RedirectToAction(nameof(Delete), new { id });
            }

            if (quotation.Status == "Posted")
            {
                TempData["DeleteError"] = "Can't delete this quotation. It has been posted and is locked.";
                return RedirectToAction(nameof(Delete), new { id });
            }

            _context.Quotations.Remove(quotation);
            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Index));
        }

        // POST: Quotation/AddLine
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AddLine(
            int quotationId,
            int? productId,
            int? serviceId,
            string? description,
            int quantity,
            string unit,
            decimal unitPrice)
        {
            var quotation = await _context.Quotations
                .Include(q => q.Details)
                .FirstOrDefaultAsync(q => q.QuotationID == quotationId);

            if (quotation == null)
                return NotFound();

            if (quotation.Status == "Posted")
            {
                TempData["LockError"] = "This quotation is posted and can no longer be edited.";
                return RedirectToAction(nameof(Details), new { id = quotationId });
            }

            if (quantity > 0 && unitPrice >= 0 && (productId != null || serviceId != null))
            {
                _context.QuotationDetails.Add(new QuotationDetail
                {
                    QuotationID = quotationId,
                    ProductID = productId,
                    ServiceID = serviceId,
                    Description = description,
                    Quantity = quantity,
                    Unit = string.IsNullOrWhiteSpace(unit) ? "Unit" : unit,
                    UnitPrice = unitPrice
                });

                await _context.SaveChangesAsync();

                await _context.Entry(quotation).Collection(q => q.Details).LoadAsync();
                RecalculateTotals(quotation);
                await _context.SaveChangesAsync();
            }

            return RedirectToAction(nameof(Details), new { id = quotationId });
        }

        // POST: Quotation/RemoveLine
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> RemoveLine(int detailId, int quotationId)
        {
            var owner = await _context.Quotations.FindAsync(quotationId);
            if (owner?.Status == "Posted")
            {
                TempData["LockError"] = "This quotation is posted and can no longer be edited.";
                return RedirectToAction(nameof(Details), new { id = quotationId });
            }

            var detail = await _context.QuotationDetails.FindAsync(detailId);
            if (detail != null)
            {
                _context.QuotationDetails.Remove(detail);
                await _context.SaveChangesAsync();

                var quotation = await _context.Quotations
                    .Include(q => q.Details)
                    .FirstOrDefaultAsync(q => q.QuotationID == quotationId);
                if (quotation != null)
                {
                    RecalculateTotals(quotation);
                    await _context.SaveChangesAsync();
                }
            }

            return RedirectToAction(nameof(Details), new { id = quotationId });
        }

        // POST: Quotation/SetStatus
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SetStatus(int id, string status)
        {
            var allowed = new[] { "Draft", "Sent", "Accepted", "Rejected" };
            if (!allowed.Contains(status))
                return BadRequest();

            var quotation = await _context.Quotations.FindAsync(id);
            if (quotation != null)
            {
                if (quotation.Status == "Posted")
                {
                    TempData["LockError"] = "This quotation is posted and can no longer be edited.";
                    return RedirectToAction(nameof(Details), new { id });
                }

                quotation.Status = status;
                await _context.SaveChangesAsync();
            }

            return RedirectToAction(nameof(Details), new { id });
        }

        // GET: Quotation/Post/5
        public async Task<IActionResult> Post(int? id)
        {
            if (id == null)
                return NotFound();

            var quotation = await _context.Quotations
                .Include(q => q.Customer)
                .Include(q => q.Vehicle)
                .FirstOrDefaultAsync(q => q.QuotationID == id);

            if (quotation == null)
                return NotFound();

            if (quotation.Status != "Accepted")
            {
                TempData["LockError"] = "Only an Accepted quotation can be posted.";
                return RedirectToAction(nameof(Details), new { id });
            }

            return View(quotation);
        }

        // POST: Quotation/Post/5
        [HttpPost, ActionName("Post")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> PostConfirmed(int id)
        {
            var quotation = await _context.Quotations.FindAsync(id);
            if (quotation == null)
                return NotFound();

            if (quotation.Status != "Accepted")
            {
                TempData["LockError"] = "Only an Accepted quotation can be posted.";
                return RedirectToAction(nameof(Details), new { id });
            }

            quotation.Status = "Posted";
            await _context.SaveChangesAsync();

            TempData["Success"] = "Quotation posted. It's now locked from further edits.";
            return RedirectToAction(nameof(Details), new { id });
        }

        // POST: Quotation/Convert/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Convert(int id)
        {
            var quotation = await _context.Quotations
                .Include(q => q.JobOrder)
                .FirstOrDefaultAsync(q => q.QuotationID == id);

            if (quotation == null)
                return NotFound();

            if (quotation.JobOrder != null)
            {
                TempData["ConvertError"] = "This quotation has already been converted.";
                return RedirectToAction(nameof(Details), new { id });
            }

            if (quotation.Status == "Posted")
            {
                TempData["ConvertError"] = "This quotation is posted and can no longer be converted.";
                return RedirectToAction(nameof(Details), new { id });
            }

            var jobOrderNumber = $"JO-{DateTime.Now:yyyyMMddHHmmss}";

            try
            {
                var jobOrderId = await _quotationService.ConvertToJobOrder(id, CurrentUserId, jobOrderNumber);
                TempData["Success"] = $"Converted to Job Order #{jobOrderId} ({jobOrderNumber}).";
            }
            catch (Exception ex)
            {
                TempData["ConvertError"] = $"Conversion failed: {ex.Message}";
            }

            return RedirectToAction(nameof(Details), new { id });
        }

        private static void RecalculateTotals(Quotation quotation)
        {
            quotation.SubTotal = quotation.Details.Sum(d => d.Quantity * d.UnitPrice);
            quotation.TotalAmount = quotation.SubTotal - quotation.DiscountAmount + quotation.TaxAmount;
        }

        private string CurrentUserId =>
            User.FindFirstValue(ClaimTypes.NameIdentifier)!;

        private async Task LoadHeaderDropdowns(Quotation? quotation = null)
        {
            ViewData["CustomerID"] = new SelectList(
                await _context.Customers.OrderBy(c => c.FullName).ToListAsync(),
                "CustomerID", "FullName", quotation?.CustomerID);

            var vehicles = await _context.Vehicles
                .Include(v => v.Customer)
                .OrderBy(v => v.PlateNumber)
                .Select(v => new
                {
                    v.VehicleID,
                    Display = (v.PlateNumber ?? "No Plate") + " - " + v.Brand + " " + v.Model + " (" + v.Customer.FullName + ")"
                })
                .ToListAsync();
            ViewData["VehicleID"] = new SelectList(vehicles, "VehicleID", "Display", quotation?.VehicleID);

            ViewData["JobTypeID"] = new SelectList(
                await _context.JobTypes.OrderBy(j => j.JobTypeName).ToListAsync(),
                "JobTypeID", "JobTypeName", quotation?.JobTypeID);
        }

        private async Task LoadLineDropdowns()
        {
            ViewData["ProductID"] = new SelectList(
                await _context.Products.Where(p => p.IsActive).OrderBy(p => p.ProductName).ToListAsync(),
                "ProductID", "ProductName");

            ViewData["ServiceID"] = new SelectList(
                await _context.Services.Where(s => s.IsActive).OrderBy(s => s.ServiceName).ToListAsync(),
                "ServiceID", "ServiceName");
        }
    }
}
