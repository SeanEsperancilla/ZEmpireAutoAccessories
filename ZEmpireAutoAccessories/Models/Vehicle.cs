namespace ZEmpireAutoAccessories.Models
{
    public class Vehicle
    {
        public int VehicleID { get; set; }

        public int CustomerID { get; set; }

        public int VehicleClassificationID { get; set; }

        public string Brand { get; set; } = string.Empty;

        public string Model { get; set; } = string.Empty;

        public int YearOfManufacture { get; set; }

        public Customer Customer { get; set; } = null!;

        public VehicleClassification VehicleClassification { get; set; } = null!;
    }
}
