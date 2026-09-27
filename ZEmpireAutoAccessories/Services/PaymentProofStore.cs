using ZEmpireAutoAccessories.Models;
using ZEmpireAutoAccessories.Services.Interfaces;

namespace ZEmpireAutoAccessories.Services
{
    /// <summary>
    /// Proof of payment for a bank transfer or a QRPH payment: the screenshot
    /// or receipt the customer sends, kept against the transaction it paid.
    ///
    /// The files live in a folder, not in the database. There is nowhere in
    /// the schema to put them - sales.Sales holds a total and nothing else,
    /// and there is no attachment table - and adding one is off the table. A
    /// folder needs no migration, and the link is the file's name: the
    /// transaction it belongs to and nothing else, so nothing the customer or
    /// the cashier types can steer where it is written.
    ///
    /// The folder sits outside wwwroot deliberately. These are bank receipts
    /// with names, reference numbers and account details on them; served as
    /// static files they would be readable by anyone who guessed the URL.
    /// Cashiering streams them back through an action instead, behind the
    /// same permission as the rest of the screen.
    /// </summary>
    public class PaymentProofStore : IPaymentProofStore
    {
        // What a phone screenshot or a downloaded receipt actually is. Anything
        // else is refused rather than stored and worried about later.
        private static readonly Dictionary<string, string> AllowedTypes =
            new(StringComparer.OrdinalIgnoreCase)
            {
                [".jpg"] = "image/jpeg",
                [".jpeg"] = "image/jpeg",
                [".png"] = "image/png",
                [".webp"] = "image/webp",
                [".pdf"] = "application/pdf"
            };

        private readonly string _folder;
        private readonly long _maxBytes;

        public PaymentProofStore(IConfiguration config, IWebHostEnvironment environment)
        {
            var configured = config["Payments:ProofFolder"];

            _folder = string.IsNullOrWhiteSpace(configured)
                ? Path.Combine(environment.ContentRootPath, "App_Data", "payment-proofs")
                : Path.IsPathRooted(configured)
                    ? configured
                    : Path.Combine(environment.ContentRootPath, configured);

            _maxBytes = config.GetValue<long?>("Payments:MaxProofBytes") ?? 5 * 1024 * 1024;
        }

        public bool Exists(CashierSource source, int sourceId) =>
            FindExisting(source, sourceId) != null;

        public HashSet<(CashierSource Source, int SourceId)> ExistingFor(
            IEnumerable<(CashierSource Source, int SourceId)> transactions)
        {
            var found = new HashSet<(CashierSource, int)>();

            if (!Directory.Exists(_folder))
                return found;

            // One listing, then a lookup per row - a folder probe per
            // transaction would be a few hundred stat calls on a busy day.
            var names = new HashSet<string>(
                Directory.EnumerateFiles(_folder).Select(Path.GetFileName)!,
                StringComparer.OrdinalIgnoreCase);

            foreach (var (source, sourceId) in transactions)
            {
                var stem = StemFor(source, sourceId);
                if (AllowedTypes.Keys.Any(ext => names.Contains(stem + ext)))
                    found.Add((source, sourceId));
            }

            return found;
        }

        public async Task<string?> Save(CashierSource source, int sourceId, IFormFile file)
        {
            if (file == null || file.Length == 0)
                return "Choose a file to attach.";

            if (file.Length > _maxBytes)
                return $"That file is {file.Length / 1024m / 1024m:N1} MB. " +
                       $"The limit is {_maxBytes / 1024m / 1024m:N0} MB - a screenshot rather than a photo of the screen usually does it.";

            var extension = Path.GetExtension(file.FileName);
            if (string.IsNullOrEmpty(extension) || !AllowedTypes.TryGetValue(extension, out var contentType))
                return "Attach a screenshot or a PDF receipt (JPG, PNG, WEBP or PDF).";

            // The extension is a claim, not a fact. Read the first bytes and
            // check they are the file they say they are, so a renamed
            // something-else is refused at the door rather than being handed
            // back to a browser later with an image content type on it.
            await using (var probe = file.OpenReadStream())
            {
                var header = new byte[12];
                var read = await probe.ReadAsync(header);
                if (!LooksLike(contentType, header.AsSpan(0, read)))
                    return "That file is not the kind it claims to be. Attach a screenshot or a PDF receipt.";
            }

            Directory.CreateDirectory(_folder);

            // Replacing a proof means the old one goes: the other extensions
            // for this transaction are cleared first, so a PNG replacing a JPG
            // cannot leave two proofs behind with only one of them visible.
            foreach (var stale in ExistingPaths(source, sourceId))
                File.Delete(stale);

            var path = Path.Combine(_folder, StemFor(source, sourceId) + extension.ToLowerInvariant());

            await using var destination = File.Create(path);
            await using var upload = file.OpenReadStream();
            await upload.CopyToAsync(destination);

            return null;
        }

        public (Stream Content, string ContentType, string FileName)? Open(
            CashierSource source, int sourceId)
        {
            var path = FindExisting(source, sourceId);
            if (path == null)
                return null;

            var extension = Path.GetExtension(path);

            // The type comes from the allow-list keyed by the extension this
            // store wrote, never from anything an upload carried.
            if (!AllowedTypes.TryGetValue(extension, out var contentType))
                return null;

            return (File.OpenRead(path), contentType, Path.GetFileName(path));
        }

        /// <summary>
        /// The file name for a transaction, built only from what kind of
        /// document it is and its id - never from anything typed or uploaded,
        /// so there is nothing in it to escape the folder with.
        /// </summary>
        private static string StemFor(CashierSource source, int sourceId) =>
            (source == CashierSource.Sale ? "sale-" : "invoice-") + sourceId.ToString();

        private IEnumerable<string> ExistingPaths(CashierSource source, int sourceId)
        {
            if (!Directory.Exists(_folder))
                yield break;

            var stem = StemFor(source, sourceId);

            foreach (var extension in AllowedTypes.Keys)
            {
                var path = Path.Combine(_folder, stem + extension);
                if (File.Exists(path))
                    yield return path;
            }
        }

        private string? FindExisting(CashierSource source, int sourceId) =>
            ExistingPaths(source, sourceId).FirstOrDefault();

        /// <summary>
        /// Whether the opening bytes match the format the extension promised.
        /// </summary>
        private static bool LooksLike(string contentType, ReadOnlySpan<byte> header) => contentType switch
        {
            "image/jpeg" => header.Length >= 3
                && header[0] == 0xFF && header[1] == 0xD8 && header[2] == 0xFF,

            "image/png" => header.Length >= 8
                && header[0] == 0x89 && header[1] == 0x50 && header[2] == 0x4E && header[3] == 0x47
                && header[4] == 0x0D && header[5] == 0x0A && header[6] == 0x1A && header[7] == 0x0A,

            // RIFF....WEBP
            "image/webp" => header.Length >= 12
                && header[0] == (byte)'R' && header[1] == (byte)'I' && header[2] == (byte)'F' && header[3] == (byte)'F'
                && header[8] == (byte)'W' && header[9] == (byte)'E' && header[10] == (byte)'B' && header[11] == (byte)'P',

            "application/pdf" => header.Length >= 5
                && header[0] == (byte)'%' && header[1] == (byte)'P' && header[2] == (byte)'D'
                && header[3] == (byte)'F' && header[4] == (byte)'-',

            _ => false
        };
    }
}
