using Capa.Entidad;
using Microsoft.ApplicationBlocks.Data;
using System.Data;

namespace Capa.Datos
{
    public static class BD_Aplicacion1
    {
        private static string cn = "server=localhost;integrated security=SSPI;database=Northwind";

        public static DataTable BusquedaProductoProLetraDAL(EN_Aplicacion1 objE)
        {
            return SqlHelper.ExecuteDataTable(cn, "usp_BusProductosLetraS9", objE.Letras);
        }

        public static DataTable FotoDeCategoriaDAL(EN_Aplicacion1 objE)
        {
            return SqlHelper.ExecuteDataTable(cn, "Usp_FotoCategoriaPorProductoS9", objE.CategoryID );
        }

        public static DataTable OrdenesPorProductoDAL(EN_Aplicacion1 objE)
        {
            return SqlHelper.ExecuteDataTable(cn, "Usp_OrdenesPorProductoSem9", objE.ProductID );
        }

        public static DataTable FotoDeEmpleadoDAL(EN_Aplicacion1 objE)
        {
            return SqlHelper.ExecuteDataTable(cn, "Usp_EmpleadosPorOrdenS9", objE.OrderID );
        }


    }
}
