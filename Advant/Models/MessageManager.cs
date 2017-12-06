using System.Collections.Generic;
using System.Linq;


namespace Advant.Models
{
    public class MessageManager
    {
        public List<Messages> MsgList;
       

        public MessageManager()
        {
            this.MsgList = new List<Messages>();
        }

        public void GetAllMessage()
        {
            DBContext db = new DBContext();
            var msg = from m in db.Msgs
                      join u in db.Users on m.UserId equals u.Id
                      select new { m.Date, m.UserId, m.Message, u.UserName };

            if (msg != null)
                foreach (var q in msg)
                    MsgList.Add(new Messages(q.Date, q.UserId, q.Message, q.UserName));
        }

        public void SaveMessage(Messages msg)
        {
            DBContext db = new DBContext();
            db.Msgs.Add(msg);
            db.SaveChanges();
        }
    }
}