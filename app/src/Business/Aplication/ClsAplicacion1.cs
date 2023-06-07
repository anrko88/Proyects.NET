using System;
using System.Data;
using System.Data.SqlClient;

namespace Business
{
    public class ClsAplicacion1
    {
        SqlConnection cn = new SqlConnection(Cls_Conexion.cn_Northwind);
        public DataTable MostrarCategorias()
        {
            using (SqlDataAdapter da = new SqlDataAdapter("usp_Categorias", cn))
            {
                DataTable tbl = new DataTable();
                da.Fill(tbl);  return tbl;
            }
        }
        public DataTable ProductosPorCategoria(int ProductId)
        {
            using (SqlCommand cmd = new SqlCommand("usp_ProdporCategoria", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@CategoryID", SqlDbType.Int).Value = ProductId;
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable tbl = new DataTable();
                    da.Fill(tbl);  return tbl;
                }
            }
        }

        public DataTable OrdenesPorProductos(string IdProducts, out Double Tventa)
        {
            using (SqlCommand cmd = new SqlCommand("usp_OrdenesporProductos", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@idProductos", SqlDbType.VarChar, 100).Value = IdProducts;
                using(SqlDataAdapter da=new SqlDataAdapter(cmd))
                {
                    DataTable tbl = new DataTable(); da.Fill(tbl);
                    Tventa = Convert.ToDouble(tbl.Compute("sum(VentaporPedido)", ""));
                    return tbl;
                }
            }   
        }
        public DataTable ProductosVendidos(int OrderId, out Double TVentaPedido)
        {
            using (SqlCommand cmd = new SqlCommand("usp_ProductosVendidos", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@OrderID", SqlDbType.Int).Value = OrderId;                
                using(SqlDataAdapter da=new SqlDataAdapter(cmd))
                {
                    DataTable tbl = new DataTable();  da.Fill(tbl);
                    TVentaPedido = Convert.ToDouble(tbl.Compute("Sum(Total)", ""));
                    return tbl;
                }
            }
        }
    }
}
