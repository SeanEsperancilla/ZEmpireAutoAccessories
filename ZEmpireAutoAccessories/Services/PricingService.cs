using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;
using ZEmpireAutoAccessories.Services.Interfaces;

namespace ZEmpireAutoAccessories.Services
{
    public class PricingService : IPricingService

    {
        private readonly ApplicationDbContext _context;

        public PricingService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<decimal> CalculateSellingPrice(
            decimal basePrice,
            decimal markupPercentage)
        {
            if (basePrice < 0)
                throw new ArgumentException(
                    "Base price cannot be negative.");

            if (markupPercentage < 0)
                throw new ArgumentException(
                    "Markup percentage cannot be negative.");

            decimal markupAmount =
                basePrice * (markupPercentage / 100m);

            return basePrice + markupAmount;
        }

        public async Task<Pricing?> GetPricing(
            int productId,
            int vehicleClassificationId)
        {
            return await _context.Pricings
                .Include(p => p.Product)
                .Include(p => p.VehicleClassification)
                .FirstOrDefaultAsync(p =>
                    p.ProductID == productId &&
                    p.VehicleClassificationID ==
                    vehicleClassificationId);
        }

        public async Task<Pricing> CreatePricing(
            int productId,
            int vehicleClassificationId,
            decimal basePrice,
            decimal markupPercentage,
            int userId)
        {
            var existingPricing =
                await GetPricing(
                    productId,
                    vehicleClassificationId);

            if (existingPricing != null)
            {
                throw new InvalidOperationException(
                    "Pricing already exists for this product and vehicle classification.");
            }

            var sellingPrice =
                await CalculateSellingPrice(
                    basePrice,
                    markupPercentage);

            var pricing = new Pricing
            {
                ProductID = productId,
                VehicleClassificationID =
                    vehicleClassificationId,
                BasePrice = basePrice,
                MarkupPercentage = markupPercentage,
                SellingPrice = sellingPrice
            };

            _context.Pricings.Add(pricing);

            await _context.SaveChangesAsync();

            return pricing;
        }

        public async Task<Pricing> UpdatePricing(
            int pricingId,
            decimal basePrice,
            decimal markupPercentage,
            int userId)
        {
            var pricing =
                await _context.Pricings
                    .FirstOrDefaultAsync(p =>
                        p.PricingID == pricingId);

            if (pricing == null)
                throw new KeyNotFoundException(
                    "Pricing record was not found.");

            var oldPrice = pricing.SellingPrice;

            pricing.BasePrice = basePrice;
            pricing.MarkupPercentage = markupPercentage;

            pricing.SellingPrice =
                await CalculateSellingPrice(
                    basePrice,
                    markupPercentage);

            if (oldPrice != pricing.SellingPrice)
            {
                var history = new PriceHistory
                {
                    PricingID = pricing.PricingID,
                    UserID = userId,
                    OldPrice = oldPrice,
                    NewPrice = pricing.SellingPrice,
                    DateChanged = DateTime.Now
                };

                _context.PriceHistories.Add(history);
            }

            await _context.SaveChangesAsync();

            return pricing;
        }

        public async Task<List<Pricing>> GetAllPricing()
        {
            return await _context.Pricings
                .Include(p => p.Product)
                .Include(p => p.VehicleClassification)
                .OrderBy(p => p.Product.ProductName)
                .ToListAsync();
        }

        public async Task<List<PriceHistory>> GetPriceHistory(
            int pricingId)
        {
            return await _context.PriceHistories
                .Include(h => h.User)
                .Include(h => h.Pricing)
                .Where(h => h.PricingID == pricingId)
                .OrderByDescending(h => h.DateChanged)
                .ToListAsync();
        }
    }
}