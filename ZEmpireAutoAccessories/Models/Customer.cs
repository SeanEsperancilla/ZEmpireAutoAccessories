namespace ZEmpireAutoAccessories.Models
{
    public class Customer
    {
        public int CustomerID { get; set; }

        public string FullName { get; set; } = string.Empty;

        public string? ContactNumber { get; set; }

        public ICollection<Vehicle> Vehicles { get; set; } = new List<Vehicle>();

        public ICollection<Sale> Sales { get; set; } = new List<Sale>();
    }
}
