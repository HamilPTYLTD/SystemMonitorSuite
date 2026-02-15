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
        return Ok(new { cpu = 25.3, memory = 48.7, timestamp = DateTime.UtcNow });
    }
}
