using Microsoft.EntityFrameworkCore;
using SistemaGerencial.Data;
using SistemaGerencial.Dto;
using SistemaGerencial.Enums;
using SistemaGerencial.Models;
using SistemaGerencial.Repositories.Interfaces;
using SistemaGerencial.Repository;

namespace SistemaGerencial.Repositories
{
    public class TransactionRepository : BaseRepository<TransactionModel>
    {
        private readonly SistemaGerencialDBContext _dbContext;

        public TransactionRepository(SistemaGerencialDBContext dbContext)
        {
            _dbContext = dbContext;
        }

        public async Task<TransactionModel> Add(TransactionDto transaction)
        {
            var newTransaction = new TransactionModel
            {
                Id = transaction.Id,
                UserId = transaction.UserId,
                Description = transaction.Description,
                Type = transaction.Type,
                Value = transaction.Value,
                IsFixed = transaction.IsFixed,
                DateTime = DateTime.UtcNow
            };
            _dbContext.Transactions.Add(newTransaction);
            _dbContext.SaveChanges();
            return newTransaction;

        }

        public async Task<bool> Delete(int id,int userId)
        {
            TransactionModel transaction = await GetById(id, userId);

            if (transaction == null)
            {
                throw new Exception($"Usuário de id: {id} não foi encontrado");
            }

            _dbContext.Transactions.Remove(transaction);
            _dbContext.SaveChanges(true);
            return true;
        }

        public async Task<List<TransactionModel>> GetAll(int userId)
        {
            //return await _dbContext.Transactions.ToListAsync();
            return await _dbContext.Transactions.Where(x=> x.User.Id == userId).ToListAsync();
        }

        public async Task<List<TransactionModel>> GetByType(TransactionType type,int userId)
        {
            return await _dbContext.Transactions.Where(x => x.Type == type && x.User.Id == userId).ToListAsync();
        }

        public async Task<TransactionModel> GetById(int id,int userId)
        {
            TransactionModel transactionById = await _dbContext.Transactions.FirstOrDefaultAsync(x => x.Id == id && x.UserId == userId);

            if (transactionById == null)
            {
                throw new InvalidOperationException();
            }

            return transactionById;
        }

        public async Task<TransactionModel> Update(TransactionDto transaction,int userId)
        {
           var transactionToUpdate = await GetById(transaction.Id,userId);
            if (transactionToUpdate == null)
            {
                throw new Exception($"Usuário de id: {transaction.Id} não foi encontrado");
            }
            //transactionToUpdate.DateTime = DateTime.UtcNow;
            transactionToUpdate.Description = transaction.Description;
            transactionToUpdate.Value = transaction.Value;
            transactionToUpdate.IsFixed = transaction.IsFixed;
            transactionToUpdate.Type = transaction.Type;

             _dbContext.Update(transactionToUpdate);
            _dbContext.SaveChanges();

            return transactionToUpdate;
        }

        public async Task<List<TransactionModel>> filterPeriod(DateTime start, DateTime end)
        {
            return await _dbContext.Transactions.Where(x => x.DateTime >= start && x.DateTime<= end ).ToListAsync();
        }

    }
}
