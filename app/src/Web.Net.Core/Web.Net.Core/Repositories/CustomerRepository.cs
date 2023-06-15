using Web.Net.Core.Data;
using Web.Net.Core.Models;

namespace Web.Net.Core.Repositories;

public class CustomerRepository
{
    private ApplicationDbContext context;

    public CustomerRepository(ApplicationDbContext context)
    {
        this.context = context;
    }

    public List<Customers> GetCustomers()
    {
        var consulta = from Customers in this.context.Customers select Customers;
        return consulta.ToList();
    }

    public Customers FindCustomers(string id)
    {
        var consulta = from Customers in this.context.Customers where Customers.CustomerID == id select Customers;
        return consulta.FirstOrDefault();
    }

    public void UpdateCustomers(
                string CustomerID, string CompanyName, string ContactName, string ContactTitle, string Address,
                string City, string Region, string PostalCode, string Country, string Phone, string Fax)
    {
        Customers c = FindCustomers(CustomerID);
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
        this.context.SaveChanges();
    }

    public void DeleteCustomers(string id)
    {
        Customers c = FindCustomers(id);
        this.context.Remove(c);
        this.context.SaveChanges();
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

}

