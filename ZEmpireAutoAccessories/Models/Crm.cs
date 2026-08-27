using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ZEmpireAutoAccessories.Models
{
    // ===== schema: crm =====

    [Table("Customer", Schema = "crm")]
    public class Customer
    {
        [Key]
        public int CustomerID { get; set; }

        [Required, MaxLength(150)]
        public string FullName { get; set; } = string.Empty;

        [MaxLength(30)]
        public string? ContactNumber { get; set; }

        public DateTime CreatedAt { get; set; }

        public ICollection<Vehicle> Vehicles { get; set; } = new List<Vehicle>();
    }

    [Table("VehicleClassification", Schema = "crm")]
    public class VehicleClassification
    {
        [Key]
        public int VehicleClassificationID { get; set; }

        [Required, MaxLength(80)]
        public string ClassificationName { get; set; } = string.Empty;

        public ICollection<Vehicle> Vehicles { get; set; } = new List<Vehicle>();
    }

    [Table("Vehicle", Schema = "crm")]
    public class Vehicle
    {
        [Key]
        public int VehicleID { get; set; }

        public int CustomerID { get; set; }
        public int VehicleClassificationID { get; set; }

        [MaxLength(20)]
        public string? PlateNumber { get; set; }

        [MaxLength(60)]
        public string? Brand { get; set; }

        [MaxLength(60)]
        public string? Model { get; set; }

        public short? ManufacturingYear { get; set; }

        public Customer Customer { get; set; } = null!;
        public VehicleClassification VehicleClassification { get; set; } = null!;
    }
}
