using Microsoft.ApplicationBlocks.Data;
using System.Data;
using Capa.Entidad;

namespace Capa.Datos
{
    public static class da_anrko
    {
        private static string cn = "server=localhost;integrated security=SSPI;database=northwind";


        public static DataTable LetraCustomersDAT(en_anrko objE)
        {
            return SqlHelper.ExecuteDataTable(cn, "Usp_LetraCustomers", objE.Letra );
        }
        public static DataTable FechaDAT(en_anrko objE)
        {
            return SqlHelper.ExecuteDataTable(cn, "USP_fecha", objE.Letra,objE.Fecha1,objE.Fecha2 );
        }

        public static DataTable DEtalleVEntaDAT(en_anrko objE)
        {
            return SqlHelper.ExecuteDataTable(cn, "USP_DetalleVenta", objE.Orderid );
        }
      

    }
}
