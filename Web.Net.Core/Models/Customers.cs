﻿using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Web.Net.Core.Models;

[Table("customers")]
public class Customers
{
    [Key]
    [Column("CustomerID")]
    public string CustomerID { get; set; }

    [Column("CompanyName")]
    public string CompanyName { get; set; }

    [Column("ContactName")]
    public string ContactName { get; set; }

    [Column("ContactTitle")]
    public string ContactTitle { get; set; }

    [Column("Address")]
    public string Address { get; set; }

    [Column("City")]
    public string City { get; set; }

    [Column("Country")]
    public string Country { get; set; }

    [Column("Phone")]
    public string Phone { get; set; }

    [Column("Fax")]
    public string? Fax { get; set; }
}
