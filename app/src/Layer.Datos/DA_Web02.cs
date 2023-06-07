using Layer.Entidad;
using Microsoft.ApplicationBlocks.Data;
using System;
using System.Configuration;
using System.Data;

namespace Layer.Datos
{
    public static class DA_Web02
    {
        static string cn =
         ConfigurationManager.ConnectionStrings["cn"].ConnectionString;

        public static DataTable Cons_AñoDAL()
        {
            return SqlHelper.ExecuteDataTable(cn, "Usp_Cons_Año");
        }

        public static DataTable Cons_CategoriasDAL()
        {
            return SqlHelper.ExecuteDataTable(cn, "Usp_Cons_Categorias");
        }
                    
        public static DataTable Consulta01DAL(EN_Web02 objE)
        {
            //return SqlHelper.ExecuteDataTable(cn, "Usp_Consulta01",objE.Fecha1,objE.Fecha2 );            
            return SqlHelper.ExecuteDataTable(cn, "Usp_Consulta01", Convert.ToDateTime( objE.Fecha1),Convert.ToDateTime( objE.Fecha2));
        }

        public static DataTable Consulta02ADAL(EN_Web02 objE)
        {
            return SqlHelper.ExecuteDataTable(cn, "Usp_Consulta02A",objE .CategoryName );
        }

        public static DataTable Consulta02BDAL(EN_Web02 objE)
        {
            return SqlHelper.ExecuteDataTable(cn, "Usp_Consulta02B",objE.ProductName  );
        }

        public static DataTable Consulta03DAL(EN_Web02 objE)
        {
            return SqlHelper.ExecuteDataTable(cn, "Usp_Consulta03",objE.Año  );
        }
              
    }
}
