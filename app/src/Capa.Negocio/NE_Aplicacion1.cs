using Capa.Datos;
using Capa.Entidad;
using System.Data;

namespace Capa.Negocio
{
    public static class NE_Aplicacion1
    {
        public static DataTable BusquedaProductoProLetraNEG(EN_Aplicacion1 objN)
        {
            return BD_Aplicacion1.BusquedaProductoProLetraDAL(objN);
        }

        public static DataTable FotoDeCategoriaNEG(EN_Aplicacion1 objN)
        {
                return BD_Aplicacion1.FotoDeCategoriaDAL(objN ) ;
        }
            
        public static DataTable OrdenesPorProductoNEG(EN_Aplicacion1 objN)
        {
            return BD_Aplicacion1.OrdenesPorProductoDAL(objN ) ;
         }

        public static DataTable FotoDeEmpleadoNg(EN_Aplicacion1 objN)
        {
            return BD_Aplicacion1.FotoDeEmpleadoDAL(objN );
        }
                
    }
}
