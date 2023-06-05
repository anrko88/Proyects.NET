using Capa.Datos;
using Capa.Entidad;
using System.Data;

namespace Capa.Negocio
{
    public static class NE_Aplicacion2
    {
        public static DataTable BusquedaProductosBL(EN_Aplicacion2 obj)
        {
            return BD_Aplicacion2.BusquedaProductosDAL(obj);
        }

        public static int GrabarProductosBL(EN_Aplicacion2 obj)
        {
            return BD_Aplicacion2.GrabarProductosDAL(obj);
        }

        public static DataTable ListaProductosVendidosBL()
        {
            return BD_Aplicacion2.ListaProductosVendidosDAL();
        }

    }
}
