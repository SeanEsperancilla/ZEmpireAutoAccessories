using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ZEmpireAutoAccessories.Models
{
    // ===== schema: inv =====

    [Table("InventoryTransaction", Schema = "inv")]
    public class InventoryTransaction
    {
        [Key]
        public int InventoryTransactionID { get; set; }

        public int ProductID { get; set; }
        public string UserId { get; set; } = null!;

        [Required, MaxLength(3)]
        public string TransactionType { get; set; } = string.Empty; // 'IN' or 'OUT'

        public decimal Quantity { get; set; }
        public DateTime TransactionDate { get; set; }

        public Product Product { get; set; } = null!;
        public ApplicationUser User { get; set; } = null!;
    }

    [Table("InventoryCheck", Schema = "inv")]
    public class InventoryCheck
    {
        [Key]
        public int InventoryCheckID { get; set; }

        public string UserId { get; set; } = null!;
        public DateTime CheckDate { get; set; }

        public ApplicationUser User { get; set; } = null!;
        public ICollection<InventoryCheckDetail> Details { get; set; } = new List<InventoryCheckDetail>();
    }

    [Table("InventoryCheckDetail", Schema = "inv")]
    public class InventoryCheckDetail
    {
        [Key]
        public int InventoryCheckDetailID { get; set; }

        public int InventoryCheckID { get; set; }
        public int ProductID { get; set; }
        public int? TintVariantID { get; set; }
        public int? ShadeID { get; set; }

        public decimal PhysicalStock { get; set; }

        [Required, MaxLength(10)]
        public string StockLevel { get; set; } = "Normal"; // Normal / Low / Critical

        [Required, MaxLength(10)]
        public string Unit { get; set; } = string.Empty; // Piece / Roll

        public InventoryCheck InventoryCheck { get; set; } = null!;
        public Product Product { get; set; } = null!;
        public TintVariant? TintVariant { get; set; }
        public Shade? Shade { get; set; }
    }
}
