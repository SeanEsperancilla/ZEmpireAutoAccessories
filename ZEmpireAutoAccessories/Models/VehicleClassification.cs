namespace ZEmpireAutoAccessories.Models
{
    public class VehicleClassification
    {
        public int VehicleClassificationID { get; set; }

        public string ClassificationName { get; set; } = string.Empty;

        public ICollection<Vehicle> Vehicles { get; set; } = new List<Vehicle>();

        public ICollection<Pricing> Pricings { get; set; } = new List<Pricing>();
    }
}
