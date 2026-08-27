using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Services.Interfaces
{
    public interface ISalesService
    {
        Task<Sale?> GetSale(int saleId);

        Task<List<Sale>> GetSales();

        Task<Sale> CreateSale(
            string userId,
            int customerId,
            int paymentModeId,
            string invoiceNumber,
            int? vehicleId,
            List<SaleLineRequest> items);
    }

    public class SaleLineRequest
    {
        public int ProductID { get; set; }
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
    }
}
