using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Authorization;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Controllers
{
    [ModuleAuthorize("User Management")]
    public class EmployeeController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly RoleManager<ApplicationRole> _roleManager;

        public EmployeeController(
            ApplicationDbContext context,
            UserManager<ApplicationUser> userManager,
            RoleManager<ApplicationRole> roleManager)
        {
            _context = context;
            _userManager = userManager;
            _roleManager = roleManager;
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
            await LoadRoleDropdown();

            return View(new Employee { IsActive = true });
        }

        // POST: Employee/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Employee employee, string role)
        {
            ModelState.Remove(nameof(Employee.User));

            if (string.IsNullOrWhiteSpace(role))
                ModelState.AddModelError(nameof(role), "Role is required.");

            if (!ModelState.IsValid)
            {
                await LoadUserDropdown(employee.UserId);
                await LoadRoleDropdown(role);
                return View(employee);
            }

            var user = await _userManager.FindByIdAsync(employee.UserId);
            if (user == null)
                return NotFound();

            var roleResult = await SetSingleRole(user, role);
            if (!roleResult.Succeeded)
            {
                foreach (var error in roleResult.Errors)
                    ModelState.AddModelError(string.Empty, error.Description);

                await LoadUserDropdown(employee.UserId);
                await LoadRoleDropdown(role);
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

            var currentRoles = await _userManager.GetRolesAsync(employee.User);
            await LoadRoleDropdown(currentRoles.FirstOrDefault());

            return View(employee);
        }

        // POST: Employee/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(
            int id,
            Employee employee,
            string userName,
            string role)
        {
            if (id != employee.EmployeeID)
                return NotFound();

            ModelState.Remove(nameof(Employee.User));

            if (string.IsNullOrWhiteSpace(userName))
                ModelState.AddModelError(nameof(userName), "Login username is required.");

            if (string.IsNullOrWhiteSpace(role))
                ModelState.AddModelError(nameof(role), "Role is required.");

            if (!ModelState.IsValid)
            {
                employee.User = await _context.Users.FirstOrDefaultAsync(u => u.Id == employee.UserId) ?? employee.User;
                await LoadRoleDropdown(role);
                return View(employee);
            }

            var user = await _context.Users.FirstOrDefaultAsync(u => u.Id == employee.UserId);
            if (user == null)
                return NotFound();

            if (!string.Equals(user.UserName, userName.Trim(), StringComparison.OrdinalIgnoreCase))
            {
                var result = await _userManager.SetUserNameAsync(user, userName.Trim());
                if (!result.Succeeded)
                {
                    foreach (var error in result.Errors)
                        ModelState.AddModelError(string.Empty, error.Description);

                    employee.User = user;
                    await LoadRoleDropdown(role);
                    return View(employee);
                }
            }

            var roleResult = await SetSingleRole(user, role);
            if (!roleResult.Succeeded)
            {
                foreach (var error in roleResult.Errors)
                    ModelState.AddModelError(string.Empty, error.Description);

                employee.User = user;
                await LoadRoleDropdown(role);
                return View(employee);
            }

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

        // POST: Employee/ResetPassword/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ResetPassword(int id, string newPassword, string confirmPassword)
        {
            var employee = await _context.Employees
                .Include(e => e.User)
                .FirstOrDefaultAsync(e => e.EmployeeID == id);

            if (employee == null)
                return NotFound();

            if (newPassword != confirmPassword)
            {
                TempData["ResetPasswordError"] = "The new password and confirmation don't match.";
                return RedirectToAction(nameof(Details), new { id });
            }

            var token = await _userManager.GeneratePasswordResetTokenAsync(employee.User);
            var result = await _userManager.ResetPasswordAsync(employee.User, token, newPassword);

            if (!result.Succeeded)
            {
                TempData["ResetPasswordError"] = string.Join(" ", result.Errors.Select(e => e.Description));
                return RedirectToAction(nameof(Details), new { id });
            }

            TempData["Success"] = $"Password reset for {employee.User.UserName}.";
            return RedirectToAction(nameof(Details), new { id });
        }

        // Removes any roles the user currently holds and adds the one selected -
        // this app only ever wants a user in exactly one of Admin/Staff at a time.
        private async Task<IdentityResult> SetSingleRole(ApplicationUser user, string role)
        {
            var currentRoles = await _userManager.GetRolesAsync(user);
            if (currentRoles.Count == 1 && currentRoles[0] == role)
                return IdentityResult.Success;

            if (currentRoles.Count > 0)
            {
                var removeResult = await _userManager.RemoveFromRolesAsync(user, currentRoles);
                if (!removeResult.Succeeded)
                    return removeResult;
            }

            return await _userManager.AddToRoleAsync(user, role);
        }

        private async Task LoadRoleDropdown(string? selectedRole = null)
        {
            var roles = await _roleManager.Roles
                .OrderBy(r => r.Name)
                .Select(r => r.Name!)
                .ToListAsync();

            ViewData["Role"] = new SelectList(roles, selectedRole);
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
