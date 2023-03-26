using Microsoft.EntityFrameworkCore;
using SistemaGerencial.Data;
using SistemaGerencial.Models;
using SistemaGerencial.Repository.Interfaces;

namespace SistemaGerencial.Repository
{
    public class UserRepository : BaseRepository<UserModel>

    {
        private readonly SistemaGerencialDBContext _DBContext;

        public UserRepository(SistemaGerencialDBContext dBContext)        {
            _DBContext = dBContext;
        }

        public async Task<UserModel> Add(UserModel user)
        {
            _DBContext.Users.Add(user);
            _DBContext.SaveChanges();

            return user;
        }

        public async Task<bool> Delete(int id)
        {
            UserModel user = await GetById(id);

            if(user == null)
            {
                throw new Exception($"Usuário de id: {id} não foi encontrado");
            }

            _DBContext.Users.Remove(user);
            await _DBContext.SaveChangesAsync();

            return true;
        }

        public async Task<List<UserModel>> GetAll()
        {
            return await _DBContext.Users.ToListAsync();
        }

        public async Task<UserModel> GetById(int id)
        {
            return await _DBContext.Users.FirstOrDefaultAsync(x => x.Id == id);
        }

        public async Task<UserModel> GetLogin(String username)
        {
            return await _DBContext.Users.FirstOrDefaultAsync(x => x.Username == username);
        }

        public async Task<UserModel> Update(UserModel user)
        {
           UserModel userById = await GetById(user.Id);
            if(userById == null)
            {
                throw new InvalidOperationException($"Usuario com id: {user.Id} não encontrado");
            }
            userById.Name= user.Name;
            userById.Email= user.Email;

            _DBContext.Users.Update(userById);
            _DBContext.SaveChanges();

            return userById;
        }

        public async Task<UserModel> UpdateRefreshToken(RefreshToken refreshToken, string username)
        {
            UserModel userUpdate = await GetLogin(username);
            if (userUpdate == null)
            {
                throw new InvalidOperationException($"Usuario com username: {username} não encontrado");
            }
            userUpdate.RefreshToken = refreshToken.Token;
            userUpdate.Created = refreshToken.Created;
            userUpdate.Expires = refreshToken.Expires;

             _DBContext.Users.Update(userUpdate);
           await  _DBContext.SaveChangesAsync();

            return userUpdate;
        }
    }
}
