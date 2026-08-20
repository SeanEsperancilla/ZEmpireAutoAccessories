namespace ZEmpireAutoAccessories.Models
{
    public class User
    {
        public int UserID { get; set; }

        public string FullName { get; set; } = string.Empty;

        public string UserName { get; set; } = string.Empty;

        public string PasswordHash { get; set; } = string.Empty;

        public string Role { get; set; } = string.Empty;

        public ICollection<Sale> Sales { get; set; } = new List<Sale>();

        public ICollection<InventoryTransaction> InventoryTransactions { get; set; }
            = new List<InventoryTransaction>();

        public ICollection<PriceHistory> PriceHistories { get; set; }
            = new List<PriceHistory>();
    }
}
