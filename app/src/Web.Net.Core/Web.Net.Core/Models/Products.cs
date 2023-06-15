using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Web.Net.Core.Models;

[Table("products")]
public class Products
{
    [Key]
    [Column("ProductID")]
    public int ProductID { get; set; }

    [Column("ProductName")]
    public string ProductName { get; set; }

    [Column("SupplierID")]
    public int SupplierID { get; set; }

    [Column("CategoryID")]
    public int CategoryID { get; set; }

    [Column("QuantityPerUnit")]
    public string QuantityPerUnit { get; set; }

    [Column("UnitPrice")]
    public double UnitPrice { get; set; }

    [Column("UnitsInStock")]
    public double UnitsInStock { get; set; }

    [Column("UnitsOnOrder")]
    public double UnitsOnOrder { get; set; }

    [Column("ReorderLevel")]
    public double ReorderLevel { get; set; }

    [Column("Discontinued")]
    public byte Discontinued { get; set; }
}
