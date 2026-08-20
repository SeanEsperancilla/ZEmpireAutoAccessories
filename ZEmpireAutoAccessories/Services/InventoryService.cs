using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;
using ZEmpireAutoAccessories.Services.Interfaces;

namespace ZEmpireAutoAccessories.Services
{
    public class InventoryService : IInventoryService 
    { 
        private readonly ApplicationDbContext _context;

        public InventoryService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<Product?> GetProduct(int productId)
        {
            return await _context.Products
                .FirstOrDefaultAsync(p =>
                    p.ProductID == productId);
        }

        public async Task<List<Product>> GetAllProducts()
        {
            return await _context.Products
                .OrderBy(p => p.ProductName)
                .ToListAsync();
        }

        public async Task<List<Product>> GetLowStockProducts()
        {
            return await _context.Products
                .Where(p =>
                    p.CurrentStock <= p.LowStockThreshold)
                .OrderBy(p => p.ProductName)
                .ToListAsync();
        }

        public async Task StockIn(
            int productId,
            decimal quantity,
            int userId)
        {
            if (quantity <= 0)
                throw new ArgumentException(
                    "Stock-in quantity must be greater than zero.");

            var product =
                await _context.Products
                    .FirstOrDefaultAsync(p =>
                        p.ProductID == productId);

            if (product == null)
                throw new KeyNotFoundException(
                    "Product was not found.");

            product.CurrentStock += quantity;

            var transaction = new InventoryTransaction
            {
                ProductID = productId,
                UserID = userId,
                TransactionType = "IN",
                Quantity = quantity,
                TransactionDate = DateTime.Now
            };

            _context.InventoryTransactions
                .Add(transaction);

            await _context.SaveChangesAsync();
        }

        public async Task StockOut(
            int productId,
            decimal quantity,
            int userId)
        {
            if (quantity <= 0)
                throw new ArgumentException(
                    "Stock-out quantity must be greater than zero.");

            var product =
                await _context.Products
                    .FirstOrDefaultAsync(p =>
                        p.ProductID == productId);

            if (product == null)
                throw new KeyNotFoundException(
                    "Product was not found.");

            if (product.CurrentStock < quantity)
                throw new InvalidOperationException(
                    "Insufficient inventory.");

            product.CurrentStock -= quantity;

            var transaction = new InventoryTransaction
            {
                ProductID = productId,
                UserID = userId,
                TransactionType = "OUT",
                Quantity = quantity,
                TransactionDate = DateTime.Now
            };

            _context.InventoryTransactions
                .Add(transaction);

            await _context.SaveChangesAsync();
        }

        public async Task<bool> HasSufficientStock(
            int productId,
            decimal quantity)
        {
            var product =
                await _context.Products
                    .FirstOrDefaultAsync(p =>
                        p.ProductID == productId);

            if (product == null)
                return false;

            return product.CurrentStock >= quantity;
        }

        public async Task<List<InventoryTransaction>>
            GetTransactions(int productId)
        {
            return await _context.InventoryTransactions
                .Include(t => t.User)
                .Include(t => t.Product)
                .Where(t => t.ProductID == productId)
                .OrderByDescending(t => t.TransactionDate)
                .ToListAsync();
        }
    }
}