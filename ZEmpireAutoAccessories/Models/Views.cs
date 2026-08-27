namespace ZEmpireAutoAccessories.Models
{
    // ===== keyless entities mapped to the dbo reporting views =====
    // Configured with HasNoKey().ToView(...) in ApplicationDbContext.

    public class VwStockOnHand
    {
        public int ProductID { get; set; }
        public string ProductName { get; set; } = string.Empty;
        public decimal? StockOnHand { get; set; }
    }

    public class VwSalesSummary
    {
        public int SalesID { get; set; }
        public string InvoiceNumber { get; set; } = string.Empty;
        public DateTime SalesDate { get; set; }
        public string CustomerName { get; set; } = string.Empty;
        public string PaymentModeName { get; set; } = string.Empty;
        public string SoldBy { get; set; } = string.Empty;
        public string? UserName { get; set; }
        public decimal RecordedTotal { get; set; }
        public decimal ComputedTotal { get; set; }
    }

    public class VwJobOrderSummary
    {
        public int JobOrderID { get; set; }
        public string JobOrderNumber { get; set; } = string.Empty;
        public DateTime JobOrderDate { get; set; }
        public string Status { get; set; } = string.Empty;
        public string? JobTypeName { get; set; }
        public string CustomerName { get; set; } = string.Empty;
        public string? PlateNumber { get; set; }
        public string HandledBy { get; set; } = string.Empty;
        public string? UserName { get; set; }
        public string? Technician { get; set; }
        public int LineCount { get; set; }
        public decimal TotalAmount { get; set; }
    }

    public class VwServiceInvoiceSummary
    {
        public int ServiceInvoiceID { get; set; }
        public string InvoiceNumber { get; set; } = string.Empty;
        public DateTime InvoiceDate { get; set; }
        public string Status { get; set; } = string.Empty;
        public int? JobOrderID { get; set; }
        public string? JobOrderNumber { get; set; }
        public string CustomerName { get; set; } = string.Empty;
        public string PaymentModeName { get; set; } = string.Empty;
        public string ProcessedBy { get; set; } = string.Empty;
        public string? UserName { get; set; }
        public decimal SubTotal { get; set; }
        public decimal DiscountAmount { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal TotalAmount { get; set; }
        public decimal AmountPaid { get; set; }
        public decimal ChangeAmount { get; set; }
        public int LineCount { get; set; }
        public decimal ComputedLineTotal { get; set; }
    }

    public class VwQuotationSummary
    {
        public int QuotationID { get; set; }
        public string QuotationNumber { get; set; } = string.Empty;
        public DateTime QuotationDate { get; set; }
        public DateOnly? ValidUntil { get; set; }
        public string Status { get; set; } = string.Empty;
        public string? JobTypeName { get; set; }
        public string CustomerName { get; set; } = string.Empty;
        public string? PlateNumber { get; set; }
        public string PreparedBy { get; set; } = string.Empty;
        public string? UserName { get; set; }
        public int? ConvertedJobOrderID { get; set; }
        public string? ConvertedJobOrderNumber { get; set; }
        public decimal SubTotal { get; set; }
        public decimal DiscountAmount { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal TotalAmount { get; set; }
        public int LineCount { get; set; }
        public decimal ComputedLineTotal { get; set; }
    }
}
