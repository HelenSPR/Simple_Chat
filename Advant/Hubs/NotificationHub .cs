using System;
using Microsoft.AspNet.SignalR;
using Advant.Models;
using Microsoft.AspNet.Identity;


namespace Advant.Hubs
{
    public class NotificationHub : Hub
    {

        // Отправка сообщений
        public void Send(string message)
        {
            DateTime dt = DateTime.Now;

            // save to db
            MessageManager mn = new MessageManager();
            mn.SaveMessage(new Messages(dt, Context.User.Identity.GetUserId(), message));

            // push-up message on page
            Clients.All.addNewMessageToPageD(dt.ToString("HH:mm"), Context.User.Identity.Name, message);
        }

        
    }
}