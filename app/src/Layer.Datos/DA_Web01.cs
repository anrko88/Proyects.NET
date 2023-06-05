using Layer.Entidad;
using Microsoft.ApplicationBlocks.Data;
using System.Configuration;
using System.Data;

namespace Layer.Datos
{
    public static class DA_Web01
    {
        static string cn =
           ConfigurationManager.ConnectionStrings["cn"].ConnectionString;

        public static DataTable Lista_01DAL()
        {
            return SqlHelper.ExecuteDataTable(cn, "Usp_Listado01");
        }
        
        public static DataTable Lista_02DAL(EN_Web01 objE)
        {
            return SqlHelper.ExecuteDataTable(cn, "Usp_Listado02", objE.Employeeid);
        }

        public static DataTable Lista_DetalledeOrdenesDAL(EN_Web01 objE)
        {
            return SqlHelper.ExecuteDataTable(cn, "usp_DetalledeOrdenes", objE.OrderID );
        }
        
    }
}
