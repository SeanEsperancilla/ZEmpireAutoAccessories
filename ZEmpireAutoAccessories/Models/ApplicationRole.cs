using Microsoft.AspNetCore.Identity;

namespace ZEmpireAutoAccessories.Models
{
    /// <summary>Identity role mapped to asp.AspNetRoles (Admin / Manager / Staff).</summary>
    public class ApplicationRole : IdentityRole
    {
        public ApplicationRole() { }
        public ApplicationRole(string roleName) : base(roleName) { }
    }
}
