using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace Business
{
    public class ClsAplicacion5_PUBS
    {
        SqlConnection cn = new SqlConnection(Cls_Conexion.cn_Pubs);
        public DataTable Usp_BUBSPaises()
        { 
            using (SqlDataAdapter da=new SqlDataAdapter ("Usp_BUBSPaises",cn))
            {
                DataTable tbl = new DataTable();
                da.Fill(tbl);
                return tbl;
            }                
        }

        public DataTable Usp_PUBSEditoriales(string pais)
        {
            using (SqlCommand cmd = new SqlCommand("Usp_PUBSEditoriales", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("pais", SqlDbType.VarChar, 30).Value = pais;
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable tbl = new DataTable();
                    da.Fill(tbl);
                    return tbl;
                }
            }
        }

        public DataTable Usp_PUBSLibros(string codEditorial)
        {
            using (SqlCommand cmd = new SqlCommand("Usp_PUBSLibros", cn))
            { 
            cmd.CommandType=CommandType.StoredProcedure;
            cmd.Parameters.Add("@pub_id", SqlDbType.VarChar, 30).Value = codEditorial;
                using(SqlDataAdapter da=new SqlDataAdapter(cmd) )
                {
                     DataTable tbl=new DataTable();
                    da.Fill(tbl);   
                    return tbl;
                }
            }
        }
    }
}
