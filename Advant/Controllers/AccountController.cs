using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Advant.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using System.Threading.Tasks;
using System.Security.Claims;

namespace Advant.Controllers
{
    public class AccountController : Controller
    {
        private ApplicationUserManager UserManager
        {
            get
            {
                return HttpContext.GetOwinContext().GetUserManager<ApplicationUserManager>();
            }
        }

        public ActionResult Register()
        {
            return View();
        }

        [HttpPost]
        public async Task<ActionResult> Register(RegisterModel model)
        {
            if (ModelState.IsValid)
            {
                
                ApplicationUser user = await UserManager.FindByNameAsync(model.UserName);

                if (user == null)
                {
                    user = new ApplicationUser { UserName = model.UserName };
                    IdentityResult result = await UserManager.CreateAsync(user);
                    if (result.Succeeded)
                    {

                        ClaimsIdentity claim = await UserManager.CreateIdentityAsync(user,
                                           DefaultAuthenticationTypes.ApplicationCookie);
                        AuthenticationManager.SignOut();
                        AuthenticationManager.SignIn(new AuthenticationProperties
                        {
                            IsPersistent = true
                        }, claim);

                        return RedirectToAction("Index", "Home");
                    }
                    else
                    {
                        foreach (string error in result.Errors)
                        {
                            ModelState.AddModelError("", error);
                        }
                    }
                }
                else
                    ModelState.AddModelError("", "Такой пользователь уже существует! Пожалуйста, измените имя...");
            }
            else
                ModelState.AddModelError("", "Некорректное имя! Пожалуйста, представьтесь.");

            return View(model);
        }

        private IAuthenticationManager AuthenticationManager
        {
            get
            {
                return HttpContext.GetOwinContext().Authentication;
            }
        }
    }
}