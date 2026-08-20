namespace ZEmpireAutoAccessories.Models
{
    public class Pricing
    {
        public int PricingID { get; set; }

        public int VehicleClassificationID { get; set; }

        public int ProductID { get; set; }

        public decimal BasePrice { get; set; }

        public decimal MarkupPercentage { get; set; }

        public decimal SellingPrice { get; set; }

        public VehicleClassification VehicleClassification { get; set; } = null!;

        public Product Product { get; set; } = null!;

        public ICollection<PriceHistory> PriceHistories { get; set; }
            = new List<PriceHistory>();

        public ICollection<SaleDetail> SaleDetails { get; set; }
            = new List<SaleDetail>();
    }
}
