using Layer.Entidad;
using Microsoft.ApplicationBlocks.Data;
using System.Configuration;
using System.Data;

namespace Layer.Datos
{
    public static class DA_Aplicacion2
    {
        static string cn = ConfigurationManager.ConnectionStrings["cn"].ConnectionString;

        public static DataTable CustomersDAL()
        {
            return SqlHelper.ExecuteDataTable(cn, "usp_customers");
        }

        public static DataTable OrdenesPorClienteDAL(EN_Aplicacion2 objE)
        {
            return SqlHelper.ExecuteDataTable(cn,"usp_ordenesporcliente", objE.CustomerId );
        }
        
    }
}
