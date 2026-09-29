namespace ZEmpireAutoAccessories.Models
{
    /// <summary>
    /// The ways this shop takes money, and which of them arrive from somewhere
    /// other than the counter.
    ///
    /// Cash and a card terminal are settled in front of you - the money is in
    /// the drawer or the terminal has printed a slip. A bank transfer or a
    /// QRPH payment is a claim until someone checks it: the customer says they
    /// sent it, and the only thing tying the transaction to the money is the
    /// screenshot or receipt they show. Those modes are marked here so
    /// Cashiering can ask for that proof and flag the rows still missing one.
    ///
    /// Both lists can be replaced from appsettings.json, so a new wallet or
    /// rail is a settings change rather than a code change - and never a
    /// schema change. sales.PaymentMode holds the rows; PaymentModeSeeder puts
    /// any missing name there at startup.
    /// </summary>
    public static class PaymentModes
    {
        /// <summary>
        /// The modes the shop offers. Order is the order they are shown in.
        /// </summary>
        private static readonly string[] DefaultOffered =
        {
            "Cash",
            "Card",
            "Bank Transfer",
            "QRPH"
        };

        /// <summary>
        /// Modes where the money moves before anyone at the shop sees it, so a
        /// receipt or screenshot is what proves it arrived. GCash is here
        /// because the existing data uses it; QRPH is the rail that replaced
        /// it for most counters.
        /// </summary>
        private static readonly string[] DefaultRequiringProof =
        {
            "Bank Transfer",
            "QRPH",
            "GCash"
        };

        /// <summary>
        /// The modes where a customer can hand over more than the price, so
        /// there is a tendered amount to type and change to give back.
        ///
        /// Cash is the only one. A transfer or a wallet sends the figure it
        /// was asked for, and a card terminal is charged the total - none of
        /// them has a bigger note. Held as the exception rather than the rule
        /// because the rule is nearly everything: a mode nobody has listed
        /// here settles exactly, which is the safer way round. Locking a
        /// tender that should have been typed is an annoyance; recording
        /// change that was never given is a wrong figure in the drawer.
        /// </summary>
        private static readonly string[] DefaultGivingChange = { "Cash" };

        /// <summary>
        /// Old name -> the name it should read as now. Applied to the row
        /// itself at startup, so the mode keeps its id and every transaction
        /// on it keeps pointing at it.
        /// </summary>
        private static readonly Dictionary<string, string> DefaultRenames =
            new(StringComparer.OrdinalIgnoreCase)
            {
                ["Bank Transfer"] = "Bank Transfers",
                ["Card"] = "Credit Cards"
            };

        private static string[] Offered = DefaultOffered;

        private static Dictionary<string, string> Renames =
            new(DefaultRenames, StringComparer.OrdinalIgnoreCase);

        private static HashSet<string> RequiringProof =
            new(DefaultRequiringProof, StringComparer.OrdinalIgnoreCase);

        private static HashSet<string> GivingChange =
            new(DefaultGivingChange, StringComparer.OrdinalIgnoreCase);

        /// <summary>
        /// Points both lists at configuration. An absent or empty setting
        /// keeps the built-in list, so a missing section can never leave the
        /// shop with no way to take money.
        /// </summary>
        public static void Configure(
            IEnumerable<string>? offered,
            IEnumerable<string>? requiringProof,
            IDictionary<string, string>? renamed = null,
            IEnumerable<string>? givingChange = null)
        {
            var cleanChange = Clean(givingChange);
            if (cleanChange.Count > 0)
                GivingChange = new HashSet<string>(cleanChange, StringComparer.OrdinalIgnoreCase);

            var cleanOffered = Clean(offered);
            if (cleanOffered.Count > 0)
                Offered = cleanOffered.ToArray();

            var cleanProof = Clean(requiringProof);
            if (cleanProof.Count > 0)
                RequiringProof = new HashSet<string>(cleanProof, StringComparer.OrdinalIgnoreCase);

            var cleanRenames = renamed?
                .Where(kv => !string.IsNullOrWhiteSpace(kv.Key) && !string.IsNullOrWhiteSpace(kv.Value))
                .ToDictionary(kv => kv.Key.Trim(), kv => kv.Value.Trim(), StringComparer.OrdinalIgnoreCase);

            if (cleanRenames is { Count: > 0 })
                Renames = cleanRenames;
        }

        /// <summary>
        /// What this mode should be called now, or null if it keeps its name.
        /// </summary>
        public static string? RenamedTo(string? paymentModeName) =>
            paymentModeName != null && Renames.TryGetValue(paymentModeName.Trim(), out var renamed)
            && !string.Equals(renamed, paymentModeName.Trim(), StringComparison.OrdinalIgnoreCase)
                ? renamed
                : null;

        private static List<string> Clean(IEnumerable<string>? names) =>
            names?.Where(n => !string.IsNullOrWhiteSpace(n))
                  .Select(n => n.Trim())
                  .ToList()
            ?? new List<string>();

        /// <summary>The modes this shop offers, in display order.</summary>
        public static IReadOnlyList<string> OfferedNames => Offered;

        /// <summary>
        /// Whether the money moved before anyone at the shop saw it - a
        /// transfer or a wallet rather than cash or a terminal.
        ///
        /// Two things follow from it, for the same reason. A receipt is what
        /// shows the money arrived, because nobody watched it arrive. And the
        /// amount is exactly the total, because there is no handing over of a
        /// bigger note: the customer sends what they were asked for, and there
        /// is no change to give back.
        /// </summary>
        public static bool IsOnline(string? paymentModeName) =>
            paymentModeName != null && RequiringProof.Contains(paymentModeName.Trim());

        /// <summary>
        /// Whether a payment on this mode needs a receipt attached to it.
        /// </summary>
        public static bool NeedsProof(string? paymentModeName) => IsOnline(paymentModeName);

        /// <summary>
        /// Whether the tendered amount is the total and nothing else, so there
        /// is no change and nothing to type.
        ///
        /// Not the same question as whether a receipt is needed, though it was
        /// written that way to begin with. A card terminal is charged the
        /// exact total - no change - but it is settled in front of you and
        /// prints its own slip, so there is nothing to chase.
        /// </summary>
        public static bool SettlesExactly(string? paymentModeName) =>
            !(paymentModeName != null && GivingChange.Contains(paymentModeName.Trim()));

        /// <summary>
        /// What a form should offer, from the rows the table actually holds:
        /// the offered modes in the order set above, and nothing else -
        /// except the mode a document is already on, which stays on the list
        /// so opening an old GCash sale and saving it does not silently move
        /// it to another mode.
        ///
        /// A mode is retired by leaving it off the list, never by deleting
        /// its row: every transaction that used it still points there.
        /// </summary>
        public static List<PaymentMode> ForSelection(IEnumerable<PaymentMode> all, int? keepId = null)
        {
            var order = Offered
                .Select((name, index) => (name, index))
                .ToDictionary(x => x.name, x => x.index, StringComparer.OrdinalIgnoreCase);

            return all
                .Where(mode => order.ContainsKey(mode.PaymentModeName)
                               || (keepId.HasValue && mode.PaymentModeID == keepId.Value))
                // Retired-but-kept modes sort last, after everything offered.
                .OrderBy(mode => order.TryGetValue(mode.PaymentModeName, out var index)
                    ? index
                    : int.MaxValue)
                .ThenBy(mode => mode.PaymentModeName)
                .ToList();
        }
    }
}
