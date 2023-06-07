using Capa.Datos;
using Capa.Entidad;
using System.Data;

namespace Capa.Negocio
{
    public  class ne_anrko
    {

        public static DataTable LetraCustomersNEG(en_anrko  objE)
        {
            return da_anrko.LetraCustomersDAT(objE);
        }
        public static DataTable FechaNEG(en_anrko objE)
        {
            return da_anrko.FechaDAT (objE);
        }

        public static DataTable DEtalleVentaNEG(en_anrko objE)
        {
            return da_anrko.DEtalleVEntaDAT (objE);
        }
       
    }
}
