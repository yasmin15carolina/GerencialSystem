using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SistemaGerencial.Models;

namespace SistemaGerencial.Data.Maps
{
    public class TransactionMap : IEntityTypeConfiguration<TransactionModel>
    {
         public void Configure(EntityTypeBuilder<TransactionModel> builder)
        {
            builder.HasKey(x => x.Id);
            builder.Property(x => x.Description).IsRequired().HasMaxLength(255);
            builder.Property(x => x.Type).IsRequired();
            builder.Property(x => x.Value).IsRequired();
            builder.Property(x => x.DateTime).IsRequired();
            builder.Property(x => x.IsFixed).IsRequired();
        }
    }
}
