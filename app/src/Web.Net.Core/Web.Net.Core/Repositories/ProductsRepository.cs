using System.Diagnostics.Metrics;
using System.Net;
using Web.Net.Core.Data;
using Web.Net.Core.Models;

namespace Web.Net.Core.Repositories;

public class ProductsRepository
{
    private ApplicationDbContext context;

    public ProductsRepository(ApplicationDbContext context)
    {
        this.context = context;
    }

    public List<Customers> GetCustomers()
    {
        var consulta = from Customers in this.context.Customers select Customers;
        return consulta.ToList();
    }

    public void CreateCustomers(
                string CustomerID, string CompanyName, string ContactName, string ContactTitle, string Address,
                string City, string Region, string PostalCode, string Country, string Phone, string Fax)
    {
        Customers c = new Customers();
        c.CustomerID = CustomerID;
        c.CompanyName = CompanyName;
        c.ContactName = ContactName;
        c.ContactTitle = ContactTitle;
        c.Address = Address;
        c.City = City;
        c.Region = Region;
        c.PostalCode = PostalCode;
        c.Country = Country;
        c.Phone = Phone;
        c.Fax = Fax;
        this.context.Customers.Add(c);
        this.context.SaveChanges();
    }

    public List<Products> GetProducts(int id)
    {
        var consulta = from datos in this.context.Products where datos.ProductID == id select datos;

        return consulta.ToList();
    }

    public Products FindProducts(int id)
    {
        var consulta = from datos in this.context.Products where datos.ProductID == id select datos;

        return consulta.FirstOrDefault();
    }

    public void EditProducts(int ProductID, string ProductName, int UnitPrice)
    {
        Products p = FindProducts(ProductID);
        p.ProductName = ProductName;
        p.UnitPrice = UnitPrice;

        this.context.SaveChanges();
    }

    public void DeleteProducts(int id)
    {
        Products pdelete = FindProducts(id);
        this.context.Remove(pdelete);
        this.context.SaveChanges();
    }

    public void CreateProducto(int ProductID, string ProductName, int UnitPrice)//, int idfabricante)
    {
        Products p = new Products();
        p.ProductID = ProductID;
        // p.IdFabricante = idfabricante;
        p.ProductName = ProductName;
        p.UnitPrice = UnitPrice;
        this.context.Products.Add(p);
        this.context.SaveChanges();
    }
}
