using Microsoft.EntityFrameworkCore;
using SistemaGerencial.Enums;
using SistemaGerencial.Models;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace SistemaGerencial.Dto
{
    public class TransactionDto
    {
        public int Id { get; set; }

        public int UserId { get; set; }
        public string Description { get; set; }

        public TransactionType Type { get; set; }

        [Precision(14, 2)]
        public decimal Value { get; set; }
        public DateTime DateTime { get; set; }
        public bool IsFixed { get; set; }

    }
}
