using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Data
{
    /// <summary>
    /// Database-first context bound to the ZEmpire database (schemas:
    /// asp, cat, crm, inv, ops, sales, sec). ASP.NET Core Identity is mapped
    /// onto the existing asp.* tables. The database already exists; this
    /// context maps onto it and is not intended to drive migrations.
    /// </summary>
    public class ApplicationDbContext : IdentityDbContext<ApplicationUser, ApplicationRole, string>
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        // ----- crm -----
        public DbSet<Customer> Customers => Set<Customer>();
        public DbSet<Vehicle> Vehicles => Set<Vehicle>();
        public DbSet<VehicleClassification> VehicleClassifications => Set<VehicleClassification>();

        // ----- cat -----
        public DbSet<ProductCategory> ProductCategories => Set<ProductCategory>();
        public DbSet<Product> Products => Set<Product>();
        public DbSet<TintVariant> TintVariants => Set<TintVariant>();
        public DbSet<Shade> Shades => Set<Shade>();
        public DbSet<Panel> Panels => Set<Panel>();
        public DbSet<ServiceCategory> ServiceCategories => Set<ServiceCategory>();
        public DbSet<Service> Services => Set<Service>();
        public DbSet<JobType> JobTypes => Set<JobType>();
        public DbSet<Pricing> Pricings => Set<Pricing>();
        public DbSet<PriceHistory> PriceHistories => Set<PriceHistory>();

        // ----- inv -----
        public DbSet<InventoryTransaction> InventoryTransactions => Set<InventoryTransaction>();
        public DbSet<InventoryCheck> InventoryChecks => Set<InventoryCheck>();
        public DbSet<InventoryCheckDetail> InventoryCheckDetails => Set<InventoryCheckDetail>();

        // ----- ops -----
        public DbSet<JobOrder> JobOrders => Set<JobOrder>();
        public DbSet<JobOrderDetail> JobOrderDetails => Set<JobOrderDetail>();
        public DbSet<VehicleChecklist> VehicleChecklists => Set<VehicleChecklist>();
        public DbSet<VehicleChecklistDetail> VehicleChecklistDetails => Set<VehicleChecklistDetail>();

        // ----- sales -----
        public DbSet<PaymentMode> PaymentModes => Set<PaymentMode>();
        public DbSet<Sale> Sales => Set<Sale>();
        public DbSet<SaleDetail> SalesDetails => Set<SaleDetail>();
        public DbSet<ServiceInvoice> ServiceInvoices => Set<ServiceInvoice>();
        public DbSet<ServiceInvoiceDetail> ServiceInvoiceDetails => Set<ServiceInvoiceDetail>();
        public DbSet<Quotation> Quotations => Set<Quotation>();
        public DbSet<QuotationDetail> QuotationDetails => Set<QuotationDetail>();
        public DbSet<InvoiceNoSeries> InvoiceNoSeries => Set<InvoiceNoSeries>();
        public DbSet<Warranty> Warranties => Set<Warranty>();

        // ----- sec -----
        public DbSet<Employee> Employees => Set<Employee>();
        public DbSet<Module> Modules => Set<Module>();
        public DbSet<RolePermission> RolePermissions => Set<RolePermission>();

        // ----- dbo reporting views (keyless) -----
        public DbSet<VwStockOnHand> StockOnHand => Set<VwStockOnHand>();
        public DbSet<VwSalesSummary> SalesSummaries => Set<VwSalesSummary>();
        public DbSet<VwJobOrderSummary> JobOrderSummaries => Set<VwJobOrderSummary>();
        public DbSet<VwServiceInvoiceSummary> ServiceInvoiceSummaries => Set<VwServiceInvoiceSummary>();
        public DbSet<VwQuotationSummary> QuotationSummaries => Set<VwQuotationSummary>();

        protected override void OnModelCreating(ModelBuilder b)
        {
            base.OnModelCreating(b); // configures the Identity entities

            // ---------- Identity tables live in the asp schema ----------
            b.Entity<ApplicationUser>(e =>
            {
                e.ToTable("AspNetUsers", "asp");
                e.Property(x => x.FullName).HasMaxLength(150).IsRequired();
                e.Property(x => x.CreatedAt).HasColumnType("datetime2(0)");
            });
            b.Entity<ApplicationRole>().ToTable("AspNetRoles", "asp");
            b.Entity<IdentityUserClaim<string>>().ToTable("AspNetUserClaims", "asp");
            b.Entity<IdentityUserRole<string>>().ToTable("AspNetUserRoles", "asp");
            b.Entity<IdentityUserLogin<string>>().ToTable("AspNetUserLogins", "asp");
            b.Entity<IdentityRoleClaim<string>>().ToTable("AspNetRoleClaims", "asp");
            b.Entity<IdentityUserToken<string>>().ToTable("AspNetUserTokens", "asp");

            // ---------- crm ----------
            b.Entity<Vehicle>(e =>
            {
                e.HasOne(x => x.Customer).WithMany(c => c.Vehicles)
                    .HasForeignKey(x => x.CustomerID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.VehicleClassification).WithMany(vc => vc.Vehicles)
                    .HasForeignKey(x => x.VehicleClassificationID).OnDelete(DeleteBehavior.Restrict);
            });

            // ---------- cat ----------
            b.Entity<Product>().HasOne(x => x.Category).WithMany(c => c.Products)
                .HasForeignKey(x => x.CategoryID).OnDelete(DeleteBehavior.Restrict);

            b.Entity<TintVariant>().HasOne(x => x.Product).WithMany(p => p.TintVariants)
                .HasForeignKey(x => x.ProductID).OnDelete(DeleteBehavior.Restrict);

            b.Entity<Shade>().HasOne(x => x.TintVariant).WithMany(v => v.Shades)
                .HasForeignKey(x => x.TintVariantID).OnDelete(DeleteBehavior.Restrict);

            b.Entity<Service>().HasOne(x => x.ServiceCategory).WithMany(c => c.Services)
                .HasForeignKey(x => x.ServiceCategoryID).OnDelete(DeleteBehavior.Restrict);

            b.Entity<Pricing>(e =>
            {
                e.HasOne(x => x.Product).WithMany(p => p.Pricings)
                    .HasForeignKey(x => x.ProductID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.TintVariant).WithMany()
                    .HasForeignKey(x => x.TintVariantID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.VehicleClassification).WithMany()
                    .HasForeignKey(x => x.VehicleClassificationID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.Panel).WithMany()
                    .HasForeignKey(x => x.PanelID).OnDelete(DeleteBehavior.Restrict);
            });

            b.Entity<PriceHistory>(e =>
            {
                e.HasOne(x => x.Pricing).WithMany(p => p.PriceHistories)
                    .HasForeignKey(x => x.PricingID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.User).WithMany()
                    .HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Restrict);
            });

            // ---------- inv ----------
            b.Entity<InventoryTransaction>(e =>
            {
                e.HasOne(x => x.Product).WithMany()
                    .HasForeignKey(x => x.ProductID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.User).WithMany()
                    .HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Restrict);
            });

            b.Entity<InventoryCheck>().HasOne(x => x.User).WithMany()
                .HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Restrict);

            b.Entity<InventoryCheckDetail>(e =>
            {
                e.HasOne(x => x.InventoryCheck).WithMany(c => c.Details)
                    .HasForeignKey(x => x.InventoryCheckID).OnDelete(DeleteBehavior.Cascade);
                e.HasOne(x => x.Product).WithMany()
                    .HasForeignKey(x => x.ProductID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.TintVariant).WithMany()
                    .HasForeignKey(x => x.TintVariantID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.Shade).WithMany()
                    .HasForeignKey(x => x.ShadeID).OnDelete(DeleteBehavior.Restrict);
            });

            // ---------- ops ----------
            b.Entity<JobOrder>(e =>
            {
                e.HasOne(x => x.Customer).WithMany()
                    .HasForeignKey(x => x.CustomerID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.Vehicle).WithMany()
                    .HasForeignKey(x => x.VehicleID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.User).WithMany()
                    .HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.JobType).WithMany()
                    .HasForeignKey(x => x.JobTypeID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.AssignedEmployee).WithMany()
                    .HasForeignKey(x => x.AssignedEmployeeID).OnDelete(DeleteBehavior.Restrict);
                // one quotation -> at most one job order (filtered unique index in DB)
                e.HasOne(x => x.Quotation).WithOne(q => q.JobOrder)
                    .HasForeignKey<JobOrder>(x => x.QuotationID).OnDelete(DeleteBehavior.Restrict);
            });

            b.Entity<JobOrderDetail>(e =>
            {
                e.HasOne(x => x.JobOrder).WithMany(j => j.Details)
                    .HasForeignKey(x => x.JobOrderID).OnDelete(DeleteBehavior.Cascade);
                e.HasOne(x => x.Product).WithMany().HasForeignKey(x => x.ProductID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.Service).WithMany().HasForeignKey(x => x.ServiceID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.TintVariant).WithMany().HasForeignKey(x => x.TintVariantID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.Shade).WithMany().HasForeignKey(x => x.ShadeID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.Panel).WithMany().HasForeignKey(x => x.PanelID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.Pricing).WithMany().HasForeignKey(x => x.PricingID).OnDelete(DeleteBehavior.Restrict);
                e.Property(x => x.SubTotal).HasComputedColumnSql("[Quantity]*[UnitPrice]", stored: true);
            });

            b.Entity<VehicleChecklist>(e =>
            {
                e.HasOne(x => x.JobOrder).WithMany()
                    .HasForeignKey(x => x.JobOrderID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.User).WithMany()
                    .HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Restrict);
            });

            b.Entity<VehicleChecklistDetail>(e =>
            {
                e.HasOne(x => x.Checklist).WithMany(c => c.Details)
                    .HasForeignKey(x => x.ChecklistID).OnDelete(DeleteBehavior.Cascade);
                e.HasOne(x => x.Panel).WithMany()
                    .HasForeignKey(x => x.PanelID).OnDelete(DeleteBehavior.Restrict);
            });

            // ---------- sales ----------
            b.Entity<Sale>(e =>
            {
                e.HasOne(x => x.Customer).WithMany().HasForeignKey(x => x.CustomerID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.Vehicle).WithMany().HasForeignKey(x => x.VehicleID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.PaymentMode).WithMany().HasForeignKey(x => x.PaymentModeID).OnDelete(DeleteBehavior.Restrict);
            });

            b.Entity<SaleDetail>(e =>
            {
                e.HasOne(x => x.Sale).WithMany(s => s.SaleDetails)
                    .HasForeignKey(x => x.SalesID).OnDelete(DeleteBehavior.Cascade);
                e.HasOne(x => x.Product).WithMany()
                    .HasForeignKey(x => x.ProductID).OnDelete(DeleteBehavior.Restrict);
                e.Property(x => x.SubTotal).HasComputedColumnSql("[Quantity]*[UnitPrice]", stored: true);
            });

            b.Entity<ServiceInvoice>(e =>
            {
                e.HasOne(x => x.InvoiceNoSeries).WithMany().HasForeignKey(x => x.InvoiceNoSeriesID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.JobOrder).WithMany().HasForeignKey(x => x.JobOrderID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.Customer).WithMany().HasForeignKey(x => x.CustomerID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.Vehicle).WithMany().HasForeignKey(x => x.VehicleID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.PaymentMode).WithMany().HasForeignKey(x => x.PaymentModeID).OnDelete(DeleteBehavior.Restrict);
            });

            b.Entity<ServiceInvoiceDetail>(e =>
            {
                e.HasOne(x => x.ServiceInvoice).WithMany(i => i.Details)
                    .HasForeignKey(x => x.ServiceInvoiceID).OnDelete(DeleteBehavior.Cascade);
                e.HasOne(x => x.Product).WithMany().HasForeignKey(x => x.ProductID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.Service).WithMany().HasForeignKey(x => x.ServiceID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.TintVariant).WithMany().HasForeignKey(x => x.TintVariantID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.Shade).WithMany().HasForeignKey(x => x.ShadeID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.Panel).WithMany().HasForeignKey(x => x.PanelID).OnDelete(DeleteBehavior.Restrict);
                e.Property(x => x.SubTotal).HasComputedColumnSql("[Quantity]*[UnitPrice]-[DiscountAmount]", stored: true);
            });

            b.Entity<Quotation>(e =>
            {
                e.HasOne(x => x.Customer).WithMany().HasForeignKey(x => x.CustomerID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.Vehicle).WithMany().HasForeignKey(x => x.VehicleID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.User).WithMany().HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.JobType).WithMany().HasForeignKey(x => x.JobTypeID).OnDelete(DeleteBehavior.Restrict);
            });

            b.Entity<QuotationDetail>(e =>
            {
                e.HasOne(x => x.Quotation).WithMany(q => q.Details)
                    .HasForeignKey(x => x.QuotationID).OnDelete(DeleteBehavior.Cascade);
                e.HasOne(x => x.Product).WithMany().HasForeignKey(x => x.ProductID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.Service).WithMany().HasForeignKey(x => x.ServiceID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.TintVariant).WithMany().HasForeignKey(x => x.TintVariantID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.Shade).WithMany().HasForeignKey(x => x.ShadeID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.Panel).WithMany().HasForeignKey(x => x.PanelID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.Pricing).WithMany().HasForeignKey(x => x.PricingID).OnDelete(DeleteBehavior.Restrict);
                e.Property(x => x.SubTotal).HasComputedColumnSql("[Quantity]*[UnitPrice]", stored: true);
            });

            b.Entity<InvoiceNoSeries>().HasOne(x => x.User).WithMany()
                .HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Restrict);

            b.Entity<Warranty>(e =>
            {
                e.HasOne(x => x.SalesDetail).WithMany().HasForeignKey(x => x.SalesDetailID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.ServiceInvoiceDetail).WithMany().HasForeignKey(x => x.ServiceInvoiceDetailID).OnDelete(DeleteBehavior.Restrict);
                e.HasOne(x => x.JobOrder).WithMany().HasForeignKey(x => x.JobOrderID).OnDelete(DeleteBehavior.Restrict);
            });

            // ---------- sec ----------
            b.Entity<Employee>(e =>
            {
                e.HasOne(x => x.User).WithMany()
                    .HasForeignKey(x => x.UserId).OnDelete(DeleteBehavior.Cascade);
                e.Property(x => x.FullName).HasComputedColumnSql(
                    "ltrim(rtrim(concat([FirstName]," +
                    "case when [MiddleName] IS NOT NULL AND ltrim(rtrim([MiddleName]))<>N'' then N' '+[MiddleName] else N'' end," +
                    "N' ',[LastName]," +
                    "case when [Suffix] IS NOT NULL AND ltrim(rtrim([Suffix]))<>N'' then N' '+[Suffix] else N'' end)))",
                    stored: true);
            });

            b.Entity<RolePermission>(e =>
            {
                e.HasKey(x => new { x.RoleId, x.ModuleID });
                e.HasOne(x => x.Role).WithMany()
                    .HasForeignKey(x => x.RoleId).OnDelete(DeleteBehavior.Cascade);
                e.HasOne(x => x.Module).WithMany(m => m.RolePermissions)
                    .HasForeignKey(x => x.ModuleID).OnDelete(DeleteBehavior.Restrict);
            });

            // ---------- dbo reporting views (keyless) ----------
            b.Entity<VwStockOnHand>().HasNoKey().ToView("vw_StockOnHand", "dbo");
            b.Entity<VwSalesSummary>().HasNoKey().ToView("vw_SalesSummary", "dbo");
            b.Entity<VwJobOrderSummary>().HasNoKey().ToView("vw_JobOrderSummary", "dbo");
            b.Entity<VwServiceInvoiceSummary>().HasNoKey().ToView("vw_ServiceInvoiceSummary", "dbo");
            b.Entity<VwQuotationSummary>().HasNoKey().ToView("vw_QuotationSummary", "dbo");

            // ---------- money/quantity: match SQL decimal(12,2) ----------
            foreach (var property in b.Model.GetEntityTypes()
                         .SelectMany(t => t.GetProperties())
                         .Where(p => p.ClrType == typeof(decimal) || p.ClrType == typeof(decimal?)))
            {
                property.SetPrecision(12);
                property.SetScale(2);
            }
        }
    }
}
