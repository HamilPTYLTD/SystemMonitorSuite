using Microsoft.AspNetCore.Mvc;

namespace SystemMonitor.Backend.Controllers
{
    [ApiController]
    [Route("/")]
    public class HomeController : ControllerBase
    {
        [HttpGet]
        public IActionResult Get()
        {
            return Content("System Monitor Backend is live!", "text/plain");
        }
    }
}
