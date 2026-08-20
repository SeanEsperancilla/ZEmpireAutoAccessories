namespace ZEmpireAutoAccessories.Models
{
    public class InventoryTransaction
    {
        public int InventoryTransactionID { get; set; }

        public int UserID { get; set; }

        public int ProductID { get; set; }

        public string TransactionType { get; set; } = string.Empty;

        public decimal Quantity { get; set; }

        public DateTime TransactionDate { get; set; }

        public User User { get; set; } = null!;

        public Product Product { get; set; } = null!;
    }
}
