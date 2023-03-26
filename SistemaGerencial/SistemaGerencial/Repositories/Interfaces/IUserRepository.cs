using SistemaGerencial.Models;

namespace SistemaGerencial.Repository.Interfaces
{
    public interface IUserRepository
    {
        Task<List<UserModel>> GetAll();
        Task<UserModel> GetById(int id);
        Task<UserModel> Add(UserModel user);
        Task<UserModel> Update(UserModel user);
        Task<bool> Delete(int id);
    }
}
