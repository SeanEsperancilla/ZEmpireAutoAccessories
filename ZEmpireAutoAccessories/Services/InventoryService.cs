using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;
using ZEmpireAutoAccessories.Services.Interfaces;

namespace ZEmpireAutoAccessories.Services
{
    /// <summary>
    /// Stock is transaction-based: there is no CurrentStock column. Stock-on-hand
    /// is SUM(IN) - SUM(OUT) over inv.InventoryTransaction (see dbo.vw_StockOnHand).
    /// </summary>
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
                .FirstOrDefaultAsync(p => p.ProductID == productId);
        }

        public async Task<List<Product>> GetAllProducts()
        {
            return await _context.Products
                .OrderBy(p => p.ProductName)
                .ToListAsync();
        }

        public async Task<decimal> GetStockOnHand(int productId)
        {
            // SUM() over zero matching rows (a product with no transactions
            // yet) comes back as SQL NULL, not 0 - project through a
            // nullable decimal so EF can represent that, then default it.
            return await _context.InventoryTransactions
                .Where(t => t.ProductID == productId)
                .SumAsync(t => (decimal?)(t.TransactionType == "IN" ? t.Quantity : -t.Quantity)) ?? 0;
        }

        public async Task<List<VwStockOnHand>> GetStockLevels()
        {
            return await _context.StockOnHand
                .OrderBy(s => s.ProductName)
                .ToListAsync();
        }

        public async Task StockIn(int productId, decimal quantity, string userId)
        {
            if (quantity <= 0)
                throw new ArgumentException("Stock-in quantity must be greater than zero.");

            await EnsureProductExists(productId);

            _context.InventoryTransactions.Add(new InventoryTransaction
            {
                ProductID = productId,
                UserId = userId,
                TransactionType = "IN",
                Quantity = quantity,
                TransactionDate = DateTime.Now
            });

            await _context.SaveChangesAsync();
        }

        public async Task StockOut(int productId, decimal quantity, string userId)
        {
            if (quantity <= 0)
                throw new ArgumentException("Stock-out quantity must be greater than zero.");

            await EnsureProductExists(productId);

            if (await GetStockOnHand(productId) < quantity)
                throw new InvalidOperationException("Insufficient inventory.");

            _context.InventoryTransactions.Add(new InventoryTransaction
            {
                ProductID = productId,
                UserId = userId,
                TransactionType = "OUT",
                Quantity = quantity,
                TransactionDate = DateTime.Now
            });

            await _context.SaveChangesAsync();
        }

        public async Task PostDocumentStock(
            IReadOnlyCollection<DocumentStockLine> lines, bool consume, string userId)
        {
            // A document can carry the same product on more than one line, and
            // the stock check has to see the total rather than each line on its
            // own - two lines of 3 against 5 in stock is short, even though
            // neither line is.
            var byProduct = lines
                .Where(l => l.Quantity > 0)
                .GroupBy(l => l.ProductID)
                .Select(g => new { ProductID = g.Key, Quantity = g.Sum(l => l.Quantity) })
                .ToList();

            if (byProduct.Count == 0)
                return;

            if (consume)
            {
                // Check every line before writing any, so a document that is
                // short on its last product doesn't half-post.
                foreach (var line in byProduct)
                {
                    var onHand = await GetStockOnHand(line.ProductID);
                    if (onHand >= line.Quantity)
                        continue;

                    var name = (await GetProduct(line.ProductID))?.ProductName
                        ?? $"Product {line.ProductID}";

                    throw new InvalidOperationException(onHand <= 0
                        ? $"{name} is out of stock."
                        : $"Not enough stock for {name} - only {onHand:N0} left, {line.Quantity:N0} needed.");
                }
            }

            foreach (var line in byProduct)
            {
                _context.InventoryTransactions.Add(new InventoryTransaction
                {
                    ProductID = line.ProductID,
                    UserId = userId,
                    TransactionType = consume ? "OUT" : "IN",
                    Quantity = line.Quantity,
                    TransactionDate = DateTime.Now
                });
            }

            await _context.SaveChangesAsync();
        }

        public async Task<bool> HasSufficientStock(int productId, decimal quantity)
        {
            return await GetStockOnHand(productId) >= quantity;
        }

        public async Task<List<InventoryTransaction>> GetTransactions(int productId)
        {
            return await _context.InventoryTransactions
                .Include(t => t.User)
                .Include(t => t.Product)
                .Where(t => t.ProductID == productId)
                .OrderByDescending(t => t.TransactionDate)
                .ToListAsync();
        }

        private async Task EnsureProductExists(int productId)
        {
            if (!await _context.Products.AnyAsync(p => p.ProductID == productId))
                throw new KeyNotFoundException("Product was not found.");
        }
    }
}
