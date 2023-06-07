using System;
using System.Collections.Generic;
using System.Text;
using Layer.Datos;
using Layer.Entidad;
using System.Data;

namespace Layer.Negocio
{
    public static class NE_Aplicacion1
    {
        public static DataTable ListarArticuloNEG()
        {
            return DA_Aplicacion1.ListarArticuloDAL();
        }

        public static DataTable BusquedaArticulosNEG(EN_Aplicacion1 objE)
        {
            return DA_Aplicacion1.BusquedaArticulosDAL(objE);
        }

        public static string CodigoFacturaNEG()
        {
            return DA_Aplicacion1.CodigoFacturaDAL();
        }

        public static int GabrarCabeceraFacturaNEG(EN_Aplicacion1 objE)
        {
            return DA_Aplicacion1.GabrarCabeceraFacturaDAL (objE);
        }

        public static int GrabarDetalleNEG(EN_Aplicacion1 objE)
        {
            return DA_Aplicacion1.GrabarDetalleDAL(objE);
        }

        public static DataTable ListarClientesNEG()
        {
            return DA_Aplicacion1.ListarClientesDAL();
        }

    }
}
