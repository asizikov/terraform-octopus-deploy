using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;

namespace echo_api
{
    public static class MyHeaders
    {
        [FunctionName("MyHeaders")]
        public static Task<IActionResult> RunAsync(
            [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)]
            HttpRequestMessage req, ILogger log)
        {
            log.LogInformation("Function triggered");
            return Task.FromResult<IActionResult>(new OkObjectResult(GetRequestHeaders(req)));
        }

        private static string GetRequestHeaders(HttpRequestMessage request)
        {
            var sb = new StringBuilder();
            foreach (var header in request.Headers)
            {
                PrintHeader(header.Key, request, sb);
            }

            return sb.ToString();
        }

        private static void PrintHeader(string header, HttpRequestMessage request, StringBuilder sb)
        {
            if (request.Headers.TryGetValues(header, out var values))
            {
                foreach (var val in values)
                {
                    sb.AppendLine($"{header}={val}");
                }
            }
        }
    }
}