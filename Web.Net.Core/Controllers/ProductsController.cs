using Microsoft.AspNetCore.Mvc;
using Web.Net.Core.Models;
using Web.Net.Core.Repositories;

namespace Web.Net.Core.Controllers;

public class ProductsController : Controller
{
    public NorthwindRepository repo;

    public ProductsController(NorthwindRepository repo)
    {
        this.repo = repo;
    }

    public IActionResult ListadoCustomers()
    {
        List<Customers> list = this.repo.GetCustomers();
        return View(list);
    }

    public IActionResult ListadoProductos(int id)
    {
        List<Products> productos = this.repo.GetProducts(id);
        ViewData["ProductID"] = id;
        return View(productos);
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

    public IActionResult NuevoProducts(int idfab)
    {
        ViewData["ProductID"] = idfab;
        return View();
    }


    [HttpPost]
    public IActionResult NuevoProducto(int idproducto, string nombre, int precio)//, int idfabricante)
    {
        this.repo.CreateProducto(idproducto, nombre, precio);//, idfabricante);
        return RedirectToAction("ListadoProductos", "Customer", new { id = idproducto });
    }
}
