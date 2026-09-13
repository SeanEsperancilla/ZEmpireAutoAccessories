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
    [ModuleAuthorize("Service Invoices")]
    public class ServiceInvoiceController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly IQuotationService _quotationService; // GetNextInvoiceNumber lives here

        public ServiceInvoiceController(ApplicationDbContext context, IQuotationService quotationService)
        {
            _context = context;
            _quotationService = quotationService;
        }

        // GET: ServiceInvoice?status=Paid
        public async Task<IActionResult> Index(string? status)
        {
            var invoices = await _context.ServiceInvoices
                .Include(i => i.Customer)
                .Include(i => i.Vehicle)
                .Include(i => i.JobOrder)
                .Include(i => i.PaymentMode)
                .Where(i => status == null || i.Status == status)
                .OrderByDescending(i => i.InvoiceDate)
                .ToListAsync();

            ViewData["Status"] = status;
            return View(invoices);
        }

        // GET: ServiceInvoice/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
                return NotFound();

            var invoice = await _context.ServiceInvoices
                .Include(i => i.Customer)
                .Include(i => i.Vehicle)
                .Include(i => i.JobOrder)
                .Include(i => i.PaymentMode)
                .Include(i => i.Details)
                    .ThenInclude(d => d.Product)
                .Include(i => i.Details)
                    .ThenInclude(d => d.Service)
                .Include(i => i.Details)
                    .ThenInclude(d => d.TintVariant)
                .Include(i => i.Details)
                    .ThenInclude(d => d.Panel)
                .FirstOrDefaultAsync(i => i.ServiceInvoiceID == id);

            if (invoice == null)
                return NotFound();

            await LoadLineDropdowns();

            // Every Pricing row for this invoice's vehicle classification,
            // for the Add Line Item form to look up the real matrix price
            // (Product x Tint Variant x Panel) client-side instead of just
            // the product's flat DefaultPrice. Empty when there's no vehicle
            // on this invoice, since there's no classification to price by.
            if (invoice.Vehicle == null)
            {
                ViewData["PricingMatrix"] = new List<object>();
            }
            else
            {
                ViewData["PricingMatrix"] = await _context.Pricings
                    .Where(p => p.VehicleClassificationID == invoice.Vehicle.VehicleClassificationID)
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
            }

            return View(invoice);
        }

        // GET: ServiceInvoice/VehiclesForCustomer?customerId=5
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

        // GET: ServiceInvoice/JobOrdersForCustomer?customerId=5
        public async Task<IActionResult> JobOrdersForCustomer(int customerId, int? excludeInvoiceId)
        {
            var jobOrders = await _context.JobOrders
                .Include(j => j.Vehicle)
                .Where(j => j.CustomerID == customerId &&
                            (j.Status == "Completed" || j.Status == "Posted") &&
                            !_context.ServiceInvoices.Any(i =>
                                i.JobOrderID == j.JobOrderID &&
                                (excludeInvoiceId == null || i.ServiceInvoiceID != excludeInvoiceId)))
                .OrderByDescending(j => j.JobOrderDate)
                .Select(j => new
                {
                    value = j.JobOrderID,
                    text = j.JobOrderNumber + " - " + (j.Vehicle.PlateNumber ?? "No Plate")
                })
                .ToListAsync();

            return Json(jobOrders);
        }

        // GET: ServiceInvoice/Pdf/5
        public async Task<IActionResult> Pdf(int? id)
        {
            if (id == null)
                return NotFound();

            var invoice = await _context.ServiceInvoices
                .Include(i => i.Customer)
                .Include(i => i.Vehicle)
                .Include(i => i.JobOrder)
                .Include(i => i.PaymentMode)
                .Include(i => i.User)
                .Include(i => i.Details)
                    .ThenInclude(d => d.Product)
                .Include(i => i.Details)
                    .ThenInclude(d => d.Service)
                .FirstOrDefaultAsync(i => i.ServiceInvoiceID == id);

            if (invoice == null)
                return NotFound();

            var pdf = DocumentPdfBuilder.BuildServiceInvoicePdf(invoice);
            return File(pdf, "application/pdf", $"{invoice.InvoiceNumber}.pdf");
        }

        // GET: ServiceInvoice/Create?jobOrderId=5
        public async Task<IActionResult> Create(int? jobOrderId)
        {
            var invoice = new ServiceInvoice { InvoiceDate = DateTime.Now };

            if (jobOrderId != null)
            {
                var jobOrder = await _context.JobOrders.FindAsync(jobOrderId.Value);
                if (jobOrder == null)
                    return NotFound();

                if (jobOrder.Status != "Completed" && jobOrder.Status != "Posted")
                {
                    TempData["LockError"] = "Only a Completed or Posted job order can be invoiced.";
                    return RedirectToAction("Details", "JobOrder", new { id = jobOrderId });
                }

                if (await _context.ServiceInvoices.AnyAsync(i => i.JobOrderID == jobOrderId))
                {
                    TempData["LockError"] = "This job order has already been invoiced.";
                    return RedirectToAction("Details", "JobOrder", new { id = jobOrderId });
                }

                invoice.CustomerID = jobOrder.CustomerID;
                invoice.VehicleID = jobOrder.VehicleID;
                invoice.JobOrderID = jobOrder.JobOrderID;
                ViewData["FromJobOrderNumber"] = jobOrder.JobOrderNumber;
            }

            await LoadHeaderDropdowns(invoice);
            return View(invoice);
        }

        // POST: ServiceInvoice/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(
            [Bind("CustomerID,VehicleID,JobOrderID,PaymentModeID,Remarks")] ServiceInvoice invoice)
        {
            ModelState.Remove(nameof(ServiceInvoice.InvoiceNumber));
            ModelState.Remove(nameof(ServiceInvoice.UserId));
            ModelState.Remove(nameof(ServiceInvoice.Customer));
            ModelState.Remove(nameof(ServiceInvoice.User));
            ModelState.Remove(nameof(ServiceInvoice.PaymentMode));
            ModelState.Remove(nameof(ServiceInvoice.InvoiceNoSeries));

            if (!ModelState.IsValid)
            {
                await LoadHeaderDropdowns(invoice);
                return View(invoice);
            }

            if (invoice.JobOrderID != null && await _context.ServiceInvoices.AnyAsync(i => i.JobOrderID == invoice.JobOrderID))
            {
                TempData["LockError"] = "This job order has already been invoiced.";
                return RedirectToAction("Details", "JobOrder", new { id = invoice.JobOrderID });
            }

            var (invoiceNumber, seriesId) = await _quotationService.GetNextInvoiceNumber(CurrentUserId);

            invoice.InvoiceNumber = invoiceNumber;
            invoice.InvoiceNoSeriesID = seriesId;
            invoice.UserId = CurrentUserId;
            invoice.InvoiceDate = DateTime.Now;
            invoice.CreatedAt = DateTime.Now;
            invoice.Status = "Paid";

            _context.ServiceInvoices.Add(invoice);
            await _context.SaveChangesAsync();

            // Carry the job order's own line items over so staff don't have
            // to re-enter everything that was already worked out there.
            if (invoice.JobOrderID != null)
            {
                var jobOrderDetails = await _context.JobOrderDetails
                    .Include(d => d.Product)
                    .Include(d => d.Service)
                    .Where(d => d.JobOrderID == invoice.JobOrderID)
                    .ToListAsync();

                foreach (var d in jobOrderDetails)
                {
                    _context.ServiceInvoiceDetails.Add(new ServiceInvoiceDetail
                    {
                        ServiceInvoiceID = invoice.ServiceInvoiceID,
                        ProductID = d.ProductID,
                        ServiceID = d.ServiceID,
                        TintVariantID = d.TintVariantID,
                        ShadeID = d.ShadeID,
                        PanelID = d.PanelID,
                        Description = d.Description ?? d.Product?.ProductName ?? d.Service?.ServiceName ?? "Item",
                        Quantity = d.Quantity,
                        Unit = d.Unit,
                        UnitPrice = d.UnitPrice
                    });
                }

                if (jobOrderDetails.Count > 0)
                {
                    await _context.SaveChangesAsync();

                    // Same load-then-recalc sequence AddLine uses below - reload
                    // the just-saved details onto the tracked invoice instance
                    // itself rather than re-querying a separate instance.
                    await _context.Entry(invoice).Collection(i => i.Details).LoadAsync();
                    RecalculateTotals(invoice);
                    await _context.SaveChangesAsync();
                }
            }

            return RedirectToAction(nameof(Details), new { id = invoice.ServiceInvoiceID });
        }

        // GET: ServiceInvoice/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
                return NotFound();

            var invoice = await _context.ServiceInvoices.FindAsync(id);
            if (invoice == null)
                return NotFound();

            await LoadHeaderDropdowns(invoice);
            return View(invoice);
        }

        // POST: ServiceInvoice/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(
            int id,
            [Bind("ServiceInvoiceID,CustomerID,VehicleID,JobOrderID,PaymentModeID,DiscountAmount,TaxAmount,AmountPaid,Remarks")]
            ServiceInvoice invoice)
        {
            if (id != invoice.ServiceInvoiceID)
                return NotFound();

            ModelState.Remove(nameof(ServiceInvoice.InvoiceNumber));
            ModelState.Remove(nameof(ServiceInvoice.UserId));
            ModelState.Remove(nameof(ServiceInvoice.Customer));
            ModelState.Remove(nameof(ServiceInvoice.User));
            ModelState.Remove(nameof(ServiceInvoice.PaymentMode));
            ModelState.Remove(nameof(ServiceInvoice.InvoiceNoSeries));

            if (!ModelState.IsValid)
            {
                await LoadHeaderDropdowns(invoice);
                return View(invoice);
            }

            var existing = await _context.ServiceInvoices
                .Include(i => i.Details)
                .FirstOrDefaultAsync(i => i.ServiceInvoiceID == id);
            if (existing == null)
                return NotFound();

            existing.CustomerID = invoice.CustomerID;
            existing.VehicleID = invoice.VehicleID;
            existing.JobOrderID = invoice.JobOrderID;
            existing.PaymentModeID = invoice.PaymentModeID;
            existing.DiscountAmount = invoice.DiscountAmount;
            existing.TaxAmount = invoice.TaxAmount;
            existing.AmountPaid = invoice.AmountPaid;
            existing.Remarks = invoice.Remarks;

            RecalculateTotals(existing);
            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Details), new { id });
        }

        // GET: ServiceInvoice/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
                return NotFound();

            var invoice = await _context.ServiceInvoices
                .Include(i => i.Customer)
                .Include(i => i.PaymentMode)
                .FirstOrDefaultAsync(i => i.ServiceInvoiceID == id);

            if (invoice == null)
                return NotFound();

            ViewData["BlockReason"] = await BuildBlockReason(id.Value);

            return View(invoice);
        }

        // POST: ServiceInvoice/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var invoice = await _context.ServiceInvoices.FindAsync(id);
            if (invoice == null)
                return RedirectToAction(nameof(Index));

            var blockReason = await BuildBlockReason(id);
            if (blockReason != null)
            {
                TempData["DeleteError"] = blockReason;
                return RedirectToAction(nameof(Delete), new { id });
            }

            try
            {
                _context.ServiceInvoices.Remove(invoice);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                TempData["DeleteError"] =
                    "Can't delete this invoice. It still has related records elsewhere in the system.";
                return RedirectToAction(nameof(Delete), new { id });
            }

            return RedirectToAction(nameof(Index));
        }

        // POST: ServiceInvoice/AddLine
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AddLine(
            int serviceInvoiceId,
            int? productId,
            int? serviceId,
            int? tintVariantId,
            int? panelId,
            string description,
            decimal quantity,
            string unit,
            decimal unitPrice,
            decimal discountAmount)
        {
            var invoice = await _context.ServiceInvoices
                .Include(i => i.Details)
                .FirstOrDefaultAsync(i => i.ServiceInvoiceID == serviceInvoiceId);

            if (invoice == null)
                return NotFound();

            if (quantity > 0 && unitPrice >= 0 && !string.IsNullOrWhiteSpace(description))
            {
                _context.ServiceInvoiceDetails.Add(new ServiceInvoiceDetail
                {
                    ServiceInvoiceID = serviceInvoiceId,
                    ProductID = productId,
                    ServiceID = serviceId,
                    TintVariantID = productId != null ? tintVariantId : null,
                    PanelID = productId != null ? panelId : null,
                    Description = description,
                    Quantity = quantity,
                    Unit = string.IsNullOrWhiteSpace(unit) ? "Unit" : unit,
                    UnitPrice = unitPrice,
                    DiscountAmount = discountAmount
                });

                await _context.SaveChangesAsync();

                await _context.Entry(invoice).Collection(i => i.Details).LoadAsync();
                RecalculateTotals(invoice);
                await _context.SaveChangesAsync();
            }

            return RedirectToAction(nameof(Details), new { id = serviceInvoiceId });
        }

        // POST: ServiceInvoice/RemoveLine
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> RemoveLine(int detailId, int serviceInvoiceId)
        {
            var detail = await _context.ServiceInvoiceDetails.FindAsync(detailId);
            if (detail != null)
            {
                _context.ServiceInvoiceDetails.Remove(detail);
                await _context.SaveChangesAsync();

                var invoice = await _context.ServiceInvoices
                    .Include(i => i.Details)
                    .FirstOrDefaultAsync(i => i.ServiceInvoiceID == serviceInvoiceId);
                if (invoice != null)
                {
                    RecalculateTotals(invoice);
                    await _context.SaveChangesAsync();
                }
            }

            return RedirectToAction(nameof(Details), new { id = serviceInvoiceId });
        }

        // POST: ServiceInvoice/SetStatus
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SetStatus(int id, string status)
        {
            var allowed = new[] { "Paid", "Pending", "Cancelled", "Refunded" };
            if (!allowed.Contains(status))
                return BadRequest();

            var invoice = await _context.ServiceInvoices.FindAsync(id);
            if (invoice != null)
            {
                invoice.Status = status;
                await _context.SaveChangesAsync();
            }

            return RedirectToAction(nameof(Details), new { id });
        }

        private static void RecalculateTotals(ServiceInvoice invoice)
        {
            invoice.SubTotal = invoice.Details.Sum(d => d.SubTotal);
            invoice.TotalAmount = invoice.SubTotal - invoice.DiscountAmount + invoice.TaxAmount;

            // CK_ServiceInvoice_Change requires ChangeAmount >= 0, and
            // CK_ServiceInvoice_Math requires ChangeAmount = AmountPaid -
            // TotalAmount exactly - together, AmountPaid can never trail
            // TotalAmount on a saved row. Line items can be added before an
            // exact amount tendered is known, so keep AmountPaid caught up
            // to the total as it grows; Edit can still set the real amount
            // (and any real change) once that's known.
            if (invoice.AmountPaid < invoice.TotalAmount)
            {
                invoice.AmountPaid = invoice.TotalAmount;
            }

            invoice.ChangeAmount = invoice.AmountPaid - invoice.TotalAmount;
        }

        // ServiceInvoice -> ServiceInvoiceDetail cascades, but a Warranty referencing
        // one of those lines is ON DELETE RESTRICT, which blocks the cascade.
        private async Task<string?> BuildBlockReason(int invoiceId)
        {
            var warranties = await _context.Warranties
                .CountAsync(w => w.ServiceInvoiceDetail != null && w.ServiceInvoiceDetail.ServiceInvoiceID == invoiceId);

            if (warranties == 0)
                return null;

            return $"Can't delete this invoice. {warranties} warranty record{(warranties == 1 ? "" : "s")} " +
                   "still reference its line items. Remove those first.";
        }

        private string CurrentUserId =>
            User.FindFirstValue(ClaimTypes.NameIdentifier)!;

        private async Task LoadHeaderDropdowns(ServiceInvoice? invoice = null)
        {
            ViewData["CustomerID"] = new SelectList(
                await _context.Customers.OrderBy(c => c.FullName).ToListAsync(),
                "CustomerID", "FullName", invoice?.CustomerID);

            var vehicles = await _context.Vehicles
                .Include(v => v.Customer)
                .OrderBy(v => v.PlateNumber)
                .Select(v => new
                {
                    v.VehicleID,
                    Display = (v.PlateNumber ?? "No Plate") + " - " + v.Brand + " " + v.Model + " (" + v.Customer.FullName + ")"
                })
                .ToListAsync();
            ViewData["VehicleID"] = new SelectList(vehicles, "VehicleID", "Display", invoice?.VehicleID);

            var jobOrders = await _context.JobOrders
                .OrderByDescending(j => j.JobOrderDate)
                .Select(j => new { j.JobOrderID, Display = j.JobOrderNumber })
                .ToListAsync();
            ViewData["JobOrderID"] = new SelectList(jobOrders, "JobOrderID", "Display", invoice?.JobOrderID);

            ViewData["PaymentModeID"] = new SelectList(
                await _context.PaymentModes.OrderBy(p => p.PaymentModeName).ToListAsync(),
                "PaymentModeID", "PaymentModeName", invoice?.PaymentModeID);
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
