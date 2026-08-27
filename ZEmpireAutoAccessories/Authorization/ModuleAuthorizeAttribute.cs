using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace ZEmpireAutoAccessories.Authorization
{
    /// <summary>
    /// Restricts an action/controller to users who have access to a specific
    /// module (from sec.RolePermission). Usage: [ModuleAuthorize("Sales")].
    /// Unauthenticated users are challenged (redirected to login); authenticated
    /// users without the module are forbidden (redirected to Access Denied).
    /// </summary>
    public sealed class ModuleAuthorizeAttribute : TypeFilterAttribute
    {
        public ModuleAuthorizeAttribute(string module)
            : base(typeof(ModuleAuthorizeFilter))
        {
            Arguments = new object[] { module };
        }

        private sealed class ModuleAuthorizeFilter : IAuthorizationFilter
        {
            private readonly string _module;

            public ModuleAuthorizeFilter(string module) => _module = module;

            public void OnAuthorization(AuthorizationFilterContext context)
            {
                var user = context.HttpContext.User;

                if (user.Identity is null || !user.Identity.IsAuthenticated)
                {
                    context.Result = new ChallengeResult();
                    return;
                }

                if (!user.HasClaim(AppClaims.ModuleAccess, _module))
                    context.Result = new ForbidResult();
            }
        }
    }
}
