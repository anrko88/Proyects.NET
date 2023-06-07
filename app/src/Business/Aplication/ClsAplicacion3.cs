using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace Business
{
    public class ClsAplicacion3
    {
        SqlConnection cn = new SqlConnection(Cls_Conexion.cn_Northwind);

        public DataTable MostrarPaises()
        {
            using (SqlDataAdapter da = new SqlDataAdapter("USp_PaisesPorOrdenes",cn))
            {
                DataTable tbl = new DataTable();
                da.Fill(tbl );
                return tbl;
            
            }
        }

        public DataTable OrdenesEmitidasPorPais(string  ShipCountry)
        {
            using (SqlCommand cmd = new SqlCommand("Usp_OrdenesEmitidasPorPais",cn ))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@ShipCountry", SqlDbType.VarChar, 100).Value = ShipCountry;

                using(SqlDataAdapter da=new SqlDataAdapter(cmd))
                {
                    DataTable tbl = new DataTable();
                    da.Fill(tbl);
                    return tbl;
                }
            }
        }

        public DataTable DetalleOrden(int OrderID)
        {
            using (SqlCommand cmd = new SqlCommand("Usp_DetalleOrden", cn))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@OrderID", SqlDbType.VarChar, 100).Value = OrderID;

            using(SqlDataAdapter da=new SqlDataAdapter(cmd))
            {
                DataTable tbl = new DataTable();
                da.Fill(tbl);
                return tbl;
            }
                
        }
        }

    }
}
