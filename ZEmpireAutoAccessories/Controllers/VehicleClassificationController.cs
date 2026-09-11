using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Authorization;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Controllers
{
    [ModuleAuthorize("Vehicles")]
    public class VehicleClassificationController : Controller
    {
        private readonly ApplicationDbContext _context;

        public VehicleClassificationController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: VehicleClassification
        public async Task<IActionResult> Index()
        {
            var classifications = await _context.VehicleClassifications
                .Include(v => v.Vehicles)
                .OrderBy(v => v.ClassificationName)
                .ToListAsync();

            return View(classifications);
        }

        // GET: VehicleClassification/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
                return NotFound();

            var classification = await _context.VehicleClassifications
                .Include(v => v.Vehicles)
                .FirstOrDefaultAsync(v =>
                    v.VehicleClassificationID == id);

            if (classification == null)
                return NotFound();

            return View(classification);
        }

        // GET: VehicleClassification/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: VehicleClassification/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(
            VehicleClassification classification)
        {
            if (!ModelState.IsValid)
                return View(classification);

            _context.VehicleClassifications.Add(classification);
            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Index));
        }

        // GET: VehicleClassification/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
                return NotFound();

            var classification =
                await _context.VehicleClassifications.FindAsync(id);

            if (classification == null)
                return NotFound();

            return View(classification);
        }

        // POST: VehicleClassification/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(
            int id,
            VehicleClassification classification)
        {
            if (id != classification.VehicleClassificationID)
                return NotFound();

            if (!ModelState.IsValid)
                return View(classification);

            try
            {
                _context.Update(classification);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!VehicleClassificationExists(
                    classification.VehicleClassificationID))
                {
                    return NotFound();
                }

                throw;
            }

            return RedirectToAction(nameof(Index));
        }

        // GET: VehicleClassification/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
                return NotFound();

            var classification =
                await _context.VehicleClassifications
                    .Include(v => v.Vehicles)
                    .FirstOrDefaultAsync(v =>
                        v.VehicleClassificationID == id);

            if (classification == null)
                return NotFound();

            ViewData["BlockReason"] = await BuildBlockReason(id.Value);

            return View(classification);
        }

        // POST: VehicleClassification/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var classification =
                await _context.VehicleClassifications.FindAsync(id);

            if (classification == null)
                return RedirectToAction(nameof(Index));

            var blockReason = await BuildBlockReason(id);
            if (blockReason != null)
            {
                TempData["DeleteError"] = blockReason;
                return RedirectToAction(nameof(Delete), new { id });
            }

            try
            {
                _context.VehicleClassifications.Remove(classification);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                TempData["DeleteError"] =
                    "Can't delete this classification. It still has related records elsewhere in the system.";

                return RedirectToAction(nameof(Delete), new { id });
            }

            return RedirectToAction(nameof(Index));
        }

        // VehicleClassification is ON DELETE RESTRICT from Vehicle.
        private async Task<string?> BuildBlockReason(int classificationId)
        {
            var vehicles = await _context.Vehicles.CountAsync(v => v.VehicleClassificationID == classificationId);

            if (vehicles == 0)
                return null;

            var word = vehicles == 1 ? "vehicle" : "vehicles";
            return $"Can't delete this classification. It's used by {vehicles} {word}. Reassign those vehicles first.";
        }

        private bool VehicleClassificationExists(int id)
        {
            return _context.VehicleClassifications
                .Any(v => v.VehicleClassificationID == id);
        }
    }
}