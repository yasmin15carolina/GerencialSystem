using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SistemaGerencial.Models;
using SistemaGerencial.Repository;

namespace SistemaGerencial.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly UserRepository _userRepository;
        public UserController(UserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        [HttpGet]
        public async Task<ActionResult<List<UserModel>>> GetAllAsync()
        {
            var obj = await _userRepository.GetAll();
            return Ok(obj);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<UserModel>> GetUserById([FromRoute] int id)
        {
            var obj = await _userRepository.GetById(id);
            return Ok(obj);
        }

        [HttpPost]
        public async Task<ActionResult<UserModel>> AddUser([FromBody] UserModel req)
        {
            var obj = await _userRepository.Add(req);
            return Ok(obj);
        }

        [HttpPost("Update")]
        public async Task<ActionResult> UpdateUser([FromBody] UserModel req)
        {
            var obj = await _userRepository.Update(req);
            return Ok(obj);
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> DeleteUser([FromRoute] int id)
        {
            var obj = await _userRepository.Delete(id);
            return Ok($"Deletado: {id}");
        }
    }
}
