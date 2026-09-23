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

    /// <summary>One row of a stock count sheet: what the system holds, ready for a shelf figure.</summary>
    public class StockCountRow
    {
        public int ProductID { get; set; }
        public string ProductName { get; set; } = string.Empty;
        public string CategoryName { get; set; } = string.Empty;
        public decimal SystemStock { get; set; }
    }

    /// <summary>
    /// A counted line against stock-on-hand as it stands now. Positive
    /// variance means the shelf holds more than the system thought.
    /// </summary>
    public class StockVarianceRow
    {
        public int ProductID { get; set; }
        public string ProductName { get; set; } = string.Empty;
        public decimal PhysicalStock { get; set; }
        public decimal SystemStock { get; set; }
        public string Unit { get; set; } = "Piece";
        public string StockLevel { get; set; } = "Normal";

        public decimal Variance => PhysicalStock - SystemStock;
    }

    /// <summary>
    /// One product line of a document (job order, service invoice) whose
    /// completion moves stock. Not a mapped entity - inv.InventoryTransaction
    /// records only the movement itself, with no link back to what caused it.
    /// </summary>
    public record DocumentStockLine(int ProductID, decimal Quantity);

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
