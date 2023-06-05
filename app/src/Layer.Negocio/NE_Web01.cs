using Layer.Datos;
using Layer.Entidad;
using System.Data;

namespace Layer.Negocio
{
    public static class NE_Web01
    {
        public static DataTable Lista_01NEG()
        {
            return DA_Web01.Lista_01DAL();
        }

        public static DataTable Lista_02NEG(EN_Web01 objE)
        {
            return DA_Web01.Lista_02DAL(objE);
        }
        public static DataTable Lista_DetalledeOrdenesDAL(EN_Web01 objE)
        {
            return DA_Web01.Lista_DetalledeOrdenesDAL(objE);
        }
    }
}
