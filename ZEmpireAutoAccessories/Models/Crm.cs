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

        [Required(ErrorMessage = "Full name is required.")]
        [MaxLength(150, ErrorMessage = "Full name can't be longer than 150 characters.")]
        [Display(Name = "Full name")]
        public string FullName { get; set; } = string.Empty;

        [MaxLength(30, ErrorMessage = "Contact number can't be longer than 30 characters.")]
        [Display(Name = "Contact number")]
        [Phone(ErrorMessage = "Enter a valid contact number.")]
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

        [Display(Name = "Customer")]
        [Range(1, int.MaxValue, ErrorMessage = "Please select a customer.")]
        public int CustomerID { get; set; }

        [Display(Name = "Classification")]
        [Range(1, int.MaxValue, ErrorMessage = "Please select a classification.")]
        public int VehicleClassificationID { get; set; }

        [MaxLength(20, ErrorMessage = "Plate number can't be longer than 20 characters.")]
        [Display(Name = "Plate number")]
        public string? PlateNumber { get; set; }

        [MaxLength(60, ErrorMessage = "Brand can't be longer than 60 characters.")]
        [Display(Name = "Brand")]
        public string? Brand { get; set; }

        [MaxLength(60, ErrorMessage = "Model can't be longer than 60 characters.")]
        [Display(Name = "Model")]
        public string? Model { get; set; }

        [Display(Name = "Year")]
        [Range(1900, 2100, ErrorMessage = "Enter a valid year (1900–2100).")]
        public short? ManufacturingYear { get; set; }

        public Customer Customer { get; set; } = null!;
        public VehicleClassification VehicleClassification { get; set; } = null!;
    }
}
