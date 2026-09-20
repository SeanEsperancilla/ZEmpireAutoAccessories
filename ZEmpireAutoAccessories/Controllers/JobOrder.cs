using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Authorization;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;
using ZEmpireAutoAccessories.Services;

namespace ZEmpireAutoAccessories.Controllers
{
    [ModuleAuthorize("Job Orders")]
    public class JobOrderController : Controller
    {
        private readonly ApplicationDbContext _context;

        public JobOrderController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: JobOrder?status=Pending&q=...
        public async Task<IActionResult> Index(string? status, string? q)
        {
            var query = _context.JobOrders
                .Include(j => j.Customer)
                .Include(j => j.Vehicle)
                .Include(j => j.AssignedEmployee)
                .Include(j => j.Quotation)
                .Include(j => j.ServiceInvoices)
                .Where(j => status == null || j.Status == status);

            if (!string.IsNullOrWhiteSpace(q))
            {
                var term = q.Trim();
                query = query.Where(j =>
                    j.JobOrderNumber.Contains(term) ||
                    j.Customer.FullName.Contains(term) ||
                    (j.Vehicle.PlateNumber != null && j.Vehicle.PlateNumber.Contains(term)));
            }

            var jobOrders = await query
                .OrderByDescending(j => j.JobOrderDate)
                .ToListAsync();

            ViewData["Status"] = status;
            ViewData["Search"] = q;
            return View(jobOrders);
        }

        // GET: JobOrder/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
                return NotFound();

            var jobOrder = await _context.JobOrders
                .Include(j => j.Customer)
                .Include(j => j.Vehicle)
                .Include(j => j.JobType)
                .Include(j => j.AssignedEmployee)
                .Include(j => j.Quotation)
                .Include(j => j.ServiceInvoices)
                .Include(j => j.Details)
                    .ThenInclude(d => d.Product)
                .Include(j => j.Details)
                    .ThenInclude(d => d.Service)
                .Include(j => j.Details)
                    .ThenInclude(d => d.TintVariant)
                .Include(j => j.Details)
                    .ThenInclude(d => d.Panel)
                .FirstOrDefaultAsync(j => j.JobOrderID == id);

            if (jobOrder == null)
                return NotFound();

            await LoadLineDropdowns();

            // Every Pricing row for this job order's vehicle classification,
            // for the Add Line Item form to look up the real matrix price
            // (Product x Tint Variant x Panel) client-side instead of just
            // the product's flat DefaultPrice.
            ViewData["PricingMatrix"] = await _context.Pricings
                .Where(p => p.VehicleClassificationID == jobOrder.Vehicle.VehicleClassificationID)
                .Select(p => new
                {
                    productId = p.ProductID,
                    tintVariantId = p.TintVariantID,
                    tintVariantName = p.TintVariant != null ? p.TintVariant.VariantName : null,
                    panelId = p.PanelID,
                    panelName = p.Panel.PanelName,
                    price = p.Price
                })
                .ToListAsync();

            return View(jobOrder);
        }

        // GET: JobOrder/VehiclesForCustomer?customerId=5
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

        // GET: JobOrder/Pdf/5
        public async Task<IActionResult> Pdf(int? id)
        {
            if (id == null)
                return NotFound();

            var jobOrder = await _context.JobOrders
                .Include(j => j.Customer)
                .Include(j => j.Vehicle)
                .Include(j => j.JobType)
                .Include(j => j.AssignedEmployee)
                .Include(j => j.Details)
                    .ThenInclude(d => d.Product)
                .Include(j => j.Details)
                    .ThenInclude(d => d.Service)
                .FirstOrDefaultAsync(j => j.JobOrderID == id);

            if (jobOrder == null)
                return NotFound();

            var pdf = DocumentPdfBuilder.BuildJobOrderPdf(jobOrder);
            return File(pdf, "application/pdf", $"{jobOrder.JobOrderNumber}.pdf");
        }

        // GET: JobOrder/Create
        public async Task<IActionResult> Create()
        {
            await LoadHeaderDropdowns();
            return View(new JobOrder { JobOrderDate = DateTime.Now });
        }

        // POST: JobOrder/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(
            [Bind("CustomerID,VehicleID,JobTypeID,AssignedEmployeeID,InstallationDate,ExistingFilmShade,ReasonForChanging,SpecialInstruction,Complaint,Odometer")]
            JobOrder jobOrder)
        {
            ModelState.Remove(nameof(JobOrder.JobOrderNumber));
            ModelState.Remove(nameof(JobOrder.UserId));
            ModelState.Remove(nameof(JobOrder.Customer));
            ModelState.Remove(nameof(JobOrder.Vehicle));
            ModelState.Remove(nameof(JobOrder.User));

            if (!ModelState.IsValid)
            {
                await LoadHeaderDropdowns(jobOrder);
                return View(jobOrder);
            }

            jobOrder.UserId = CurrentUserId;
            jobOrder.JobOrderDate = DateTime.Now;
            jobOrder.Status = "Pending";
            jobOrder.JobOrderNumber = "PENDING";

            _context.JobOrders.Add(jobOrder);
            await _context.SaveChangesAsync();

            // Number depends on the generated ID, so it's set in a second save.
            jobOrder.JobOrderNumber = $"JO-{jobOrder.JobOrderID:D6}";
            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Details), new { id = jobOrder.JobOrderID });
        }

        // GET: JobOrder/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
                return NotFound();

            var jobOrder = await _context.JobOrders.FindAsync(id);
            if (jobOrder == null)
                return NotFound();

            await LoadHeaderDropdowns(jobOrder);
            return View(jobOrder);
        }

        // POST: JobOrder/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(
            int id,
            [Bind("JobOrderID,CustomerID,VehicleID,JobTypeID,AssignedEmployeeID,InstallationDate,ExistingFilmShade,ReasonForChanging,SpecialInstruction,Complaint,Odometer")]
            JobOrder jobOrder)
        {
            if (id != jobOrder.JobOrderID)
                return NotFound();

            ModelState.Remove(nameof(JobOrder.JobOrderNumber));
            ModelState.Remove(nameof(JobOrder.UserId));
            ModelState.Remove(nameof(JobOrder.Customer));
            ModelState.Remove(nameof(JobOrder.Vehicle));
            ModelState.Remove(nameof(JobOrder.User));

            if (!ModelState.IsValid)
            {
                await LoadHeaderDropdowns(jobOrder);
                return View(jobOrder);
            }

            var existing = await _context.JobOrders.FindAsync(id);
            if (existing == null)
                return NotFound();

            existing.CustomerID = jobOrder.CustomerID;
            existing.VehicleID = jobOrder.VehicleID;
            existing.JobTypeID = jobOrder.JobTypeID;
            existing.AssignedEmployeeID = jobOrder.AssignedEmployeeID;
            existing.InstallationDate = jobOrder.InstallationDate;
            existing.ExistingFilmShade = jobOrder.ExistingFilmShade;
            existing.ReasonForChanging = jobOrder.ReasonForChanging;
            existing.SpecialInstruction = jobOrder.SpecialInstruction;
            existing.Complaint = jobOrder.Complaint;
            existing.Odometer = jobOrder.Odometer;

            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Details), new { id });
        }

        // GET: JobOrder/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
                return NotFound();

            var jobOrder = await _context.JobOrders
                .Include(j => j.Customer)
                .Include(j => j.Vehicle)
                .FirstOrDefaultAsync(j => j.JobOrderID == id);

            if (jobOrder == null)
                return NotFound();

            ViewData["BlockReason"] = await BuildBlockReason(id.Value);

            return View(jobOrder);
        }

        // POST: JobOrder/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var jobOrder = await _context.JobOrders.FindAsync(id);
            if (jobOrder == null)
                return RedirectToAction(nameof(Index));

            var blockReason = await BuildBlockReason(id);
            if (blockReason != null)
            {
                TempData["DeleteError"] = blockReason;
                return RedirectToAction(nameof(Delete), new { id });
            }

            try
            {
                _context.JobOrders.Remove(jobOrder);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                TempData["DeleteError"] =
                    "Can't delete this job order. It still has related records elsewhere in the system.";
                return RedirectToAction(nameof(Delete), new { id });
            }

            return RedirectToAction(nameof(Index));
        }

        // POST: JobOrder/AddLine
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AddLine(
            int jobOrderId,
            int? productId,
            int? serviceId,
            int? tintVariantId,
            int? panelId,
            string? description,
            int quantity,
            string unit,
            decimal unitPrice)
        {
            var jobOrder = await _context.JobOrders
                .Include(j => j.Vehicle)
                .FirstOrDefaultAsync(j => j.JobOrderID == jobOrderId);

            if (jobOrder == null)
                return NotFound();

            if (quantity > 0 && unitPrice >= 0 && (productId != null || serviceId != null))
            {
                // Record which exact Pricing row (Product x Tint Variant x
                // Vehicle Classification x Panel) this line's price came from,
                // when the Add Line Item form resolved one client-side.
                int? pricingId = null;
                if (productId != null && panelId != null)
                {
                    pricingId = await _context.Pricings
                        .Where(p =>
                            p.ProductID == productId &&
                            p.TintVariantID == tintVariantId &&
                            p.VehicleClassificationID == jobOrder.Vehicle.VehicleClassificationID &&
                            p.PanelID == panelId)
                        .Select(p => (int?)p.PricingID)
                        .FirstOrDefaultAsync();
                }

                _context.JobOrderDetails.Add(new JobOrderDetail
                {
                    JobOrderID = jobOrderId,
                    ProductID = productId,
                    ServiceID = serviceId,
                    TintVariantID = pricingId != null ? tintVariantId : null,
                    PanelID = pricingId != null ? panelId : null,
                    PricingID = pricingId,
                    Description = description,
                    Quantity = quantity,
                    Unit = string.IsNullOrWhiteSpace(unit) ? "Unit" : unit,
                    UnitPrice = unitPrice
                });

                await _context.SaveChangesAsync();
            }

            return RedirectToAction(nameof(Details), new { id = jobOrderId });
        }

        // POST: JobOrder/RemoveLine
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> RemoveLine(int detailId, int jobOrderId)
        {
            var detail = await _context.JobOrderDetails.FindAsync(detailId);
            if (detail != null)
            {
                _context.JobOrderDetails.Remove(detail);
                await _context.SaveChangesAsync();
            }

            return RedirectToAction(nameof(Details), new { id = jobOrderId });
        }

        // POST: JobOrder/SetStatus
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SetStatus(int id, string status)
        {
            var allowed = new[] { "Pending", "In Progress", "Completed", "Cancelled" };
            if (!allowed.Contains(status))
                return BadRequest();

            var jobOrder = await _context.JobOrders.FindAsync(id);
            if (jobOrder != null)
            {
                jobOrder.Status = status;
                await _context.SaveChangesAsync();
            }

            return RedirectToAction(nameof(Details), new { id });
        }

        // JobOrder is ON DELETE RESTRICT from ServiceInvoice, VehicleChecklist and Warranty.
        private async Task<string?> BuildBlockReason(int jobOrderId)
        {
            var invoices = await _context.ServiceInvoices.CountAsync(i => i.JobOrderID == jobOrderId);
            var checklists = await _context.VehicleChecklists.CountAsync(c => c.JobOrderID == jobOrderId);
            var warranties = await _context.Warranties.CountAsync(w => w.JobOrderID == jobOrderId);

            var parts = new List<string>();
            if (invoices > 0) { parts.Add($"{invoices} service invoice{(invoices == 1 ? "" : "s")}"); }
            if (checklists > 0) { parts.Add($"{checklists} vehicle checklist{(checklists == 1 ? "" : "s")}"); }
            if (warranties > 0) { parts.Add($"{warranties} warranty record{(warranties == 1 ? "" : "s")}"); }

            if (parts.Count == 0)
                return null;

            return "Can't delete this job order. It still has " + string.Join(", ", parts) +
                   " linked to it. Remove those first.";
        }

        private string CurrentUserId =>
            User.FindFirstValue(ClaimTypes.NameIdentifier)!;

        private async Task LoadHeaderDropdowns(JobOrder? jobOrder = null)
        {
            ViewData["CustomerID"] = new SelectList(
                await _context.Customers.OrderBy(c => c.FullName).ToListAsync(),
                "CustomerID", "FullName", jobOrder?.CustomerID);

            var vehicles = await _context.Vehicles
                .Include(v => v.Customer)
                .OrderBy(v => v.PlateNumber)
                .Select(v => new
                {
                    v.VehicleID,
                    Display = (v.PlateNumber ?? "No Plate") + " - " + v.Brand + " " + v.Model + " (" + v.Customer.FullName + ")"
                })
                .ToListAsync();
            ViewData["VehicleID"] = new SelectList(vehicles, "VehicleID", "Display", jobOrder?.VehicleID);

            ViewData["JobTypeID"] = new SelectList(
                await _context.JobTypes.OrderBy(j => j.JobTypeName).ToListAsync(),
                "JobTypeID", "JobTypeName", jobOrder?.JobTypeID);

            var employees = await _context.Employees
                .Where(e => e.IsActive)
                .OrderBy(e => e.LastName)
                .Select(e => new { e.EmployeeID, Display = e.FirstName + " " + e.LastName })
                .ToListAsync();
            ViewData["AssignedEmployeeID"] = new SelectList(employees, "EmployeeID", "Display", jobOrder?.AssignedEmployeeID);
        }

        // Rendered as plain <option> tags in the view (not asp-items) so each
        // one can carry a data-price attribute - SelectListItem has no
        // attribute bag to hang that off of.
        private async Task LoadLineDropdowns()
        {
            ViewData["Products"] = await _context.Products.Where(p => p.IsActive).OrderBy(p => p.ProductName).ToListAsync();
            ViewData["Services"] = await _context.Services.Where(s => s.IsActive).OrderBy(s => s.ServiceName).ToListAsync();
        }
    }
}
