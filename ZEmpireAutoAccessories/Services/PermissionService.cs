using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Services.Interfaces;

namespace ZEmpireAutoAccessories.Services
{
    /// <summary>
    /// Resolves module-level access from the RBAC matrix in sec.RolePermission.
    /// </summary>
    public class PermissionService : IPermissionService
    {
        private readonly ApplicationDbContext _context;

        public PermissionService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<string>> GetModulesForUserAsync(string userId)
        {
            var roleIds = await _context.UserRoles
                .Where(ur => ur.UserId == userId)
                .Select(ur => ur.RoleId)
                .ToListAsync();

            if (roleIds.Count == 0)
                return new List<string>();

            return await _context.RolePermissions
                .Where(rp => roleIds.Contains(rp.RoleId) && rp.CanAccess)
                .Select(rp => rp.Module.ModuleName)
                .Distinct()
                .OrderBy(name => name)
                .ToListAsync();
        }
    }
}
