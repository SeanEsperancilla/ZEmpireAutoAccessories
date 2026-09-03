using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Authorization;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Controllers
{
    [ModuleAuthorize("Job Types")]
    public class JobTypeController : Controller
    {
        private readonly ApplicationDbContext _context;

        public JobTypeController(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var jobTypes = await _context.JobTypes
                .OrderBy(j => j.JobTypeName)
                .ToListAsync();

            return View(jobTypes);
        }

        public IActionResult Create()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(JobType jobType)
        {
            if (!ModelState.IsValid)
                return View(jobType);

            _context.JobTypes.Add(jobType);
            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
                return NotFound();

            var jobType = await _context.JobTypes.FindAsync(id);
            if (jobType == null)
                return NotFound();

            return View(jobType);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, JobType jobType)
        {
            if (id != jobType.JobTypeID)
                return NotFound();

            if (!ModelState.IsValid)
                return View(jobType);

            try
            {
                _context.Update(jobType);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!JobTypeExists(jobType.JobTypeID))
                    return NotFound();

                throw;
            }

            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
                return NotFound();

            var jobType = await _context.JobTypes
                .FirstOrDefaultAsync(j => j.JobTypeID == id);

            if (jobType == null)
                return NotFound();

            ViewData["BlockReason"] = await BuildBlockReason(id.Value);

            return View(jobType);
        }

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var jobType = await _context.JobTypes.FindAsync(id);
            if (jobType == null)
                return RedirectToAction(nameof(Index));

            var blockReason = await BuildBlockReason(id);
            if (blockReason != null)
            {
                TempData["DeleteError"] = blockReason;
                return RedirectToAction(nameof(Delete), new { id });
            }

            try
            {
                _context.JobTypes.Remove(jobType);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                TempData["DeleteError"] =
                    "Can't delete this job type. It still has related records elsewhere in the system.";

                return RedirectToAction(nameof(Delete), new { id });
            }

            return RedirectToAction(nameof(Index));
        }

        // JobType is ON DELETE RESTRICT from JobOrder and Quotation.
        private async Task<string?> BuildBlockReason(int jobTypeId)
        {
            var jobOrders = await _context.JobOrders.CountAsync(j => j.JobTypeID == jobTypeId);
            var quotations = await _context.Quotations.CountAsync(q => q.JobTypeID == jobTypeId);

            var parts = new List<string>();
            if (jobOrders > 0) { parts.Add($"{jobOrders} job order{(jobOrders == 1 ? "" : "s")}"); }
            if (quotations > 0) { parts.Add($"{quotations} quotation{(quotations == 1 ? "" : "s")}"); }

            if (parts.Count == 0)
                return null;

            return "Can't delete this job type. It's used by " + string.Join(", ", parts) + ". Remove those first.";
        }

        private bool JobTypeExists(int id)
        {
            return _context.JobTypes.Any(j => j.JobTypeID == id);
        }
    }
}