using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Controllers
{
    /// <summary>
    /// Manages the RBAC matrix itself (sec.Module, sec.RolePermission). This is
    /// gated on the Admin role directly rather than a module claim, since it
    /// configures the module claims everything else depends on.
    /// </summary>
    [Authorize(Roles = "Admin")]
    public class SecurityController : Controller
    {
        private readonly ApplicationDbContext _context;

        public SecurityController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Security
        public async Task<IActionResult> Index()
        {
            var modules = await _context.Modules
                .OrderBy(m => m.ModuleName)
                .ToListAsync();

            var roles = await _context.Roles
                .OrderBy(r => r.Name)
                .ToListAsync();

            var permissions = await _context.RolePermissions.ToListAsync();

            var cells = new List<PermissionCell>();
            foreach (var role in roles)
            {
                foreach (var module in modules)
                {
                    var existing = permissions.FirstOrDefault(p =>
                        p.RoleId == role.Id && p.ModuleID == module.ModuleID);

                    cells.Add(new PermissionCell
                    {
                        RoleId = role.Id,
                        RoleName = role.Name ?? string.Empty,
                        ModuleID = module.ModuleID,
                        ModuleName = module.ModuleName,
                        CanAccess = existing?.CanAccess ?? false
                    });
                }
            }

            return View(new SecurityMatrixViewModel
            {
                Modules = modules,
                Roles = roles,
                Cells = cells
            });
        }

        // POST: Security/SavePermissions
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SavePermissions(List<PermissionCell> cells)
        {
            foreach (var cell in cells)
            {
                var existing = await _context.RolePermissions.FirstOrDefaultAsync(p =>
                    p.RoleId == cell.RoleId && p.ModuleID == cell.ModuleID);

                if (existing == null)
                {
                    _context.RolePermissions.Add(new RolePermission
                    {
                        RoleId = cell.RoleId,
                        ModuleID = cell.ModuleID,
                        CanAccess = cell.CanAccess
                    });
                }
                else
                {
                    existing.CanAccess = cell.CanAccess;
                }
            }

            await _context.SaveChangesAsync();

            TempData["SecurityMessage"] =
                "Permissions updated. Signed-in users may need to sign out and back in to see the change.";

            return RedirectToAction(nameof(Index));
        }

        // POST: Security/CreateModule
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CreateModule(string moduleName)
        {
            if (!string.IsNullOrWhiteSpace(moduleName))
            {
                _context.Modules.Add(new Module { ModuleName = moduleName.Trim() });
                await _context.SaveChangesAsync();
            }

            return RedirectToAction(nameof(Index));
        }

        // POST: Security/DeleteModule/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteModule(int id)
        {
            var module = await _context.Modules
                .Include(m => m.RolePermissions)
                .FirstOrDefaultAsync(m => m.ModuleID == id);

            if (module != null)
            {
                _context.RolePermissions.RemoveRange(module.RolePermissions);
                _context.Modules.Remove(module);

                try
                {
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateException)
                {
                    TempData["SecurityMessage"] =
                        $"Can't delete \"{module.ModuleName}\" - it's still referenced elsewhere.";
                }
            }

            return RedirectToAction(nameof(Index));
        }
    }
}
