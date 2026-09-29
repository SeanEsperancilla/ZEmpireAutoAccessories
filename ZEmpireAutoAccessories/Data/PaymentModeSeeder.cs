using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Data
{
    /// <summary>
    /// Makes sure every payment mode the shop offers exists as a row in
    /// sales.PaymentMode, so the dropdowns can offer it. Runs at startup
    /// beside IdentitySeeder.
    ///
    /// It only ever inserts. A mode already in the table is left exactly as it
    /// is, and one that is no longer offered - GCash, Cheque - is never
    /// removed or renamed: sales.Sales and sales.ServiceInvoice point at these
    /// rows, so deleting one would orphan every transaction that used it and
    /// rewrite history besides. Retiring a mode is a matter of leaving it off
    /// the offered list, which keeps it out of the forms while the old
    /// transactions keep reading correctly.
    /// </summary>
    public static class PaymentModeSeeder
    {
        public static async Task SeedAsync(IServiceProvider services, ILogger logger)
        {
            using var scope = services.CreateScope();
            var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();

            var rows = await context.PaymentModes.ToListAsync();

            // Renames first. "Card" becoming "Credit Cards" is the same mode
            // under a better name, so the row is renamed and keeps its id -
            // every sale and invoice already on it follows automatically.
            // Inserting the new name instead would leave two rows meaning one
            // thing, and the old one could not be deleted because those
            // transactions point at it.
            var renamed = new List<string>();

            foreach (var row in rows)
            {
                var to = PaymentModes.RenamedTo(row.PaymentModeName);
                if (to == null)
                    continue;

                // Unless something already carries the new name, in which case
                // renaming would make the pair this is trying to avoid. Leave
                // it; the old name simply stops being offered.
                if (rows.Any(other => other != row &&
                        string.Equals(other.PaymentModeName, to, StringComparison.OrdinalIgnoreCase)))
                    continue;

                renamed.Add($"{row.PaymentModeName} -> {to}");
                row.PaymentModeName = to;
            }

            if (renamed.Count > 0)
            {
                await context.SaveChangesAsync();
                logger.LogInformation("Renamed payment mode(s): {Renamed}.", string.Join(", ", renamed));
            }

            var known = new HashSet<string>(
                rows.Select(r => r.PaymentModeName), StringComparer.OrdinalIgnoreCase);

            var missing = PaymentModes.OfferedNames
                .Where(name => !known.Contains(name))
                .ToList();

            if (missing.Count == 0)
                return;

            foreach (var name in missing)
                context.PaymentModes.Add(new PaymentMode { PaymentModeName = name });

            await context.SaveChangesAsync();

            logger.LogInformation(
                "Added payment mode(s): {Modes}.", string.Join(", ", missing));
        }
    }
}
