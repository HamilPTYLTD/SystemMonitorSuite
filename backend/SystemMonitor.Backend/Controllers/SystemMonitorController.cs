using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/[controller]")]
public class SystemMonitorController : ControllerBase
{
    // Endpoint: /api/SystemMonitor/status
    [HttpGet("status")]
    public IActionResult GetStatus()
    {
        return Ok(new
        {
            status = "running",
            timestamp = DateTime.UtcNow
        });
    }

    // Endpoint: /api/SystemMonitor/metrics
    [HttpGet("metrics")]
    public IActionResult GetMetrics()
    {
        // Stub values — replace with real CPU/memory monitoring later
        var cpuUsage = 25.3; // %
        var memoryUsage = 48.7; // %

        return Ok(new
        {
            cpu = cpuUsage,
            memory = memoryUsage,
            timestamp = DateTime.UtcNow
        });
    }
}