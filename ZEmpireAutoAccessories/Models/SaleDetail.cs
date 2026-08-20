namespace ZEmpireAutoAccessories.Models
{
    public class SaleDetail
    {
        public int SaleDetailID { get; set; }

        public int SaleID { get; set; }

        public int PricingID { get; set; }

        public decimal Quantity { get; set; }

        public decimal SellingPrice { get; set; }

        public decimal Subtotal { get; set; }

        public Sale Sale { get; set; } = null!;

        public Pricing Pricing { get; set; } = null!;
    }
}
