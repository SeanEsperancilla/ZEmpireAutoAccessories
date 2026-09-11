using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Services.Interfaces
{
    public interface IPricingService
    {
        /// <summary>
        /// Resolve a price from the cat.Pricing matrix
        /// (Product x TintVariant x VehicleClassification x Panel).
        /// Pass tintVariantId = null for non-tint products.
        /// </summary>
        Task<Pricing?> GetPricing(
            int productId,
            int? tintVariantId,
            int vehicleClassificationId,
            int panelId);

        /// <summary>Pass a search term to filter by product name.</summary>
        Task<List<Pricing>> GetAllPricing(string? q = null);

        Task<Pricing> CreatePricing(
            int productId,
            int? tintVariantId,
            int vehicleClassificationId,
            int panelId,
            decimal price);

        /// <summary>Change a price and record the change in cat.PriceHistory.</summary>
        Task<Pricing> UpdatePrice(int pricingId, decimal newPrice, string userId);

        Task<List<PriceHistory>> GetPriceHistory(int pricingId);
    }
}
