using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using Web.Net.Core.Data;
using Web.Net.Core.Models;
using Web.Net.Core.Repositories;

namespace Web.Net.Core.Controllers;

public class CustomersController : Controller
{
    public CustomerRepository customerRepository;
    public string sListadoCustomers = "ListadoCustomers";
    public string sCustomer = "Customer";

    private readonly int _RegistrosPorPagina = 10;

    private ApplicationDbContext _DbContext;
    private List<Customers> _Customers;
    private PaginadorGenerico<Customers> _PaginadorCustomers;

    #region  Paginacion

    // GET: Customers
    public IActionResult ListadoCustomersPag(string buscar, int pagina = 1)
    {
        int _TotalRegistros = 0;
        int _TotalPaginas = 0;
        
        // FILTRO DE BÚSQUEDA
        using (_DbContext = new ApplicationDbContext())
        {
            // Recuperamos el 'DbSet' completo
            //_Customers = _DbContext.Customers.ToList();
            _Customers = this.customerRepository.GetCustomers().ToList();

            // Filtramos el resultado por el 'texto de búqueda'
            if (!string.IsNullOrEmpty(buscar))
            {
                foreach (var item in buscar.Split(new char[] { ' ' },
                         StringSplitOptions.RemoveEmptyEntries))
                {
                    _Customers = _Customers.Where(
                           x => x.CustomerID.Contains(item) ||
                                x.CompanyName.Contains(item) ||
                                x.ContactName.Contains(item) ||
                                x.ContactTitle.Contains(item) ||
                                x.City.Contains(item) ||
                               // x.Region.Contains(item) ||
                                x.Country.Contains(item) ||
                                x.Phone.Contains(item)) //||
                               // x.Fax.Contains(item)) 
                                .ToList();
                }
            }
        }

        // SISTEMA DE PAGINACIÓN
        using (_DbContext = new ApplicationDbContext())
        {
            // Número total de registros de la tabla Customers
            _TotalRegistros = _Customers.Count();
            // Obtenemos la 'página de registros' de la tabla Customers
            _Customers = _Customers.OrderBy(x => x.CustomerID)
                                             .Skip((pagina - 1) * _RegistrosPorPagina)
                                             .Take(_RegistrosPorPagina)
                                             .ToList();
            // Número total de páginas de la tabla Customers
            _TotalPaginas = (int)Math.Ceiling((double)_TotalRegistros / _RegistrosPorPagina);

            // Instanciamos la 'Clase de paginación' y asignamos los nuevos valores
            _PaginadorCustomers = new PaginadorGenerico<Customers>()
            {
                RegistrosPorPagina = _RegistrosPorPagina,
                TotalRegistros = _TotalRegistros,
                TotalPaginas = _TotalPaginas,
                PaginaActual = pagina,
                BusquedaActual = buscar,
                Resultado = _Customers
            };
        }

        // Enviamos a la Vista la 'Clase de paginación'
        return View(_PaginadorCustomers);
    }
    #endregion

    public CustomersController( CustomerRepository customerRepository)
    {
        this.customerRepository = customerRepository;
    }

    public IActionResult ListadoCustomers()
    {
        List<Customers> list = this.customerRepository.GetCustomers();
        return View(list);
    }

    public IActionResult NewCustomers()
    {     
        return View();
    }

    [HttpPost]
    public IActionResult NewCustomers(
                string CustomerID, string CompanyName, string ContactName, string ContactTitle, string Address,
                string City, string region, string PostalCode, string Country, string Phone, string Fax)
    {
        this.customerRepository.CreateCustomers(CustomerID, CompanyName, ContactName,ContactTitle, Address, City, region, PostalCode,Country, Phone, Fax);
        return RedirectToAction(sListadoCustomers, sCustomer, new { id = CustomerID });
    }

    public IActionResult UpdateCustomers(string id)
    {
        Customers c = this.customerRepository.FindCustomers(id);
        return View(c);
    }
   
    [HttpPost]
    public IActionResult UpdateCustomers(
                string CustomerID, string CompanyName, string ContactName, string ContactTitle, string Address,
                string City, string region, string PostalCode, string Country, string Phone, string Fax)
    {
        this.customerRepository.UpdateCustomers(CustomerID, CompanyName, ContactName, ContactTitle, Address, City, region, PostalCode, Country, Phone, Fax);        
        return RedirectToAction(sListadoCustomers, sCustomer, new { id = CustomerID });
    }
 
    public IActionResult DeleteCustomers(string id)
    {
        Customers c = this.customerRepository.FindCustomers(id);
        return View(c);
    }

    [HttpPost]
    public IActionResult DeleteCustomers(string id,string id2)
    {
        this.customerRepository.DeleteCustomers(id);
        return RedirectToAction(sListadoCustomers, sCustomer, new { id = id });
    }

  
}
