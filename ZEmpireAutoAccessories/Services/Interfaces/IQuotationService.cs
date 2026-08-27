using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Services.Interfaces
{
    public interface IQuotationService
    {
        Task<Quotation?> GetQuotation(int quotationId);

        Task<List<Quotation>> GetQuotations();

        /// <summary>
        /// Converts an accepted quotation into a job order by calling
        /// dbo.ConvertQuotationToJobOrder. Returns the new JobOrderID.
        /// </summary>
        Task<int> ConvertToJobOrder(int quotationId, string userId, string jobOrderNumber);

        /// <summary>Reserve the next invoice number via dbo.GetNextInvoiceNumber.</summary>
        Task<string> GetNextInvoiceNumber(string userId);
    }
}
