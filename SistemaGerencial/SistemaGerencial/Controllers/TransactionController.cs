using GrapeCity.Documents.Excel;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using SistemaGerencial.Dto;
using SistemaGerencial.Enums;
using SistemaGerencial.Repositories;
using System;
using System.Drawing;
using System.Net;
using System.Security.Claims;

namespace SistemaGerencial.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TransactionController : ControllerBase
    {
        private readonly TransactionRepository _transactionRepository;

        public TransactionController(TransactionRepository transactionRepository)
        {
            _transactionRepository = transactionRepository;
        }
        
        [HttpGet, Authorize]
        public async Task<ActionResult<List<TransactionDto>>> getAllAsync([FromHeader] TransactionType type)
        {
            var userId= HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);


            if (type != 0)
            {
                var obj = await _transactionRepository.GetByType(type, Int32.Parse(userId));
                return Ok(obj);

            }
            else
            {
                var obj = await _transactionRepository.GetAll(Int32.Parse(userId));
                return Ok(obj);

            }

        }

        [HttpGet("{id}"),Authorize]
        public async Task<ActionResult<TransactionDto>> GetById([FromRoute] int id)
        {
            var userId = HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);

            try
            {
                var obj = await _transactionRepository.GetById(id,Int32.Parse(userId));

                return Ok(obj);
            }catch (Exception ex)
            {
                return BadRequest(new {Message= $"Transaction {id} not found"});
            }
        }

        [HttpPost("Add"), Authorize]
        public async Task<ActionResult<TransactionDto>> Add([FromBody] TransactionDto req)
        {
            var userId = HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);
            try
            {
                req.UserId = Int32.Parse(userId);
                var obj = await _transactionRepository.Add(req);

                return Ok(obj);
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPost("AddList"),Authorize]
        public async Task<ActionResult<TransactionDto>> AddList([FromBody] List<TransactionDto> req)
        {
            var userId = HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);
            try
            {
                foreach(TransactionDto t in req) {
                    t.UserId = Int32.Parse(userId);
                   await  _transactionRepository.Add(t);
                }
                //var obj = await _transactionRepository.Add(req);

                return Ok("Transactions added");
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPut("Update"),Authorize]
        public async Task<ActionResult<TransactionDto>> Update([FromBody] TransactionDto req)
        {
            var userId = HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);
            try
            {
                var obj = await _transactionRepository.Update(req, Int32.Parse(userId));

                return Ok(obj);
            }catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpDelete("Delete/{id}"),Authorize]
        public async Task<ActionResult<TransactionDto>> Add([FromRoute] int id)
        {
            var userId = HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier);
            try
            {
                var obj = await _transactionRepository.Delete(id, Int32.Parse(userId));
                return Ok(new { Message = $"Transação: {id} Deletada!" });

            }
            catch (Exception ex)
            {
                //return BadRequest(new { Message = $"Não foi possivel Deletar a Transação de id:{id}"});
                return BadRequest(ex.Message);
            }


        }

        [HttpGet("Period")]
        public async Task<ActionResult<TransactionDto>> GetFromPeriod([FromQuery] DateTime start, [FromQuery] DateTime end)
        {
            try
            {
                var obj = await _transactionRepository.filterPeriod(start,end);

                return Ok(obj);
            }
            catch (Exception ex)
            {
                return BadRequest(new { Message = "Transação não encontrada" });
            }
        }


    }


}
