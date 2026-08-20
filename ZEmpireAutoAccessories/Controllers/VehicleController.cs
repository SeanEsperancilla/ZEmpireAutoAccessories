using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Controllers
{
    public class VehicleController : Controller
    {
        private readonly ApplicationDbContext _context;

        public VehicleController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Vehicle
        public async Task<IActionResult> Index()
        {
            var vehicles = await _context.Vehicles
                .Include(v => v.Customer)
                .Include(v => v.VehicleClassification)
                .OrderBy(v => v.Brand)
                .ThenBy(v => v.Model)
                .ToListAsync();

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

        // GET: Vehicle/Create
        public async Task<IActionResult> Create()
        {
            await LoadDropdowns();

            return View();
        }

        // POST: Vehicle/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Vehicle vehicle)
        {
            if (!ModelState.IsValid)
            {
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

            if (!ModelState.IsValid)
            {
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

            return View(vehicle);
        }

        // POST: Vehicle/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var vehicle =
                await _context.Vehicles.FindAsync(id);

            if (vehicle != null)
            {
                _context.Vehicles.Remove(vehicle);
                await _context.SaveChangesAsync();
            }

            return RedirectToAction(nameof(Index));
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
    }
}