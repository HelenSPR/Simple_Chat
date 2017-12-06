using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin;
using Advant.Models;

public class ApplicationUserManager: UserManager<ApplicationUser>
{
    public ApplicationUserManager(IUserStore<ApplicationUser> store)
            : base(store)
    {
    }
    public static ApplicationUserManager Create(IdentityFactoryOptions<ApplicationUserManager> options,
                                            IOwinContext context)
    {
        DBContext db = context.Get<DBContext>();
        ApplicationUserManager manager = new ApplicationUserManager(new UserStore<ApplicationUser>(db));
        manager.UserValidator  = new UserValidator<ApplicationUser>(manager)
        {
            AllowOnlyAlphanumericUserNames = false,
            RequireUniqueEmail = false
        };
        manager.PasswordValidator = new PasswordValidator
        {
            RequiredLength = 0,
            RequireNonLetterOrDigit = false,
            RequireDigit = false,
            RequireLowercase = false,
            RequireUppercase = false
            
        };

        return manager;
    }
}