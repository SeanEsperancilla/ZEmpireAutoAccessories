using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ZEmpireAutoAccessories.Models
{
    // ===== schema: sec =====

    [Table("Employee", Schema = "sec")]
    public class Employee
    {
        [Key]
        public int EmployeeID { get; set; }

        public string UserId { get; set; } = null!;

        [Required, MaxLength(30)]
        public string EmployeeNumber { get; set; } = string.Empty;

        [Required, MaxLength(100)]
        public string FirstName { get; set; } = string.Empty;

        [MaxLength(100)]
        public string? MiddleName { get; set; }

        [Required, MaxLength(100)]
        public string LastName { get; set; } = string.Empty;

        [MaxLength(20)]
        public string? Suffix { get; set; }

        // Persisted computed column in the DB (read-only)
        public string FullName { get; private set; } = string.Empty;

        [MaxLength(30)]
        public string? ContactNumber { get; set; }

        [MaxLength(256)]
        public string? EmailAddress { get; set; }

        public bool IsActive { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }

        public ApplicationUser User { get; set; } = null!;
    }

    [Table("Module", Schema = "sec")]
    public class Module
    {
        [Key]
        public int ModuleID { get; set; }

        [Required, MaxLength(80)]
        public string ModuleName { get; set; } = string.Empty;

        public ICollection<RolePermission> RolePermissions { get; set; } = new List<RolePermission>();
    }

    [Table("RolePermission", Schema = "sec")]
    public class RolePermission
    {
        public string RoleId { get; set; } = null!;
        public int ModuleID { get; set; }
        public bool CanAccess { get; set; }

        public ApplicationRole Role { get; set; } = null!;
        public Module Module { get; set; } = null!;
    }
}
