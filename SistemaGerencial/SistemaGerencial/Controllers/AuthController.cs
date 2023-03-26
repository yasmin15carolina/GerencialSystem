using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using Org.BouncyCastle.Ocsp;
using SistemaGerencial.Dto;
using SistemaGerencial.Models;
using SistemaGerencial.Repository;
using SistemaGerencial.Repository.Interfaces;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Security.Cryptography;

namespace SistemaGerencial.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        //public static UserModel user = new UserModel();
        private readonly IConfiguration _configuration;
        private readonly UserRepository _userRepository;

        public AuthController(IConfiguration configuration, UserRepository userRepository)
        {
            _configuration = configuration;
            _userRepository = userRepository;
        }
        [HttpPost("register")]
        public async Task<ActionResult<UserModel>> Register(RegisterDto request)
        {
            CreatePasswordHash(request.Password, out byte[] passwordHash, out byte[] passwordSalt);

            UserModel user = new UserModel
            {
                Username = request.Username,
                PasswordHash = passwordHash,
                PasswordSalt = passwordSalt,
                Name = request.Name,
                Email = request.Email,
                Id = request.Id
            };


            var obj = await _userRepository.Add(user);
            return Ok(obj);

        }
        [HttpPost("login")]
        public async Task<ActionResult<string>> Login(LoginDto request)
        {
            UserModel user = await _userRepository.GetLogin(request.Username);

            if (user.Username != request.Username)
            {
                return BadRequest(new { Message = "User not found" });
            }
            if (!VerifyPasswordHash(request.Password, user.PasswordHash, user.PasswordSalt))
            {
                return BadRequest(new { Message = "Wrong Password" });
            }
            DateTime expiresAt;
            string token = CreateToken(user,  out expiresAt);

            var refreshToken = GenerateRefreshToken();
            await SetRefreshToken(refreshToken,user.Username);
            return Ok(new UserDto
                    {
                        Name = user.Name,
                        Email= user.Email,
                        Username = user.Username,
                        Token = token,
                        ExpiresAt = expiresAt,
                        RefreshToken = refreshToken.Token
                    });
        }
        [HttpPost("refreshToken")]
        public async Task<ActionResult<string>> RefreshToken([FromBody] string username)
        {
            var refreshToken = Request.Cookies["refreshToken"];
            var refreshToken2 = Request.Headers["refreshToken"];

            UserModel user = await _userRepository.GetLogin(username);

            if (!user.RefreshToken.Equals(refreshToken)) {
                return Unauthorized(new { Message = "Invalid Refresh Token!"}); 
            }
            else if(user.Expires <DateTime.Now)
            {
                return Unauthorized(new { Message = "Token Expired!" });
            }
            DateTime expiresAt;
            string token = CreateToken(user,out expiresAt);

            var newRefreshToken = GenerateRefreshToken();
            await SetRefreshToken(newRefreshToken, user.Username);
            return Ok(
                new UserDto
                {
                    Name = user.Name,
                    Email = user.Email,
                    Username = user.Username,
                    Token = token,
                    ExpiresAt = expiresAt,
                    RefreshToken = newRefreshToken.Token
                }
                );


        }
        private RefreshToken GenerateRefreshToken()
        {
            var refreshToken = new RefreshToken
            {
                Token = Convert.ToBase64String(RandomNumberGenerator.GetBytes(64)),
                Created = DateTime.Now,
                Expires = DateTime.Now.AddDays(7)
            };

            return refreshToken;
        }

        private async 
        Task
         SetRefreshToken(RefreshToken newRefreshToken, string username)
        {
            var cookieOptions = new CookieOptions
            {
                HttpOnly = true,
                Expires = newRefreshToken.Expires
            };
            Response.Cookies.Append("refreshToken", newRefreshToken.Token, cookieOptions);

            await _userRepository.UpdateRefreshToken(newRefreshToken, username);
        }

        private string CreateToken(UserModel user, out DateTime expiresAt)
        {
            List<Claim> claims = new List<Claim>
            {
                new Claim(ClaimTypes.Name,user.Username),
                new Claim(ClaimTypes.NameIdentifier,user.Id.ToString()),
            };
            var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(_configuration.GetSection("AppSettings:Token").Value));

            var cred = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature);
            expiresAt = DateTime.Now.AddDays(1);
            //expiresAt = DateTime.Parse("2023-03-21T11:25:32.8554053");
            var token = new JwtSecurityToken(
                claims: claims,
                signingCredentials: cred,
                expires: expiresAt
                );

            var jwt = new JwtSecurityTokenHandler().WriteToken(token);
            return jwt;
        }
        private void CreatePasswordHash(string password, out byte[] passwordHash, out byte[] passwordSalt)
        {
            using (var hmac = new HMACSHA512())
            {
                passwordSalt = hmac.Key;
                passwordHash = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
            }
        }

        private bool VerifyPasswordHash(string password, byte[] passwordHash, byte[] passwordSalt)
        {
            using (var hmac = new HMACSHA512(passwordSalt))
            {
                var computedHash = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
                return computedHash.SequenceEqual(passwordHash);
            }
        }


    }
}
