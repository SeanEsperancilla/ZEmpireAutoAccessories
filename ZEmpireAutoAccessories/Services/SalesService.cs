using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;
using ZEmpireAutoAccessories.Services.Interfaces;

namespace ZEmpireAutoAccessories.Services
{
    /// <summary>
    /// Records a product sale (sales.Sales + sales.SalesDetail) and posts an
    /// inventory OUT transaction per line. Line SubTotal is a computed column
    /// in the database, so only Quantity and UnitPrice are set here.
    /// </summary>
    public class SalesService : ISalesService
    {
        private readonly ApplicationDbContext _context;

        public SalesService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<Sale?> GetSale(int saleId)
        {
            return await _context.Sales
                .Include(s => s.Customer)
                .Include(s => s.Vehicle)
                .Include(s => s.User)
                .Include(s => s.PaymentMode)
                .Include(s => s.SaleDetails)
                    .ThenInclude(sd => sd.Product)
                .FirstOrDefaultAsync(s => s.SalesID == saleId);
        }

        public async Task<List<Sale>> GetSales(string? q = null, int? productId = null, DateOnly? dateFrom = null, DateOnly? dateTo = null)
        {
            var query = _context.Sales
                .Include(s => s.Customer)
                .Include(s => s.User)
                .Include(s => s.PaymentMode)
                .AsQueryable();

            if (!string.IsNullOrWhiteSpace(q))
            {
                var term = q.Trim();
                query = query.Where(s =>
                    s.InvoiceNumber.Contains(term) ||
                    s.Customer.FullName.Contains(term));
            }

            if (productId.HasValue)
                query = query.Where(s => s.SaleDetails.Any(d => d.ProductID == productId.Value));

            if (dateFrom.HasValue)
                query = query.Where(s => s.SalesDate >= dateFrom.Value.ToDateTime(TimeOnly.MinValue));

            if (dateTo.HasValue)
                query = query.Where(s => s.SalesDate < dateTo.Value.AddDays(1).ToDateTime(TimeOnly.MinValue));

            return await query
                .OrderByDescending(s => s.SalesDate)
                .ToListAsync();
        }

        public async Task<int> GetUnitsSold(int productId, DateOnly? dateFrom = null, DateOnly? dateTo = null)
        {
            var query = _context.SalesDetails
                .Where(d => d.ProductID == productId)
                .AsQueryable();

            if (dateFrom.HasValue)
                query = query.Where(d => d.Sale.SalesDate >= dateFrom.Value.ToDateTime(TimeOnly.MinValue));

            if (dateTo.HasValue)
                query = query.Where(d => d.Sale.SalesDate < dateTo.Value.AddDays(1).ToDateTime(TimeOnly.MinValue));

            // SUM() over zero matching rows (nothing sold in range) comes
            // back as SQL NULL, not 0 - project through a nullable int so
            // EF can represent that, then default it.
            return await query.SumAsync(d => (int?)d.Quantity) ?? 0;
        }

        public async Task<Sale> CreateSale(
            string userId,
            int customerId,
            int paymentModeId,
            string invoiceNumber,
            int? vehicleId,
            List<SaleLineRequest> items)
        {
            if (items == null || items.Count == 0)
                throw new InvalidOperationException("A sale must contain at least one item.");

            await using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                if (!await _context.Customers.AnyAsync(c => c.CustomerID == customerId))
                    throw new KeyNotFoundException("Customer was not found.");

                var sale = new Sale
                {
                    InvoiceNumber = invoiceNumber,
                    CustomerID = customerId,
                    VehicleID = vehicleId,
                    UserId = userId,
                    PaymentModeID = paymentModeId,
                    SalesDate = DateTime.Now,
                    TotalAmount = 0
                };

                _context.Sales.Add(sale);
                await _context.SaveChangesAsync();

                decimal total = 0;

                foreach (var item in items)
                {
                    if (item.Quantity <= 0)
                        throw new ArgumentException("Sale quantity must be greater than zero.");

                    var product = await _context.Products
                        .FirstOrDefaultAsync(p => p.ProductID == item.ProductID)
                        ?? throw new KeyNotFoundException($"Product ID {item.ProductID} was not found.");

                    // SUM() over zero matching rows (a product never
                    // stocked in/out yet) comes back as SQL NULL, not 0 -
                    // project through a nullable decimal so EF can
                    // represent that, then default it.
                    var stockOnHand = await _context.InventoryTransactions
                        .Where(t => t.ProductID == item.ProductID)
                        .SumAsync(t => (decimal?)(t.TransactionType == "IN" ? t.Quantity : -t.Quantity)) ?? 0;

                    if (stockOnHand < item.Quantity)
                        throw new InvalidOperationException(
                            stockOnHand <= 0
                                ? $"{product.ProductName} is out of stock."
                                : $"Not enough stock for {product.ProductName} - only {stockOnHand:N0} left, {item.Quantity:N0} requested.");

                    _context.SalesDetails.Add(new SaleDetail
                    {
                        SalesID = sale.SalesID,
                        ProductID = item.ProductID,
                        Quantity = item.Quantity,
                        UnitPrice = item.UnitPrice
                        // SubTotal is a computed column in the database
                    });

                    _context.InventoryTransactions.Add(new InventoryTransaction
                    {
                        ProductID = item.ProductID,
                        UserId = userId,
                        TransactionType = "OUT",
                        Quantity = item.Quantity,
                        TransactionDate = DateTime.Now
                    });

                    total += item.UnitPrice * item.Quantity;
                }

                sale.TotalAmount = total;
                await _context.SaveChangesAsync();

                await transaction.CommitAsync();
                return sale;
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }
    }
}
