using Microsoft.EntityFrameworkCore;
using SistemaGerencial.Models;
using System;

namespace SistemaGerencial.Data
{
    public class SistemaGerencialDBContext : DbContext
    {
        public SistemaGerencialDBContext(DbContextOptions<SistemaGerencialDBContext> options) : base(options)
        {

        }

        public DbSet<UserModel> Users { get; set; }
        public DbSet<TransactionModel> Transactions { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
        }
    }
}
