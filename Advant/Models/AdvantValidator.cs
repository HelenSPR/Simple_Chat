using System;
using Microsoft.AspNet.Identity;
using System.Threading.Tasks;

namespace Advant.Models
{
    public class AdvantValidator: UserValidator<ApplicationUser>
    {
        public AdvantValidator(ApplicationUserManager user):base(user)
       {
            AllowOnlyAlphanumericUserNames = false;
        }
        public override async Task<IdentityResult> ValidateAsync(ApplicationUser user)
        {         
            try
            {
                if (user.UserName == null || user.UserName == string.Empty)
                {
                    return new IdentityResult("Пустое имя пользователя!");
                }
                else
                    return await base.ValidateAsync(user);
            }
            catch (Exception ex)
            {

                return new IdentityResult(ex.Message);
            }
            
        }
    }
}