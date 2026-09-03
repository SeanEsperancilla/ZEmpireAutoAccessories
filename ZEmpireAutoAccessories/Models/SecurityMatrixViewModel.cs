namespace ZEmpireAutoAccessories.Models
{
    public class PermissionCell
    {
        public string RoleId { get; set; } = string.Empty;
        public string RoleName { get; set; } = string.Empty;
        public int ModuleID { get; set; }
        public string ModuleName { get; set; } = string.Empty;
        public bool CanAccess { get; set; }
    }

    public class SecurityMatrixViewModel
    {
        public List<Module> Modules { get; set; } = new();
        public List<ApplicationRole> Roles { get; set; } = new();
        public List<PermissionCell> Cells { get; set; } = new();
    }
}
