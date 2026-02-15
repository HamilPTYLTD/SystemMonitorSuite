using Microsoft.AspNetCore.Mvc;

namespace SystemMonitor.Backend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SystemMonitorController : ControllerBase
    {
        [HttpGet("status")]
        public IActionResult GetStatus()
        {
            return Ok(new { status = "running", timestamp = DateTime.UtcNow });
        }

        [HttpGet("metrics")]
        public IActionResult GetMetrics()
        {
            // Replace with real system metrics later
            var cpuUsage = 25.3;
            var memoryUsage = 48.7;
            return Ok(new { cpu = cpuUsage, memory = memoryUsage, timestamp = DateTime.UtcNow });
        }
    }
}

