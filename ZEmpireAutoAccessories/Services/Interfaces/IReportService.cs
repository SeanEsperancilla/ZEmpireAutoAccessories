using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Services.Interfaces
{
    public interface IReportService
    {
        Task<decimal> GetDailySales();

        Task<decimal> GetWeeklySales();

        Task<decimal> GetMonthlySales();

        Task<List<Product>> GetLowStockProducts();

        Task<List<Sale>> GetRecentSales(int count = 10);
    }
}