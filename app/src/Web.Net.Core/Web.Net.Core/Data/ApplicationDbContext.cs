using Microsoft.EntityFrameworkCore;
using Web.Net.Core.Models;

namespace Web.Net.Core.Data;

public class ApplicationDbContext:DbContext
{
    public ApplicationDbContext()
    {
    }

    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }

    public DbSet<Customers> Customers { get; set; }
    public DbSet<Products> Products { get; set; }
}
