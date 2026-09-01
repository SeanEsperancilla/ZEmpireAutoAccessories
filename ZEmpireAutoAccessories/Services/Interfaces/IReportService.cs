using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Services.Interfaces
{
    public interface IReportService
    {
        Task<decimal> GetDailySales();

        Task<decimal> GetWeeklySales();

        Task<decimal> GetMonthlySales();

        /// <summary>Products at or below the given stock-on-hand threshold.</summary>
        Task<List<VwStockOnHand>> GetLowStock(decimal threshold = 5);

        Task<List<Sale>> GetRecentSales(int count = 10);
    }
}
