using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Services.Interfaces
{
    public interface ICashieringService
    {
        /// <summary>
        /// Merged cashier view over sales.Sales and sales.ServiceInvoice for
        /// the given day range (inclusive on both ends), with the drawer
        /// totals the index screen shows. All filters are optional except the
        /// dates.
        /// </summary>
        Task<CashieringViewModel> GetCashiering(
            DateOnly dateFrom,
            DateOnly dateTo,
            string? q = null,
            int? paymentModeId = null,
            string? userId = null,
            CashierSource? source = null);
    }
}
