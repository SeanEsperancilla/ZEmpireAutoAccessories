namespace ZEmpireAutoAccessories.Models
{
    public class Sale
    {
        public int SaleID { get; set; }

        public int UserID { get; set; }

        public int CustomerID { get; set; }

        public string ModeOfPayment { get; set; } = string.Empty;

        public DateTime SalesDate { get; set; }

        public decimal TotalAmount { get; set; }

        public User User { get; set; } = null!;

        public Customer Customer { get; set; } = null!;

        public ICollection<SaleDetail> SaleDetails { get; set; }
            = new List<SaleDetail>();
    }
}
