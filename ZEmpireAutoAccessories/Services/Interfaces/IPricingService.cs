using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Services.Interfaces
{
    public interface IPricingService
    {
        Task<decimal> CalculateSellingPrice(
            decimal basePrice,
            decimal markupPercentage);

        Task<Pricing?> GetPricing(
            int productId,
            int vehicleClassificationId);

        Task<Pricing> CreatePricing(
            int productId,
            int vehicleClassificationId,
            decimal basePrice,
            decimal markupPercentage,
            int userId);

        Task<Pricing> UpdatePricing(
            int pricingId,
            decimal basePrice,
            decimal markupPercentage,
            int userId);

        Task<List<Pricing>> GetAllPricing();

        Task<List<PriceHistory>> GetPriceHistory(
            int pricingId);
    }
}