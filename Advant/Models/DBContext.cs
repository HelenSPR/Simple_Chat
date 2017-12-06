using System.Data.Entity;
using Microsoft.AspNet.Identity.EntityFramework;

namespace Advant.Models
{
    public class DBContext : IdentityDbContext<ApplicationUser>
    {
        public virtual DbSet<Messages> Msgs { get; set; } 

        public DBContext() : base("IdentityDb") { }

        public static DBContext Create()
        {
            return new DBContext();
        }
    }
}