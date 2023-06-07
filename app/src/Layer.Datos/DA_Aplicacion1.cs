using Layer.Entidad;
using Microsoft.ApplicationBlocks.Data;
using System.Configuration;
using System.Data;

namespace Layer.Datos
{
    public static class DA_Aplicacion1
    {
        static string cn =
         ConfigurationManager.ConnectionStrings["cn"].ConnectionString;

        public static DataTable ListarArticuloDAL()
        {
            return SqlHelper.ExecuteDataTable(cn, "usp_Articulos");
        }

        public static DataTable BusquedaArticulosDAL(EN_Aplicacion1 objE)
        {
            return SqlHelper.ExecuteDataTable(cn, "usp_BusquedaArticulos",objE.Articulo);
        }

        public static string CodigoFacturaDAL()
        {
            return SqlHelper.ExecuteScalar(cn, "usp_GenerarCodigoFactura").ToString(); 
        }

        public static int GabrarCabeceraFacturaDAL(EN_Aplicacion1 objE)
        {
            return SqlHelper.ExecuteNonQuery(cn, "usp_gabrarCabecera",
                objE.Fac_num, objE.Fac_fec, objE.Cli_cod ,objE.Fac_igv , objE.Total );
        }

        public static int GrabarDetalleDAL(EN_Aplicacion1 objE)
        {
            return SqlHelper.ExecuteNonQuery(cn, "usp_grabarDetalle",
              objE.Fac_num, objE.Art_cod, objE.Art_pre, objE.Art_cant   );
        }

        public static DataTable ListarClientesDAL()
        {
            return SqlHelper.ExecuteDataTable(cn, "usp_ListarClientes");
        }
    }
}
