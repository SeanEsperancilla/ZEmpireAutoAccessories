using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Services.Interfaces
{
    /// <summary>
    /// Where the receipt for an online payment is kept. See PaymentProofStore
    /// for why it is a folder rather than a table.
    /// </summary>
    public interface IPaymentProofStore
    {
        /// <summary>Whether a proof has been attached to this transaction.</summary>
        bool Exists(CashierSource source, int sourceId);

        /// <summary>
        /// Which of these transactions already have a proof. One directory
        /// listing rather than a file probe per row.
        /// </summary>
        HashSet<(CashierSource Source, int SourceId)> ExistingFor(
            IEnumerable<(CashierSource Source, int SourceId)> transactions);

        /// <summary>
        /// Stores <paramref name="file"/> as the proof for this transaction,
        /// replacing any proof already attached to it. Returns null on
        /// success, or the reason the file was refused.
        /// </summary>
        Task<string?> Save(CashierSource source, int sourceId, IFormFile file);

        /// <summary>
        /// The stored proof, ready to stream, or null if there is none.
        /// </summary>
        (Stream Content, string ContentType, string FileName)? Open(
            CashierSource source, int sourceId);
    }
}
