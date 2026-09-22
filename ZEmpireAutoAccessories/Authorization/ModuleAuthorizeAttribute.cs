using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace ZEmpireAutoAccessories.Authorization
{
    /// <summary>
    /// Restricts an action/controller to users who have access to a specific
    /// module (from sec.RolePermission). Usage: [ModuleAuthorize("Sales")].
    /// Unauthenticated users are challenged (redirected to login); authenticated
    /// users without the module are forbidden (redirected to Access Denied).
    ///
    /// Several modules may be listed, in which case ANY one of them grants
    /// access: [ModuleAuthorize("Sales", "Service Invoices")]. That is for
    /// screens which only combine what other modules already own, so they
    /// need no module row of their own in sec.Module - such a screen is
    /// responsible for showing each user only the parts they hold.
    /// </summary>
    public sealed class ModuleAuthorizeAttribute : TypeFilterAttribute
    {
        public ModuleAuthorizeAttribute(params string[] modules)
            : base(typeof(ModuleAuthorizeFilter))
        {
            Arguments = new object[] { modules };
        }

        private sealed class ModuleAuthorizeFilter : IAuthorizationFilter
        {
            private readonly string[] _modules;

            public ModuleAuthorizeFilter(string[] modules) => _modules = modules;

            public void OnAuthorization(AuthorizationFilterContext context)
            {
                var user = context.HttpContext.User;

                if (user.Identity is null || !user.Identity.IsAuthenticated)
                {
                    context.Result = new ChallengeResult();
                    return;
                }

                if (!_modules.Any(m => user.HasClaim(AppClaims.ModuleAccess, m)))
                    context.Result = new ForbidResult();
            }
        }
    }
}
