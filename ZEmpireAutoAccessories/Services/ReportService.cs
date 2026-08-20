using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;
using ZEmpireAutoAccessories.Services.Interfaces;

namespace ZEmpireAutoAccessories.Services
{
    public class ReportService : IReportService
    {
        private readonly ApplicationDbContext _context;

        public ReportService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<decimal> GetDailySales()
        {
            var today = DateTime.Today;
            var tomorrow = today.AddDays(1);

            return await _context.Sales
                .Where(s =>
                    s.SalesDate >= today &&
                    s.SalesDate < tomorrow)
                .SumAsync(s => (decimal?)s.TotalAmount) ?? 0;
        }

        public async Task<decimal> GetWeeklySales()
        {
            var today = DateTime.Today;

            var startOfWeek =
                today.AddDays(
                    -(int)today.DayOfWeek);

            var endOfWeek =
                startOfWeek.AddDays(7);

            return await _context.Sales
                .Where(s =>
                    s.SalesDate >= startOfWeek &&
                    s.SalesDate < endOfWeek)
                .SumAsync(s => (decimal?)s.TotalAmount) ?? 0;
        }

        public async Task<decimal> GetMonthlySales()
        {
            var today = DateTime.Today;

            var startOfMonth =
                new DateTime(
                    today.Year,
                    today.Month,
                    1);

            var startOfNextMonth =
                startOfMonth.AddMonths(1);

            return await _context.Sales
                .Where(s =>
                    s.SalesDate >= startOfMonth &&
                    s.SalesDate < startOfNextMonth)
                .SumAsync(s => (decimal?)s.TotalAmount) ?? 0;
        }

        public async Task<List<Product>>
            GetLowStockProducts()
        {
            return await _context.Products
                .Where(p =>
                    p.CurrentStock <=
                    p.LowStockThreshold)
                .OrderBy(p => p.CurrentStock)
                .ToListAsync();
        }

        public async Task<List<Sale>>
            GetRecentSales(int count = 10)
        {
            return await _context.Sales
                .Include(s => s.Customer)
                .OrderByDescending(s => s.SalesDate)
                .Take(count)
                .ToListAsync();
        }
    }
}