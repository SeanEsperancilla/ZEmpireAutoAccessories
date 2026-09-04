using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Authorization;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Controllers
{
    [ModuleAuthorize("Vehicle Checklist")]
    public class VehicleChecklistController : Controller
    {
        private readonly ApplicationDbContext _context;

        public VehicleChecklistController(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var checklists = await _context.VehicleChecklists
                .Include(c => c.JobOrder).ThenInclude(j => j.Customer)
                .Include(c => c.JobOrder).ThenInclude(j => j.Vehicle)
                .Include(c => c.User)
                .OrderByDescending(c => c.ChecklistDate)
                .ToListAsync();

            return View(checklists);
        }

        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
                return NotFound();

            var checklist = await _context.VehicleChecklists
                .Include(c => c.JobOrder).ThenInclude(j => j.Customer)
                .Include(c => c.JobOrder).ThenInclude(j => j.Vehicle)
                .Include(c => c.User)
                .Include(c => c.Details).ThenInclude(d => d.Panel)
                .FirstOrDefaultAsync(c => c.ChecklistID == id);

            if (checklist == null)
                return NotFound();

            ViewData["Panels"] = await _context.Panels.OrderBy(p => p.PanelName).ToListAsync();

            return View(checklist);
        }

        public async Task<IActionResult> Create()
        {
            await LoadDropdowns();
            return View(new VehicleChecklist { ChecklistDate = DateTime.Now });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(
            [Bind("JobOrderID,AdditionalNotes,ClientSignature")] VehicleChecklist checklist)
        {
            ModelState.Remove(nameof(VehicleChecklist.UserId));
            ModelState.Remove(nameof(VehicleChecklist.JobOrder));
            ModelState.Remove(nameof(VehicleChecklist.User));

            if (!ModelState.IsValid)
            {
                await LoadDropdowns();
                return View(checklist);
            }

            checklist.UserId = CurrentUserId;
            checklist.ChecklistDate = DateTime.Now;

            _context.VehicleChecklists.Add(checklist);
            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Details), new { id = checklist.ChecklistID });
        }

        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
                return NotFound();

            var checklist = await _context.VehicleChecklists
                .Include(c => c.JobOrder).ThenInclude(j => j.Vehicle)
                .FirstOrDefaultAsync(c => c.ChecklistID == id);

            if (checklist == null)
                return NotFound();

            return View(checklist);
        }

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var checklist = await _context.VehicleChecklists.FindAsync(id);
            if (checklist != null)
            {
                _context.VehicleChecklists.Remove(checklist);
                await _context.SaveChangesAsync();
            }

            return RedirectToAction(nameof(Index));
        }

        // Upsert - one row per panel, saved independently as staff work through the vehicle.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SaveDetail(
            int checklistId,
            int panelId,
            string? existingCondition,
            string? notes)
        {
            var detail = await _context.VehicleChecklistDetails
                .FirstOrDefaultAsync(d => d.ChecklistID == checklistId && d.PanelID == panelId);

            if (detail == null)
            {
                _context.VehicleChecklistDetails.Add(new VehicleChecklistDetail
                {
                    ChecklistID = checklistId,
                    PanelID = panelId,
                    ExistingCondition = existingCondition,
                    Notes = notes
                });
            }
            else
            {
                detail.ExistingCondition = existingCondition;
                detail.Notes = notes;
            }

            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Details), new { id = checklistId });
        }

        private string CurrentUserId =>
            User.FindFirstValue(ClaimTypes.NameIdentifier)!;

        private async Task LoadDropdowns()
        {
            var jobOrders = await _context.JobOrders
                .Include(j => j.Customer)
                .Include(j => j.Vehicle)
                .OrderByDescending(j => j.JobOrderDate)
                .Select(j => new
                {
                    j.JobOrderID,
                    Display = j.JobOrderNumber + " - " + j.Customer.FullName + " (" + (j.Vehicle.PlateNumber ?? "No Plate") + ")"
                })
                .ToListAsync();

            ViewData["JobOrderID"] = new SelectList(jobOrders, "JobOrderID", "Display");
        }
    }
}