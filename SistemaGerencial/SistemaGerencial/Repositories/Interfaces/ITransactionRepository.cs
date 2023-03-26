using SistemaGerencial.Models;

namespace SistemaGerencial.Repositories.Interfaces
{
    public interface ITransactionRepository
    {
        Task<List<TransactionModel>> GetAll();
        Task<TransactionModel> GetById(int id);
        Task<TransactionModel> Add(TransactionModel transaction);
        Task<TransactionModel> Update(TransactionModel transaction);
        Task<bool> Delete(int id);
    }
}
