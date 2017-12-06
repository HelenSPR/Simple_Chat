using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace Advant.Models
{
    public class LoginModel
    {
        [Required]
        public string UserName { get; set; }
    }
}