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

        /// <summary>
        /// Reserve the next invoice number via dbo.GetNextInvoiceNumber. Also
        /// returns the InvoiceNoSeriesID the number was drawn from, since
        /// ServiceInvoice.InvoiceNoSeriesID is a required FK back to it.
        /// </summary>
        Task<(string InvoiceNumber, int InvoiceNoSeriesID)> GetNextInvoiceNumber(string userId);
    }
}