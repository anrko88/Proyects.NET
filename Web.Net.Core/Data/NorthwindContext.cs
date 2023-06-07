using Microsoft.EntityFrameworkCore;
using Web.Net.Core.Models;

namespace Web.Net.Core.Data;

public class NorthwindContext:DbContext
{
    public NorthwindContext(DbContextOptions<NorthwindContext> options) : base(options) { }

    public DbSet<Customers> Customers { get; set; }
    public DbSet<Products> Products { get; set; }
}
