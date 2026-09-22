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
        // Module names that a real controller still gates access on via
        // [ModuleAuthorize(...)] - deleting one of these would forbid
        // everyone (Admin included, since this page is the only thing not
        // gated by the module matrix) from that whole section of the app
        // until someone re-adds it here. Custom/extra module rows an Admin
        // added themselves aren't in this list and can still be deleted.
        private static readonly HashSet<string> ProtectedModuleNames = new(StringComparer.OrdinalIgnoreCase)
        {
            "Customers", "Inventory", "Job Orders", "Job Types", "Price History",
            "Pricing", "Products", "Quotation", "Reports", "Sales",
            "Service Invoices", "Services", "User Management", "Vehicle Checklist",
            "Vehicles", "Warranty"
        };

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
            var adminRoleId = await _context.Roles
                .Where(r => r.Name == "Admin")
                .Select(r => r.Id)
                .FirstOrDefaultAsync();

            foreach (var cell in cells)
            {
                // Admin always keeps full access - this screen is the only
                // way back in for any module gated by the matrix, so an
                // Admin accidentally unchecking their own row here can never
                // be allowed to lock every Admin out of that module.
                var canAccess = cell.RoleId == adminRoleId || cell.CanAccess;

                var existing = await _context.RolePermissions.FirstOrDefaultAsync(p =>
                    p.RoleId == cell.RoleId && p.ModuleID == cell.ModuleID);

                if (existing == null)
                {
                    _context.RolePermissions.Add(new RolePermission
                    {
                        RoleId = cell.RoleId,
                        ModuleID = cell.ModuleID,
                        CanAccess = canAccess
                    });
                }
                else
                {
                    existing.CanAccess = canAccess;
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
                if (ProtectedModuleNames.Contains(module.ModuleName))
                {
                    TempData["SecurityMessage"] =
                        $"Can't delete \"{module.ModuleName}\" - it's a built-in module a real screen depends on. " +
                        "Uncheck it above instead to hide it from a role.";
                    return RedirectToAction(nameof(Index));
                }

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
