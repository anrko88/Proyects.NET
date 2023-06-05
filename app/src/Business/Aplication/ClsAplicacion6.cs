using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace Business
{
    public class ClsAplicacion6
    {
        SqlConnection cn = new SqlConnection(Cls_Conexion.cn_Northwind);
        public DataTable MostrarConsultaDeFecha(string fecha1,string fecha2)
        {
            using (SqlCommand cmd = new SqlCommand("Usp_ConsDePedidosDeFechas ", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@fecha1", SqlDbType.VarChar, 10).Value = fecha1;
                cmd.Parameters.Add("@fecha2", SqlDbType.VarChar, 10).Value = fecha2;
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable tbl = new DataTable();
                    da.Fill(tbl);
                    return tbl;
                }
            }        
        }
    }
}
