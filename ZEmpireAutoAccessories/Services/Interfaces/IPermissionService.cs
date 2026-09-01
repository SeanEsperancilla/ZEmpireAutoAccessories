namespace ZEmpireAutoAccessories.Services.Interfaces
{
    public interface IPermissionService
    {
        /// <summary>
        /// Distinct module names the user can access, derived from their roles
        /// via sec.RolePermission (CanAccess = 1).
        /// </summary>
        Task<List<string>> GetModulesForUserAsync(string userId);
    }
}
