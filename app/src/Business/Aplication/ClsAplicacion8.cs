using System;
using System.Data;
using System.Data.SqlClient;

namespace Business
{
    public class ClsAplicacion8
    {
        SqlConnection cn = new SqlConnection(Cls_Conexion.cn_Northwind);

        public DataTable MostrarPaises()
        {
            using (SqlDataAdapter da = new SqlDataAdapter("MostrarPaises", cn))
            {
                DataTable tbl = new DataTable();
                da.Fill(tbl);
                return tbl;
            }
        }

        //public DataTable ClientesPorPais(String Pais, out int TCantidad )
        public DataTable ClientesPorPais(String Pais)
        {
            using (SqlCommand cmd = new SqlCommand("ClientesPorPais", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@COUNTRY", SqlDbType.VarChar, 100).Value = Pais;
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable tbl = new DataTable();
                    da.Fill(tbl);
                    //TCantidad = Convert.ToDouble(tbl.Rows.Count("@country"));
                    return tbl;
                }
            }
        }

        //        public DataTable OrdenesPorCliente(string CustomerID,out Double TVenta)
        public DataTable OrdenesPorCliente(string CustomerID)
        {
            using (SqlCommand cmd = new SqlCommand("OrdenesPorCliente", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@CustomerID", SqlDbType.Char, 5).Value = CustomerID;

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable tbl = new DataTable();
                    da.Fill(tbl);
                    //TVenta = Convert.ToDouble(tbl.Compute("sum(cantidad)"));
                    return tbl;
                }
            }
        }
    }
}
