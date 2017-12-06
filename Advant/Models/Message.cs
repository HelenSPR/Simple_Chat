using System;
using System.ComponentModel.DataAnnotations;

namespace Advant.Models
{
    public class Messages
    {
        [Key]
        public int Id { get; set; }
        public DateTime Date { get; set; }
        public string UserId { get; set; }
        public string Message { get; set; }

        public string UserName = string.Empty;

        public Messages() { }

        public Messages(DateTime Date, string UserId, string Message, string UserName = "")
        {
            this.Date = Date;
            this.UserId = UserId;
            this.Message = Message;
            this.UserName = UserName;
        }

        
    }
}