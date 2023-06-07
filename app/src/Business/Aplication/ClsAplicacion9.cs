using System.Data;
using System.Data.SqlClient;

namespace Business
{

    public class ClsAplicacion9
    {
        SqlConnection cn = new SqlConnection(Cls_Conexion.cn_Northwind);

        public DataTable ListarCategorias()
        {
            using (SqlDataAdapter da = new SqlDataAdapter("ListarCategorias", cn))
            {
                DataTable tbl = new DataTable();
                da.Fill(tbl);
                return tbl;
            }
        }

        public DataTable ListarProductos(string proveedor)//, out int cantidad)
        {
            using (SqlCommand cmd = new SqlCommand("ListarProductos", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@idproveedor", SqlDbType.VarChar, 100).Value = proveedor;
                //CompanyName
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable tbl = new DataTable();
                    da.Fill(tbl);
                    //  cantidad = Convert.ToInt16(tbl.Compute("count(Total)", ""));
                    return tbl;
                }
            }
        }

    }
}
