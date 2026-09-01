using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Data;
using ZEmpireAutoAccessories.Models;
using ZEmpireAutoAccessories.Services.Interfaces;

namespace ZEmpireAutoAccessories.Services
{
    /// <summary>
    /// Pricing is a matrix in cat.Pricing keyed by
    /// Product x TintVariant(optional) x VehicleClassification x Panel.
    /// Price changes are journaled to cat.PriceHistory.
    /// </summary>
    public class PricingService : IPricingService
    {
        private readonly ApplicationDbContext _context;

        public PricingService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<Pricing?> GetPricing(
            int productId,
            int? tintVariantId,
            int vehicleClassificationId,
            int panelId)
        {
            return await _context.Pricings
                .Include(p => p.Product)
                .Include(p => p.VehicleClassification)
                .Include(p => p.Panel)
                .Include(p => p.TintVariant)
                .FirstOrDefaultAsync(p =>
                    p.ProductID == productId &&
                    p.TintVariantID == tintVariantId &&
                    p.VehicleClassificationID == vehicleClassificationId &&
                    p.PanelID == panelId);
        }

        public async Task<List<Pricing>> GetAllPricing()
        {
            return await _context.Pricings
                .Include(p => p.Product)
                .Include(p => p.VehicleClassification)
                .Include(p => p.Panel)
                .Include(p => p.TintVariant)
                .OrderBy(p => p.Product.ProductName)
                .ToListAsync();
        }

        public async Task<Pricing> CreatePricing(
            int productId,
            int? tintVariantId,
            int vehicleClassificationId,
            int panelId,
            decimal price)
        {
            if (price < 0)
                throw new ArgumentException("Price cannot be negative.");

            var existing = await GetPricing(productId, tintVariantId, vehicleClassificationId, panelId);
            if (existing != null)
                throw new InvalidOperationException(
                    "Pricing already exists for this product / variant / classification / panel.");

            var pricing = new Pricing
            {
                ProductID = productId,
                TintVariantID = tintVariantId,
                VehicleClassificationID = vehicleClassificationId,
                PanelID = panelId,
                Price = price
            };

            _context.Pricings.Add(pricing);
            await _context.SaveChangesAsync();

            return pricing;
        }

        public async Task<Pricing> UpdatePrice(int pricingId, decimal newPrice, string userId)
        {
            if (newPrice < 0)
                throw new ArgumentException("Price cannot be negative.");

            var pricing = await _context.Pricings
                .FirstOrDefaultAsync(p => p.PricingID == pricingId);

            if (pricing == null)
                throw new KeyNotFoundException("Pricing record was not found.");

            var oldPrice = pricing.Price;

            if (oldPrice != newPrice)
            {
                _context.PriceHistories.Add(new PriceHistory
                {
                    PricingID = pricing.PricingID,
                    UserId = userId,
                    OldPrice = oldPrice,
                    NewPrice = newPrice,
                    DateChanged = DateTime.Now
                });

                pricing.Price = newPrice;
                await _context.SaveChangesAsync();
            }

            return pricing;
        }

        public async Task<List<PriceHistory>> GetPriceHistory(int pricingId)
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
