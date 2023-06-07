using Layer.Datos;
using Layer.Entidad;
using System.Data;

namespace Layer.Negocio
{
    public static class NE_Web02
    {

        public static DataTable Cons_AñoNEG()
        {
            return DA_Web02.Cons_AñoDAL();
        }

        public static DataTable Cons_CategoriasNEG()
        {
            return DA_Web02.Cons_CategoriasDAL ();
        }

        public static DataTable Consulta01NEG(EN_Web02 objE)
        {
            return DA_Web02.Consulta01DAL(objE);
        }

        public static DataTable Consulta02ANEG(EN_Web02 objE)
        {
            return DA_Web02.Consulta02ADAL(objE);
        }

        public static DataTable Consulta02BNEG(EN_Web02 objE)
        {
            return DA_Web02.Consulta02BDAL(objE);
        }

        public static DataTable Consulta03NEG(EN_Web02 objE)
        {
            return DA_Web02.Consulta03DAL(objE);
        }
    }
}
