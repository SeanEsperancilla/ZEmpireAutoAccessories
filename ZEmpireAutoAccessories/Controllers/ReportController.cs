using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Authorization;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Services.Interfaces;

namespace ZEmpireAutoAccessories.Controllers
{
    [ModuleAuthorize("Reports")]
    public class ReportController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly IReportService _reportService;

        public ReportController(ApplicationDbContext context, IReportService reportService)
        {
            _context = context;
            _reportService = reportService;
        }

        // GET: Report
        public async Task<IActionResult> Index()
        {
            ViewData["DailySales"] = await _reportService.GetDailySales();
            ViewData["WeeklySales"] = await _reportService.GetWeeklySales();
            ViewData["MonthlySales"] = await _reportService.GetMonthlySales();
            ViewData["LowStock"] = await _reportService.GetLowStock();
            ViewData["RecentSales"] = await _reportService.GetRecentSales();

            return View();
        }

        // GET: Report/Sales?from=&to=
        public async Task<IActionResult> Sales(DateOnly? from, DateOnly? to)
        {
            var query = _context.SalesSummaries.AsQueryable();

            if (from.HasValue)
                query = query.Where(s => s.SalesDate >= from.Value.ToDateTime(TimeOnly.MinValue));
            if (to.HasValue)
                query = query.Where(s => s.SalesDate < to.Value.AddDays(1).ToDateTime(TimeOnly.MinValue));

            var results = await query.OrderByDescending(s => s.SalesDate).ToListAsync();

            ViewData["From"] = from;
            ViewData["To"] = to;
            ViewData["Total"] = results.Sum(s => s.RecordedTotal);

            return View(results);
        }

        // GET: Report/JobOrders?from=&to=&status=
        public async Task<IActionResult> JobOrders(DateOnly? from, DateOnly? to, string? status)
        {
            var query = _context.JobOrderSummaries.AsQueryable();

            if (from.HasValue)
                query = query.Where(j => j.JobOrderDate >= from.Value.ToDateTime(TimeOnly.MinValue));
            if (to.HasValue)
                query = query.Where(j => j.JobOrderDate < to.Value.AddDays(1).ToDateTime(TimeOnly.MinValue));
            if (!string.IsNullOrEmpty(status))
                query = query.Where(j => j.Status == status);

            var results = await query.OrderByDescending(j => j.JobOrderDate).ToListAsync();

            ViewData["From"] = from;
            ViewData["To"] = to;
            ViewData["Status"] = status;
            ViewData["Total"] = results.Sum(j => j.TotalAmount);

            return View(results);
        }

        // GET: Report/ServiceInvoices?from=&to=&status=
        public async Task<IActionResult> ServiceInvoices(DateOnly? from, DateOnly? to, string? status)
        {
            var query = _context.ServiceInvoiceSummaries.AsQueryable();

            if (from.HasValue)
                query = query.Where(i => i.InvoiceDate >= from.Value.ToDateTime(TimeOnly.MinValue));
            if (to.HasValue)
                query = query.Where(i => i.InvoiceDate < to.Value.AddDays(1).ToDateTime(TimeOnly.MinValue));
            if (!string.IsNullOrEmpty(status))
                query = query.Where(i => i.Status == status);

            var results = await query.OrderByDescending(i => i.InvoiceDate).ToListAsync();

            ViewData["From"] = from;
            ViewData["To"] = to;
            ViewData["Status"] = status;
            ViewData["Total"] = results.Sum(i => i.TotalAmount);

            return View(results);
        }

        // GET: Report/Quotations?from=&to=&status=
        public async Task<IActionResult> Quotations(DateOnly? from, DateOnly? to, string? status)
        {
            var query = _context.QuotationSummaries.AsQueryable();

            if (from.HasValue)
                query = query.Where(q => q.QuotationDate >= from.Value.ToDateTime(TimeOnly.MinValue));
            if (to.HasValue)
                query = query.Where(q => q.QuotationDate < to.Value.AddDays(1).ToDateTime(TimeOnly.MinValue));
            if (!string.IsNullOrEmpty(status))
                query = query.Where(q => q.Status == status);

            var results = await query.OrderByDescending(q => q.QuotationDate).ToListAsync();

            ViewData["From"] = from;
            ViewData["To"] = to;
            ViewData["Status"] = status;
            ViewData["Total"] = results.Sum(q => q.TotalAmount);

            return View(results);
        }
    }
}