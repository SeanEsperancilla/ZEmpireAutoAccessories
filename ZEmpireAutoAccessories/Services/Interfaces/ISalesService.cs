using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Services.Interfaces
{
    public interface ISalesService
    {
        Task<Sale?> GetSale(int saleId);

        Task<List<Sale>> GetSales();

        Task<Sale> CreateSale(
            int userId,
            int customerId,
            string modeOfPayment,
            List<SaleDetailRequest> items);
    }
}