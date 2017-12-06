using System.Web.Mvc;
using Advant.Models;
using Advant.Hubs;

namespace Advant.Controllers
{
    public class HomeController : Controller
    {
        [AdvantAuthorize]
        public ActionResult Index()
        {
            MessageManager mm = new MessageManager();
            mm.GetAllMessage();

            return View(mm.MsgList);
        }

        public ActionResult Create()
        {
            return View();
        }

      /*  [HttpPost]
        public ActionResult Create(Messages msg)
        {
           // db.Books.Add(book);
          //  db.SaveChanges();
            SendMessage("Новое сообщение: ");
            return RedirectToAction("Index");
        }
        private void SendMessage(string message)
        {
            // Получаем контекст хаба
            var context =
                Microsoft.AspNet.SignalR.GlobalHost.ConnectionManager.GetHubContext<NotificationHub>();
            // отправляем сообщение
            context.Clients.All.displayMessage(message);
        }
        */
    }
}