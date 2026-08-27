using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ZEmpireAutoAccessories.Models
{
    // ===== schema: asp (ASP.NET Core Identity, mapped as plain entities) =====

    [Table("AspNetUsers", Schema = "asp")]
    public class AspNetUser
    {
        [Key]
        public string Id { get; set; } = null!;

        public string? UserName { get; set; }
        public string? NormalizedUserName { get; set; }
        public string? Email { get; set; }
        public string? NormalizedEmail { get; set; }
        public bool EmailConfirmed { get; set; }
        public string? PasswordHash { get; set; }
        public string? SecurityStamp { get; set; }
        public string? ConcurrencyStamp { get; set; }
        public string? PhoneNumber { get; set; }
        public bool PhoneNumberConfirmed { get; set; }
        public bool TwoFactorEnabled { get; set; }
        public DateTimeOffset? LockoutEnd { get; set; }
        public bool LockoutEnabled { get; set; }
        public int AccessFailedCount { get; set; }

        // Application-specific columns
        public string FullName { get; set; } = string.Empty;
        public bool IsActive { get; set; }
        public DateTime CreatedAt { get; set; }
    }

    [Table("AspNetRoles", Schema = "asp")]
    public class AspNetRole
    {
        [Key]
        public string Id { get; set; } = null!;

        public string? Name { get; set; }
        public string? NormalizedName { get; set; }
        public string? ConcurrencyStamp { get; set; }
    }

    [Table("AspNetRoleClaims", Schema = "asp")]
    public class AspNetRoleClaim
    {
        [Key]
        public int Id { get; set; }
        public string RoleId { get; set; } = null!;
        public string? ClaimType { get; set; }
        public string? ClaimValue { get; set; }

        public AspNetRole Role { get; set; } = null!;
    }

    [Table("AspNetUserClaims", Schema = "asp")]
    public class AspNetUserClaim
    {
        [Key]
        public int Id { get; set; }
        public string UserId { get; set; } = null!;
        public string? ClaimType { get; set; }
        public string? ClaimValue { get; set; }

        public AspNetUser User { get; set; } = null!;
    }

    [Table("AspNetUserLogins", Schema = "asp")]
    public class AspNetUserLogin
    {
        public string LoginProvider { get; set; } = null!;
        public string ProviderKey { get; set; } = null!;
        public string? ProviderDisplayName { get; set; }
        public string UserId { get; set; } = null!;

        public AspNetUser User { get; set; } = null!;
    }

    [Table("AspNetUserRoles", Schema = "asp")]
    public class AspNetUserRole
    {
        public string UserId { get; set; } = null!;
        public string RoleId { get; set; } = null!;

        public AspNetUser User { get; set; } = null!;
        public AspNetRole Role { get; set; } = null!;
    }

    [Table("AspNetUserTokens", Schema = "asp")]
    public class AspNetUserToken
    {
        public string UserId { get; set; } = null!;
        public string LoginProvider { get; set; } = null!;
        public string Name { get; set; } = null!;
        public string? Value { get; set; }

        public AspNetUser User { get; set; } = null!;
    }
}
