using Microsoft.EntityFrameworkCore;
using ZEmpireAutoAccessories.Models;

namespace ZEmpireAutoAccessories.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(
        DbContextOptions<ApplicationDbContext> options)
        : base(options)
        {
        }

        public DbSet<User> Users => Set<User>();
        public DbSet<Customer> Customers => Set<Customer>();
        public DbSet<VehicleClassification> VehicleClassifications => Set<VehicleClassification>();
        public DbSet<Vehicle> Vehicles => Set<Vehicle>();
        public DbSet<Product> Products => Set<Product>();
        public DbSet<Pricing> Pricings => Set<Pricing>();
        public DbSet<PriceHistory> PriceHistories => Set<PriceHistory>();
        public DbSet<Sale> Sales => Set<Sale>();
        public DbSet<SaleDetail> SaleDetails => Set<SaleDetail>();
        public DbSet<InventoryTransaction> InventoryTransactions => Set<InventoryTransaction>();

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Product>()
                .Property(p => p.CostPrice)
                .HasPrecision(18, 2);

            modelBuilder.Entity<Product>()
                .Property(p => p.CurrentStock)
                .HasPrecision(18, 2);

            modelBuilder.Entity<Product>()
                .Property(p => p.LowStockThreshold)
                .HasPrecision(18, 2);

            modelBuilder.Entity<Pricing>()
                .Property(p => p.BasePrice)
                .HasPrecision(18, 2);

            modelBuilder.Entity<Pricing>()
                .Property(p => p.MarkupPercentage)
                .HasPrecision(5, 2);

            modelBuilder.Entity<Pricing>()
                .Property(p => p.SellingPrice)
                .HasPrecision(18, 2);

            modelBuilder.Entity<PriceHistory>()
                .Property(p => p.OldPrice)
                .HasPrecision(18, 2);

            modelBuilder.Entity<PriceHistory>()
                .Property(p => p.NewPrice)
                .HasPrecision(18, 2);

            modelBuilder.Entity<Sale>()
                .Property(s => s.TotalAmount)
                .HasPrecision(18, 2);

            modelBuilder.Entity<SaleDetail>()
                .Property(sd => sd.Quantity)
                .HasPrecision(18, 2);

            modelBuilder.Entity<SaleDetail>()
                .Property(sd => sd.SellingPrice)
                .HasPrecision(18, 2);

            modelBuilder.Entity<SaleDetail>()
                .Property(sd => sd.Subtotal)
                .HasPrecision(18, 2);

            modelBuilder.Entity<InventoryTransaction>()
                .Property(it => it.Quantity)
                .HasPrecision(18, 2);

            // Customer -> Vehicle
            modelBuilder.Entity<Vehicle>()
                .HasOne(v => v.Customer)
                .WithMany(c => c.Vehicles)
                .HasForeignKey(v => v.CustomerID)
                .OnDelete(DeleteBehavior.Restrict);

            // VehicleClassification -> Vehicle
            modelBuilder.Entity<Vehicle>()
                .HasOne(v => v.VehicleClassification)
                .WithMany(vc => vc.Vehicles)
                .HasForeignKey(v => v.VehicleClassificationID)
                .OnDelete(DeleteBehavior.Restrict);

            // VehicleClassification -> Pricing
            modelBuilder.Entity<Pricing>()
                .HasOne(p => p.VehicleClassification)
                .WithMany(vc => vc.Pricings)
                .HasForeignKey(p => p.VehicleClassificationID)
                .OnDelete(DeleteBehavior.Restrict);

            // Product -> Pricing
            modelBuilder.Entity<Pricing>()
                .HasOne(p => p.Product)
                .WithMany(product => product.Pricings)
                .HasForeignKey(p => p.ProductID)
                .OnDelete(DeleteBehavior.Restrict);

            // Pricing -> PriceHistory
            modelBuilder.Entity<PriceHistory>()
                .HasOne(ph => ph.Pricing)
                .WithMany(p => p.PriceHistories)
                .HasForeignKey(ph => ph.PricingID)
                .OnDelete(DeleteBehavior.Restrict);

            // User -> PriceHistory
            modelBuilder.Entity<PriceHistory>()
                .HasOne(ph => ph.User)
                .WithMany(u => u.PriceHistories)
                .HasForeignKey(ph => ph.UserID)
                .OnDelete(DeleteBehavior.Restrict);

            // Customer -> Sale
            modelBuilder.Entity<Sale>()
                .HasOne(s => s.Customer)
                .WithMany(c => c.Sales)
                .HasForeignKey(s => s.CustomerID)
                .OnDelete(DeleteBehavior.Restrict);

            // User -> Sale
            modelBuilder.Entity<Sale>()
                .HasOne(s => s.User)
                .WithMany(u => u.Sales)
                .HasForeignKey(s => s.UserID)
                .OnDelete(DeleteBehavior.Restrict);

            // Sale -> SaleDetail
            modelBuilder.Entity<SaleDetail>()
                .HasOne(sd => sd.Sale)
                .WithMany(s => s.SaleDetails)
                .HasForeignKey(sd => sd.SaleID)
                .OnDelete(DeleteBehavior.Cascade);

            // Pricing -> SaleDetail
            modelBuilder.Entity<SaleDetail>()
                .HasOne(sd => sd.Pricing)
                .WithMany(p => p.SaleDetails)
                .HasForeignKey(sd => sd.PricingID)
                .OnDelete(DeleteBehavior.Restrict);

            // Product -> InventoryTransaction
            modelBuilder.Entity<InventoryTransaction>()
                .HasOne(it => it.Product)
                .WithMany(p => p.InventoryTransactions)
                .HasForeignKey(it => it.ProductID)
                .OnDelete(DeleteBehavior.Restrict);

            // User -> InventoryTransaction
            modelBuilder.Entity<InventoryTransaction>()
                .HasOne(it => it.User)
                .WithMany(u => u.InventoryTransactions)
                .HasForeignKey(it => it.UserID)
                .OnDelete(DeleteBehavior.Restrict);

            // Username should be unique
            modelBuilder.Entity<User>()
                .HasIndex(u => u.UserName)
                .IsUnique();

            // Prevent duplicate pricing for the same
            // Product + Vehicle Classification combination.
            modelBuilder.Entity<Pricing>()
                .HasIndex(p => new
                {
                    p.ProductID,
                    p.VehicleClassificationID
                })
                .IsUnique();
        }
    }
}