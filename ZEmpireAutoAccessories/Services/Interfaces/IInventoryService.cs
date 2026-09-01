using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Services.Interfaces
{
    public interface IInventoryService
    {
        Task<Product?> GetProduct(int productId);

        Task<List<Product>> GetAllProducts();

        /// <summary>Net stock (SUM IN - SUM OUT) for a product from inv.InventoryTransaction.</summary>
        Task<decimal> GetStockOnHand(int productId);

        /// <summary>Stock-on-hand for every product, from the dbo.vw_StockOnHand view.</summary>
        Task<List<VwStockOnHand>> GetStockLevels();

        Task StockIn(int productId, decimal quantity, string userId);

        Task StockOut(int productId, decimal quantity, string userId);

        Task<bool> HasSufficientStock(int productId, decimal quantity);

        Task<List<InventoryTransaction>> GetTransactions(int productId);
    }
}
