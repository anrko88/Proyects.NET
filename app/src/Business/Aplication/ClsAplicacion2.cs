using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace Business
{
    public class ClsAplicacion2
    {
        SqlConnection cn = new SqlConnection(Cls_Conexion.cn_Northwind);

        public DataTable MostrarCliente()
        {
            using (SqlDataAdapter da = new SqlDataAdapter("Usp_MostrarCLiente", cn))
            {
                DataTable tbl = new DataTable();
                da.Fill(tbl);
                return tbl;
            }
        }
    }
}
