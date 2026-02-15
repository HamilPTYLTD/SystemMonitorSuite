using Microsoft.AspNetCore.Mvc;

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
        var cpuUsage = 25.3;   // placeholder
        var memoryUsage = 48.7; // placeholder
        return Ok(new { cpu = cpuUsage, memory = memoryUsage, timestamp = DateTime.UtcNow });
    }
}
