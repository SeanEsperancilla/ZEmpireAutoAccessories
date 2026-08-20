namespace ZEmpireAutoAccessories.Models
{
    public class PriceHistory
    {
        public int PriceHistoryID { get; set; }

        public int UserID { get; set; }

        public int PricingID { get; set; }

        public decimal OldPrice { get; set; }

        public decimal NewPrice { get; set; }

        public DateTime DateChanged { get; set; }

        public User User { get; set; } = null!;

        public Pricing Pricing { get; set; } = null!;
    }
}
