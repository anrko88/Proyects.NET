using Layer.Datos;
using Layer.Entidad;
using System.Data;

namespace Layer.Negocio
{
    public static class NE_Aplicacion2
    {
        public static DataTable CustomersNEG()
        {
            return DA_Aplicacion2.CustomersDAL();
        }

        public static DataTable OrdenesPorClienteDAL(EN_Aplicacion2 objE)
        {
            return DA_Aplicacion2.OrdenesPorClienteDAL(objE);
        }
    }
}
