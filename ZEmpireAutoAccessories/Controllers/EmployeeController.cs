using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Authorization;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Controllers
{
    [ModuleAuthorize("Employees")]
    public class EmployeeController : Controller
    {
        private readonly ApplicationDbContext _context;

        public EmployeeController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Employee
        public async Task<IActionResult> Index()
        {
            var employees = await _context.Employees
                .Include(e => e.User)
                .OrderBy(e => e.LastName)
                .ThenBy(e => e.FirstName)
                .ToListAsync();

            return View(employees);
        }

        // GET: Employee/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
                return NotFound();

            var employee = await _context.Employees
                .Include(e => e.User)
                .FirstOrDefaultAsync(e =>
                    e.EmployeeID == id);

            if (employee == null)
                return NotFound();

            return View(employee);
        }

        // GET: Employee/Create
        public async Task<IActionResult> Create()
        {
            await LoadUserDropdown();

            return View(new Employee { IsActive = true });
        }

        // POST: Employee/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Employee employee)
        {
            ModelState.Remove(nameof(Employee.User));

            if (!ModelState.IsValid)
            {
                await LoadUserDropdown(employee.UserId);
                return View(employee);
            }

            employee.CreatedAt = DateTime.UtcNow;

            _context.Employees.Add(employee);
            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Index));
        }

        // GET: Employee/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
                return NotFound();

            var employee = await _context.Employees
                .Include(e => e.User)
                .FirstOrDefaultAsync(e =>
                    e.EmployeeID == id);

            if (employee == null)
                return NotFound();

            return View(employee);
        }

        // POST: Employee/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(
            int id,
            Employee employee)
        {
            if (id != employee.EmployeeID)
                return NotFound();

            ModelState.Remove(nameof(Employee.User));

            if (!ModelState.IsValid)
                return View(employee);

            employee.UpdatedAt = DateTime.UtcNow;

            try
            {
                _context.Update(employee);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!EmployeeExists(employee.EmployeeID))
                    return NotFound();

                throw;
            }

            return RedirectToAction(nameof(Index));
        }

        // GET: Employee/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
                return NotFound();

            var employee = await _context.Employees
                .Include(e => e.User)
                .FirstOrDefaultAsync(e =>
                    e.EmployeeID == id);

            if (employee == null)
                return NotFound();

            ViewData["AssignedJobOrders"] = await _context.JobOrders
                .CountAsync(j => j.AssignedEmployeeID == id);

            return View(employee);
        }

        // POST: Employee/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var employee = await _context.Employees.FindAsync(id);

            if (employee == null)
                return RedirectToAction(nameof(Index));

            var jobOrderCount = await _context.JobOrders
                .CountAsync(j => j.AssignedEmployeeID == id);

            if (jobOrderCount > 0)
            {
                var word = jobOrderCount == 1 ? "job order" : "job orders";
                TempData["DeleteError"] =
                    $"Can't delete this employee. They are assigned to {jobOrderCount} {word}. " +
                    "Reassign those job orders first.";

                return RedirectToAction(nameof(Delete), new { id });
            }

            try
            {
                _context.Employees.Remove(employee);
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                TempData["DeleteError"] =
                    "Can't delete this employee. They still have related records elsewhere in the system.";

                return RedirectToAction(nameof(Delete), new { id });
            }

            return RedirectToAction(nameof(Index));
        }

        private async Task LoadUserDropdown(string? selectedUserId = null)
        {
            var assignedUserIds = await _context.Employees
                .Select(e => e.UserId)
                .ToListAsync();

            var availableUsers = await _context.Users
                .Where(u => !assignedUserIds.Contains(u.Id) || u.Id == selectedUserId)
                .OrderBy(u => u.UserName)
                .Select(u => new
                {
                    u.Id,
                    Display = u.UserName + " (" + u.FullName + ")"
                })
                .ToListAsync();

            ViewData["UserId"] = new SelectList(availableUsers, "Id", "Display", selectedUserId);
        }

        private bool EmployeeExists(int id)
        {
            return _context.Employees
                .Any(e => e.EmployeeID == id);
        }
    }
}
