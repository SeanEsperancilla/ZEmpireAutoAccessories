using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Authorization;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Controllers
{
    [ModuleAuthorize("Vehicles")]
    public class VehicleController : Controller
    {
        private readonly ApplicationDbContext _context;

        public VehicleController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Vehicle?q=...&customerId=...
        public async Task<IActionResult> Index(string? q, int? customerId)
        {
            var query = _context.Vehicles
                .Include(v => v.Customer)
                .Include(v => v.VehicleClassification)
                .AsQueryable();

            if (customerId.HasValue)
                query = query.Where(v => v.CustomerID == customerId.Value);

            if (!string.IsNullOrWhiteSpace(q))
            {
                var term = q.Trim();
                query = query.Where(v =>
                    v.Customer.FullName.Contains(term) ||
                    (v.PlateNumber != null && v.PlateNumber.Contains(term)) ||
                    (v.Brand != null && v.Brand.Contains(term)) ||
                    (v.Model != null && v.Model.Contains(term)));
            }

            var vehicles = await query
                .OrderBy(v => v.Brand)
                .ThenBy(v => v.Model)
                .ToListAsync();

            ViewData["Search"] = q;

            if (customerId.HasValue)
            {
                ViewData["CustomerId"] = customerId;
                ViewData["CustomerName"] = await _context.Customers
                    .Where(c => c.CustomerID == customerId.Value)
                    .Select(c => c.FullName)
                    .FirstOrDefaultAsync();
            }

            return View(vehicles);
        }

        // GET: Vehicle/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
                return NotFound();

            var vehicle = await _context.Vehicles
                .Include(v => v.Customer)
                .Include(v => v.VehicleClassification)
                .FirstOrDefaultAsync(v =>
                    v.VehicleID == id);

            if (vehicle == null)
                return NotFound();

            return View(vehicle);
        }

        // GET: Vehicle/Create?customerId=...
        public async Task<IActionResult> Create(int? customerId)
        {
            await LoadDropdowns(customerId.HasValue ? new Vehicle { CustomerID = customerId.Value } : null);

            return View();
        }

        // POST: Vehicle/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Vehicle vehicle)
        {
            ModelState.Remove(nameof(Vehicle.Customer));
            ModelState.Remove(nameof(Vehicle.VehicleClassification));

            if (!ModelState.IsValid)
            {
                await LoadDropdowns(vehicle);
                return View(vehicle);
            }

            NormalizePlateNumber(vehicle);

            if (!string.IsNullOrWhiteSpace(vehicle.PlateNumber) &&
                await _context.Vehicles.AnyAsync(v => v.PlateNumber == vehicle.PlateNumber))
            {
                ModelState.AddModelError(string.Empty, $"Plate number '{vehicle.PlateNumber}' is already registered to another vehicle.");
                await LoadDropdowns(vehicle);
                return View(vehicle);
            }

            _context.Vehicles.Add(vehicle);
            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Index));
        }

        // GET: Vehicle/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
                return NotFound();

            var vehicle =
                await _context.Vehicles.FindAsync(id);

            if (vehicle == null)
                return NotFound();

            await LoadDropdowns(vehicle);

            return View(vehicle);
        }

        // POST: Vehicle/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(
            int id,
            Vehicle vehicle)
        {
            if (id != vehicle.VehicleID)
                return NotFound();

            ModelState.Remove(nameof(Vehicle.Customer));
            ModelState.Remove(nameof(Vehicle.VehicleClassification));

            if (!ModelState.IsValid)
            {
                await LoadDropdowns(vehicle);
                return View(vehicle);
            }

            NormalizePlateNumber(vehicle);

            if (!string.IsNullOrWhiteSpace(vehicle.PlateNumber) &&
                await _context.Vehicles.AnyAsync(v => v.PlateNumber == vehicle.PlateNumber && v.VehicleID != id))
            {
                ModelState.AddModelError(string.Empty, $"Plate number '{vehicle.PlateNumber}' is already registered to another vehicle.");
                await LoadDropdowns(vehicle);
                return View(vehicle);
            }

            try
            {
                _context.Update(vehicle);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!VehicleExists(vehicle.VehicleID))
                    return NotFound();

                throw;
            }

            return RedirectToAction(nameof(Index));
        }

        // GET: Vehicle/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
                return NotFound();

            var vehicle = await _context.Vehicles
                .Include(v => v.Customer)
                .Include(v => v.VehicleClassification)
                .FirstOrDefaultAsync(v =>
                    v.VehicleID == id);

            if (vehicle == null)
                return NotFound();

            ViewData["BlockReason"] = await BuildBlockReason(id.Value);

            return View(vehicle);
        }

        // POST: Vehicle/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var vehicle = await _context.Vehicles.FindAsync(id);

            if (vehicle == null)
                return RedirectToAction(nameof(Index));

            var blockReason = await BuildBlockReason(id);
            if (blockReason != null)
            {
                TempData["DeleteError"] = blockReason;
                return RedirectToAction(nameof(Delete), new { id });
            }

            try
            {
                _context.Vehicles.Remove(vehicle);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                TempData["DeleteError"] =
                    "Can't delete this vehicle. It still has related records elsewhere in the system. " +
                    "Remove those first.";

                return RedirectToAction(nameof(Delete), new { id });
            }

            return RedirectToAction(nameof(Index));
        }

        // Vehicles are ON DELETE RESTRICT from JobOrder, Sale, Quotation and
        // ServiceInvoice - check those before attempting delete so we can show
        // a friendly message instead of a raw DB error.
        private async Task<string?> BuildBlockReason(int vehicleId)
        {
            var jobOrders = await _context.JobOrders.CountAsync(j => j.VehicleID == vehicleId);
            var sales = await _context.Sales.CountAsync(s => s.VehicleID == vehicleId);
            var quotations = await _context.Quotations.CountAsync(q => q.VehicleID == vehicleId);
            var serviceInvoices = await _context.ServiceInvoices.CountAsync(i => i.VehicleID == vehicleId);

            var parts = new List<string>();
            if (jobOrders > 0) { parts.Add($"{jobOrders} job order{(jobOrders == 1 ? "" : "s")}"); }
            if (sales > 0) { parts.Add($"{sales} sale{(sales == 1 ? "" : "s")}"); }
            if (quotations > 0) { parts.Add($"{quotations} quotation{(quotations == 1 ? "" : "s")}"); }
            if (serviceInvoices > 0) { parts.Add($"{serviceInvoices} service invoice{(serviceInvoices == 1 ? "" : "s")}"); }

            if (parts.Count == 0)
                return null;

            return "Can't delete this vehicle. It still has " + string.Join(", ", parts) +
                   " linked to it. Remove or complete those first.";
        }

        private async Task LoadDropdowns(Vehicle? vehicle = null)
        {
            ViewData["CustomerID"] = new SelectList(
                await _context.Customers
                    .OrderBy(c => c.FullName)
                    .ToListAsync(),
                "CustomerID",
                "FullName",
                vehicle?.CustomerID);

            ViewData["VehicleClassificationID"] = new SelectList(
                await _context.VehicleClassifications
                    .OrderBy(v => v.ClassificationName)
                    .ToListAsync(),
                "VehicleClassificationID",
                "ClassificationName",
                vehicle?.VehicleClassificationID);
        }

        private bool VehicleExists(int id)
        {
            return _context.Vehicles
                .Any(v => v.VehicleID == id);
        }

        // Regex on the model already confirmed the format is 3 letters + 3 or 4
        // digits (the current and older Philippine LTO formats), optionally
        // separated by a space or dash - collapse whatever the user typed into
        // one canonical "ABC 1234" / "ABC 123" form before saving.
        private static void NormalizePlateNumber(Vehicle vehicle)
        {
            if (string.IsNullOrWhiteSpace(vehicle.PlateNumber))
                return;

            var compact = vehicle.PlateNumber.Replace(" ", "").Replace("-", "");
            if (compact.Length < 6)
                return;

            var letters = compact.Substring(0, 3).ToUpperInvariant();
            var digits = compact.Substring(3);
            vehicle.PlateNumber = $"{letters} {digits}";
        }
    }
}