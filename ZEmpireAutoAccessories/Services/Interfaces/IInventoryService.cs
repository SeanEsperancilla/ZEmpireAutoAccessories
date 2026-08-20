using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Services.Interfaces
{
    public interface IInventoryService
    {
        Task<Product?> GetProduct(int productId);

        Task<List<Product>> GetAllProducts();

        Task<List<Product>> GetLowStockProducts();

        Task StockIn(
            int productId,
            decimal quantity,
            int userId);

        Task StockOut(
            int productId,
            decimal quantity,
            int userId);

        Task<bool> HasSufficientStock(
            int productId,
            decimal quantity);

        Task<List<InventoryTransaction>> GetTransactions(
            int productId);
    }
}