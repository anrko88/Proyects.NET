using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;
using System.Configuration;
using Layer.Entidad;

namespace Layer.Datos
{
    public static class DA_WebF
    {
        static string cn =
           ConfigurationManager.ConnectionStrings["cn"].ConnectionString;

        public static DataTable Lista_01DA()
        {
            return SqlHelper.ExecuteDataTable(cn, "Usp_Final01");
        }

        public static DataTable Lista_02DA(EN_WebF objE)
        {
            return SqlHelper.ExecuteDataTable(cn, "Usp_Final02", objE.Categoria);
        }

        public static int Lista_03DA(EN_WebF objE)
        {
            return SqlHelper.ExecuteNonQuery(cn,
                "Usp_Final03",objE.ProductID,objE.UnitsInStock ,objE.UnitPrice);
        }
    }
}
