using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ZEmpireAutoAccessories.Models
{
    // ===== schema: sales =====

    [Table("PaymentMode", Schema = "sales")]
    public class PaymentMode
    {
        [Key]
        public int PaymentModeID { get; set; }

        [Required, MaxLength(50)]
        public string PaymentModeName { get; set; } = string.Empty;
    }

    [Table("Sales", Schema = "sales")]
    public class Sale
    {
        [Key]
        public int SalesID { get; set; }

        [Required, MaxLength(30)]
        public string InvoiceNumber { get; set; } = string.Empty;

        public int CustomerID { get; set; }
        public int? VehicleID { get; set; }
        public string UserId { get; set; } = null!;
        public int PaymentModeID { get; set; }

        public DateTime SalesDate { get; set; }
        public decimal TotalAmount { get; set; }

        public Customer Customer { get; set; } = null!;
        public Vehicle? Vehicle { get; set; }
        public ApplicationUser User { get; set; } = null!;
        public PaymentMode PaymentMode { get; set; } = null!;
        public ICollection<SaleDetail> SaleDetails { get; set; } = new List<SaleDetail>();
    }

    [Table("SalesDetail", Schema = "sales")]
    public class SaleDetail
    {
        [Key]
        public int SalesDetailID { get; set; }

        public int SalesID { get; set; }
        public int ProductID { get; set; }
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }

        // Persisted computed column (Quantity * UnitPrice)
        public decimal SubTotal { get; private set; }

        public Sale Sale { get; set; } = null!;
        public Product Product { get; set; } = null!;
    }

    [Table("ServiceInvoice", Schema = "sales")]
    public class ServiceInvoice
    {
        [Key]
        public int ServiceInvoiceID { get; set; }

        [Required, MaxLength(50)]
        public string InvoiceNumber { get; set; } = string.Empty;

        public int InvoiceNoSeriesID { get; set; }
        public int? JobOrderID { get; set; }
        public int CustomerID { get; set; }
        public int? VehicleID { get; set; }
        public string UserId { get; set; } = null!;
        public int PaymentModeID { get; set; }

        public DateTime InvoiceDate { get; set; }
        public decimal SubTotal { get; set; }
        public decimal DiscountAmount { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal TotalAmount { get; set; }
        public decimal AmountPaid { get; set; }
        public decimal ChangeAmount { get; set; }

        [MaxLength(500)]
        public string? Remarks { get; set; }

        [Required, MaxLength(20)]
        public string Status { get; set; } = "Paid";

        public DateTime CreatedAt { get; set; }

        public InvoiceNoSeries InvoiceNoSeries { get; set; } = null!;
        public JobOrder? JobOrder { get; set; }
        public Customer Customer { get; set; } = null!;
        public Vehicle? Vehicle { get; set; }
        public ApplicationUser User { get; set; } = null!;
        public PaymentMode PaymentMode { get; set; } = null!;
        public ICollection<ServiceInvoiceDetail> Details { get; set; } = new List<ServiceInvoiceDetail>();
    }

    [Table("ServiceInvoiceDetail", Schema = "sales")]
    public class ServiceInvoiceDetail
    {
        [Key]
        public int ServiceInvoiceDetailID { get; set; }

        public int ServiceInvoiceID { get; set; }
        public int? ProductID { get; set; }
        public int? ServiceID { get; set; }
        public int? TintVariantID { get; set; }
        public int? ShadeID { get; set; }
        public int? PanelID { get; set; }

        [Required, MaxLength(250)]
        public string Description { get; set; } = string.Empty;

        public decimal Quantity { get; set; }

        [Required, MaxLength(20)]
        public string Unit { get; set; } = "Unit";

        public decimal UnitPrice { get; set; }
        public decimal DiscountAmount { get; set; }

        // Persisted computed column (Quantity * UnitPrice - DiscountAmount)
        public decimal SubTotal { get; private set; }

        public ServiceInvoice ServiceInvoice { get; set; } = null!;
        public Product? Product { get; set; }
        public Service? Service { get; set; }
        public TintVariant? TintVariant { get; set; }
        public Shade? Shade { get; set; }
        public Panel? Panel { get; set; }
    }

    [Table("Quotation", Schema = "sales")]
    public class Quotation
    {
        [Key]
        public int QuotationID { get; set; }

        [Required, MaxLength(30)]
        public string QuotationNumber { get; set; } = string.Empty;

        public int CustomerID { get; set; }
        public int VehicleID { get; set; }
        public string UserId { get; set; } = null!;
        public int? JobTypeID { get; set; }

        public DateTime QuotationDate { get; set; }
        public DateOnly? ValidUntil { get; set; }

        public decimal SubTotal { get; set; }
        public decimal DiscountAmount { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal TotalAmount { get; set; }

        [MaxLength(500)]
        public string? Remarks { get; set; }

        [Required, MaxLength(20)]
        public string Status { get; set; } = "Draft";

        public DateTime CreatedAt { get; set; }

        public Customer Customer { get; set; } = null!;
        public Vehicle Vehicle { get; set; } = null!;
        public ApplicationUser User { get; set; } = null!;
        public JobType? JobType { get; set; }
        public ICollection<QuotationDetail> Details { get; set; } = new List<QuotationDetail>();

        // Set once the quote is converted (JobOrder.QuotationID points back here)
        public JobOrder? JobOrder { get; set; }
    }

    [Table("QuotationDetail", Schema = "sales")]
    public class QuotationDetail
    {
        [Key]
        public int QuotationDetailID { get; set; }

        public int QuotationID { get; set; }
        public int? ProductID { get; set; }
        public int? ServiceID { get; set; }
        public int? TintVariantID { get; set; }
        public int? ShadeID { get; set; }
        public int? PanelID { get; set; }
        public int? PricingID { get; set; }

        [MaxLength(250)]
        public string? Description { get; set; }

        public int Quantity { get; set; }

        [Required, MaxLength(20)]
        public string Unit { get; set; } = "Unit";

        public decimal UnitPrice { get; set; }

        // Persisted computed column (Quantity * UnitPrice)
        public decimal SubTotal { get; private set; }

        public Quotation Quotation { get; set; } = null!;
        public Product? Product { get; set; }
        public Service? Service { get; set; }
        public TintVariant? TintVariant { get; set; }
        public Shade? Shade { get; set; }
        public Panel? Panel { get; set; }
        public Pricing? Pricing { get; set; }
    }

    [Table("InvoiceNoSeries", Schema = "sales")]
    public class InvoiceNoSeries
    {
        [Key]
        public int InvoiceNoSeriesID { get; set; }

        public string UserId { get; set; } = null!;
        public int SeriesYear { get; set; }

        [Required, MaxLength(20)]
        public string Prefix { get; set; } = "INV";

        public int CurrentNumber { get; set; }
        public int NumberLength { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedAt { get; set; }

        public ApplicationUser User { get; set; } = null!;
    }

    [Table("Warranty", Schema = "sales")]
    public class Warranty
    {
        [Key]
        public int WarrantyID { get; set; }

        public int? SalesDetailID { get; set; }
        public int? ServiceInvoiceDetailID { get; set; }
        public int? JobOrderID { get; set; }

        public DateOnly? WarrantyStartDate { get; set; }
        public DateOnly? WarrantyEndDate { get; set; }

        [MaxLength(500)]
        public string? WarrantyTerms { get; set; }

        [MaxLength(100)]
        public string? WarrantyStatus { get; set; }

        [MaxLength(150)]
        public string? Remarks { get; set; }

        [MaxLength(150)]
        public string? CreatedBy { get; set; }

        public SaleDetail? SalesDetail { get; set; }
        public ServiceInvoiceDetail? ServiceInvoiceDetail { get; set; }
        public JobOrder? JobOrder { get; set; }
    }
}
