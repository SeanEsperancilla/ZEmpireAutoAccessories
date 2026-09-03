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

        // GET: Vehicle?q=...
        public async Task<IActionResult> Index(string? q)
        {
            var query = _context.Vehicles
                .Include(v => v.Customer)
                .Include(v => v.VehicleClassification)
                .AsNoTracking()
                .AsQueryable();

            if (!string.IsNullOrWhiteSpace(q))
            {
                var term = q.Trim();
                query = query.Where(v =>
                    (v.PlateNumber != null && v.PlateNumber.Contains(term)) ||
                    (v.Brand != null && v.Brand.Contains(term)) ||
                    (v.Model != null && v.Model.Contains(term)) ||
                    v.Customer.FullName.Contains(term));
            }

            var vehicles = await query
                .OrderBy(v => v.Brand)
                .ThenBy(v => v.Model)
                .ToListAsync();

            ViewData["Search"] = q;
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
                .AsNoTracking()
                .FirstOrDefaultAsync(v => v.VehicleID == id);

            if (vehicle == null)
                return NotFound();

            return View(vehicle);
        }

        // GET: Vehicle/Create?customerId=5
        public async Task<IActionResult> Create(int? customerId)
        {
            var vehicle = new Vehicle();
            if (customerId != null && await _context.Customers.AnyAsync(c => c.CustomerID == customerId))
                vehicle.CustomerID = customerId.Value;

            await LoadDropdowns(vehicle);
            return View(vehicle);
        }

        // POST: Vehicle/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(
            [Bind("CustomerID,VehicleClassificationID,PlateNumber,Brand,Model,ManufacturingYear")] Vehicle vehicle)
        {
            NormalizeAndValidate(vehicle);

            if (!ModelState.IsValid)
            {
                await LoadDropdowns(vehicle);
                return View(vehicle);
            }

            _context.Vehicles.Add(vehicle);
            await _context.SaveChangesAsync();

            TempData["Success"] = $"Vehicle \"{VehicleLabel(vehicle)}\" was added.";
            return RedirectToAction(nameof(Index));
        }

        // GET: Vehicle/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
                return NotFound();

            var vehicle = await _context.Vehicles.FindAsync(id);
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
            [Bind("VehicleID,CustomerID,VehicleClassificationID,PlateNumber,Brand,Model,ManufacturingYear")] Vehicle vehicle)
        {
            if (id != vehicle.VehicleID)
                return NotFound();

            NormalizeAndValidate(vehicle);

            if (!ModelState.IsValid)
            {
                await LoadDropdowns(vehicle);
                return View(vehicle);
            }

            var existing = await _context.Vehicles.FindAsync(id);
            if (existing == null)
                return NotFound();

            existing.CustomerID = vehicle.CustomerID;
            existing.VehicleClassificationID = vehicle.VehicleClassificationID;
            existing.PlateNumber = vehicle.PlateNumber;
            existing.Brand = vehicle.Brand;
            existing.Model = vehicle.Model;
            existing.ManufacturingYear = vehicle.ManufacturingYear;

            await _context.SaveChangesAsync();

            TempData["Success"] = $"Vehicle \"{VehicleLabel(vehicle)}\" was updated.";
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
                .AsNoTracking()
                .FirstOrDefaultAsync(v => v.VehicleID == id);

            if (vehicle == null)
                return NotFound();

            ViewData["UsageCount"] = await CountVehicleUsageAsync(id.Value);
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

            // Vehicles are referenced (ON DELETE RESTRICT) by job orders, sales,
            // service invoices and quotations — block instead of throwing.
            if (await CountVehicleUsageAsync(id) > 0)
            {
                TempData["Error"] =
                    $"\"{VehicleLabel(vehicle)}\" is used in job orders, sales, invoices or quotations and cannot be deleted.";
                return RedirectToAction(nameof(Delete), new { id });
            }

            _context.Vehicles.Remove(vehicle);
            await _context.SaveChangesAsync();

            TempData["Success"] = $"Vehicle \"{VehicleLabel(vehicle)}\" was deleted.";
            return RedirectToAction(nameof(Index));
        }

        // ---- helpers ----

        private void NormalizeAndValidate(Vehicle vehicle)
        {
            // Navigation properties are not posted; clear their implicit
            // (non-nullable reference) required errors so validation passes.
            ModelState.Remove(nameof(Vehicle.Customer));
            ModelState.Remove(nameof(Vehicle.VehicleClassification));

            vehicle.PlateNumber = Clean(vehicle.PlateNumber)?.ToUpperInvariant();
            vehicle.Brand = Clean(vehicle.Brand);
            vehicle.Model = Clean(vehicle.Model);

            if (vehicle.CustomerID > 0 &&
                !_context.Customers.Any(c => c.CustomerID == vehicle.CustomerID))
                ModelState.AddModelError(nameof(Vehicle.CustomerID), "Selected customer no longer exists.");

            if (vehicle.VehicleClassificationID > 0 &&
                !_context.VehicleClassifications.Any(vc => vc.VehicleClassificationID == vehicle.VehicleClassificationID))
                ModelState.AddModelError(nameof(Vehicle.VehicleClassificationID), "Selected classification no longer exists.");
        }

        private static string? Clean(string? s) => string.IsNullOrWhiteSpace(s) ? null : s.Trim();

        private static string VehicleLabel(Vehicle v)
        {
            var name = $"{v.Brand} {v.Model}".Trim();
            if (!string.IsNullOrWhiteSpace(v.PlateNumber))
                name = name.Length == 0 ? v.PlateNumber! : $"{name} ({v.PlateNumber})";
            return name.Length == 0 ? $"Vehicle #{v.VehicleID}" : name;
        }

        private async Task<int> CountVehicleUsageAsync(int id)
        {
            return await _context.JobOrders.CountAsync(j => j.VehicleID == id)
                 + await _context.Sales.CountAsync(s => s.VehicleID == id)
                 + await _context.ServiceInvoices.CountAsync(si => si.VehicleID == id)
                 + await _context.Quotations.CountAsync(qq => qq.VehicleID == id);
        }

        private async Task LoadDropdowns(Vehicle? vehicle = null)
        {
            ViewData["CustomerID"] = new SelectList(
                await _context.Customers.OrderBy(c => c.FullName).ToListAsync(),
                "CustomerID", "FullName", vehicle?.CustomerID);

            ViewData["VehicleClassificationID"] = new SelectList(
                await _context.VehicleClassifications.OrderBy(v => v.ClassificationName).ToListAsync(),
                "VehicleClassificationID", "ClassificationName", vehicle?.VehicleClassificationID);
        }
    }
}
