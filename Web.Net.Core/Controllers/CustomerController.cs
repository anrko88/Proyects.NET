using Microsoft.AspNetCore.Mvc;
using Web.Net.Core.Models;
using Web.Net.Core.Repositories;

namespace Web.Net.Core.Controllers;

public class CustomerController : Controller
{
    public NorthwindRepository repo;

    public CustomerController(NorthwindRepository repo)
    {
        this.repo = repo;
    }

    public IActionResult ListadoCustomers()
    {
        List<Customers> list = this.repo.GetCustomers();
        return View(list);
    }

    public IActionResult NewCustomers()//string id)
    {
       // ViewData["CustomerID"] = id;
        return View();
    }


    [HttpPost]
    public IActionResult NewCustomers(
                string CustomerID, string CompanyName, string ContactName, string ContactTitle,
                string Address, string City, string Country, string Phone)
    {
        this.repo.CreateCustomers(CustomerID, CompanyName, ContactName,ContactTitle, Address, City, Country, Phone);
        return RedirectToAction("ListadoCustomers", "Customers", new { id = CustomerID });
    }

    public IActionResult EditarProducto(int id)
    {
        Products prod = this.repo.FindProducts(id);
        return View(prod);
    }

    [HttpPost]
    public IActionResult EditarProducts(int idproducto, string nombre, int precio)//, int idfabricante)
    {
        this.repo.EditProducts(idproducto, nombre, precio);//, idfabricante);

        return RedirectToAction("ListadoProductos", "Customer", new { id = idproducto });
    }

    public IActionResult EliminarProducto(int id)
    {
        Products prod = this.repo.FindProducts(id);
        return View(prod);
    }

    [HttpPost]
    public IActionResult EliminarProducts(int idproducto, int idfabricante)
    {
        this.repo.DeleteProducts(idproducto);
        return RedirectToAction("ListadoProductos", "Customer", new { id = idfabricante });
    }

  
}
