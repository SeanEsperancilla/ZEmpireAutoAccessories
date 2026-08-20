namespace ZEmpireAutoAccessories.Models
{
    public class Product
    {
        public int ProductID { get; set; }

        public string ProductName { get; set; } = string.Empty;

        public string? Description { get; set; }

        public string? Category { get; set; }

        public string? UnitOfMeasure { get; set; }

        public decimal CostPrice { get; set; }

        public decimal CurrentStock { get; set; }

        public decimal LowStockThreshold { get; set; }

        public ICollection<Pricing> Pricings { get; set; } = new List<Pricing>();

        public ICollection<InventoryTransaction> InventoryTransactions { get; set; }
            = new List<InventoryTransaction>();
    }
}
