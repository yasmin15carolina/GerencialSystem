using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using SistemaGerencial.Enums;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SistemaGerencial.Models
{
    public class TransactionModel
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey("User")]
        public int UserId { get; set; }
        public string Description { get; set; }

        public TransactionType Type { get; set; }

        [Precision(14, 2)]
        public decimal Value { get; set; }
        public DateTime DateTime { get; set; }
        public bool IsFixed { get; set; }

        public virtual UserModel User { get; set; }
    }

}
