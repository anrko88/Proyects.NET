using Capa.Entidad;
using Microsoft.ApplicationBlocks.Data;
using System.Data;

namespace Capa.Datos
{
    public static class BD_Aplicacion2
    {
        private static string cn = 
            "server=localhost;integrated security=SSPI;database=Northwind";

        public static DataTable BusquedaProductosDAL(EN_Aplicacion2 obj)
        {
            return SqlHelper.ExecuteDataTable(cn, "Usp_BusquedaProductosS9", obj.Datos);
        }
        public static int GrabarProductosDAL(EN_Aplicacion2 obj)
        {
            return SqlHelper.ExecuteNonQuery (cn, "Usp_GrabarProductos",
                obj.ProductID, obj.Producto, obj.Cantidad);
        }

        public static DataTable ListaProductosVendidosDAL()
        {
            return SqlHelper.ExecuteDataTable(cn, "Usp_ListaProductosVendidos");
        }
    }
}
