using Layer.Datos;
using Layer.Entidad;
using System.Data;

namespace Layer.Negocio
{
    public class NE_WebF
    {
        public static DataTable Lista_01NE()
        {
            return DA_WebF.Lista_01DA();
        }

        public static DataTable Lista_02NE(EN_WebF objE)
        {
            return DA_WebF.Lista_02DA(objE);
        }

        public static int Lista_03NE(EN_WebF objE)
        {
            return DA_WebF.Lista_03DA(objE);
         }

    }
}

