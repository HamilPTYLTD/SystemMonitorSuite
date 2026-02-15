using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace SystemMonitor.Backend.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class SystemMonitorController : ControllerBase
    {
        [HttpGet("status")]
        public IActionResult GetStatus()
        {
            return Ok(new { status = "Secure API working" });
        }

        [HttpGet("metrics")]
        public IActionResult GetMetrics()
        {
            return Ok(new
            {
                cpuTemperature = 45,
                gpuTemperature = 50,
                timestamp = DateTime.UtcNow
            });
        }
    }
}
