namespace SistemaGerencial.Dto
{
    public class UserDto
    {
        public string? Name { get; set; }
        public string? Email { get; set; }
        public string Username { get; set; }
        public string Token { get; set; }
        public string RefreshToken { get; set; } 
        public DateTime ExpiresAt { get; set; }
    }
}
