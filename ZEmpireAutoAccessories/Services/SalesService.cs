using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;
using ZEmpireAutoAccessories.Services.Interfaces;

namespace ZEmpireAutoAccessories.Services
{
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
                .Include(s => s.User)
                .Include(s => s.SaleDetails)
                    .ThenInclude(sd => sd.Pricing)
                        .ThenInclude(p => p.Product)
                .Include(s => s.SaleDetails)
                    .ThenInclude(sd => sd.Pricing)
                        .ThenInclude(p =>
                            p.VehicleClassification)
                .FirstOrDefaultAsync(s =>
                    s.SaleID == saleId);
        }

        public async Task<List<Sale>> GetSales()
        {
            return await _context.Sales
                .Include(s => s.Customer)
                .Include(s => s.User)
                .OrderByDescending(s => s.SalesDate)
                .ToListAsync();
        }

        public async Task<Sale> CreateSale(
            int userId,
            int customerId,
            string modeOfPayment,
            List<SaleDetailRequest> items)
        {
            if (items == null || items.Count == 0)
                throw new InvalidOperationException(
                    "A sale must contain at least one item.");

            await using var transaction =
                await _context.Database.BeginTransactionAsync();

            try
            {
                var customer =
                    await _context.Customers
                        .FirstOrDefaultAsync(c =>
                            c.CustomerID == customerId);

                if (customer == null)
                    throw new KeyNotFoundException(
                        "Customer was not found.");

                var sale = new Sale
                {
                    UserID = userId,
                    CustomerID = customerId,
                    ModeOfPayment = modeOfPayment,
                    SalesDate = DateTime.Now,
                    TotalAmount = 0
                };

                _context.Sales.Add(sale);

                await _context.SaveChangesAsync();

                decimal total = 0;

                foreach (var item in items)
                {
                    if (item.Quantity <= 0)
                        throw new ArgumentException(
                            "Sale quantity must be greater than zero.");

                    var pricing =
                        await _context.Pricings
                            .Include(p => p.Product)
                            .FirstOrDefaultAsync(p =>
                                p.PricingID == item.PricingID);

                    if (pricing == null)
                        throw new KeyNotFoundException(
                            $"Pricing ID {item.PricingID} was not found.");

                    var product = pricing.Product;

                    if (product.CurrentStock < item.Quantity)
                    {
                        throw new InvalidOperationException(
                            $"Insufficient stock for {product.ProductName}.");
                    }

                    var subtotal =
                        pricing.SellingPrice * item.Quantity;

                    var saleDetail = new SaleDetail
                    {
                        SaleID = sale.SaleID,
                        PricingID = pricing.PricingID,
                        Quantity = item.Quantity,
                        SellingPrice = pricing.SellingPrice,
                        Subtotal = subtotal
                    };

                    _context.SaleDetails.Add(saleDetail);

                    product.CurrentStock -= item.Quantity;

                    var inventoryTransaction =
                        new InventoryTransaction
                        {
                            UserID = userId,
                            ProductID = product.ProductID,
                            TransactionType = "OUT",
                            Quantity = item.Quantity,
                            TransactionDate = DateTime.Now
                        };

                    _context.InventoryTransactions
                        .Add(inventoryTransaction);

                    total += subtotal;
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

    public class SaleDetailRequest
    {
        public int PricingID { get; set; }

        public decimal Quantity { get; set; }
    }
}