using System;
using System.ComponentModel;

namespace SistemaGerencial.Enums
{
    public enum TransactionType: sbyte
    {
        [Description("Expense")]
        Expense = 1,

        [Description("Income")]
        Income = 2
    }
}
