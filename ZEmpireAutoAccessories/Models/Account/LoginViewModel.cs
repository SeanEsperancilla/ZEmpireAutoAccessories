using System.ComponentModel.DataAnnotations;

namespace ZEmpireAutoAccessories.Models.Account
{
    public class LoginViewModel
    {
        [Required(ErrorMessage = "Username or email is required.")]
        [Display(Name = "Username or email")]
        public string UserNameOrEmail { get; set; } = string.Empty;

        [Required(ErrorMessage = "Password is required.")]
        [DataType(DataType.Password)]
        public string Password { get; set; } = string.Empty;

        [Display(Name = "Remember me")]
        public bool RememberMe { get; set; }

        public string? ReturnUrl { get; set; }
    }
}
