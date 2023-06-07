using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;

namespace Business
{
    public class ClsAplicacion4
    {
        SqlConnection cn = new SqlConnection(Cls_Conexion.cn_Northwind);

        public DataTable CustomersBusqueda(string Customers)
        {
            using (SqlCommand cmd = new SqlCommand("Usp_CustomersBusqueda",cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@Customers", SqlDbType.VarChar, 100).Value = Customers;
                 using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable tbl = new DataTable();
                    da.Fill(tbl);
                    return tbl;
                }
            }           
        }
        public DataTable CustomersEncontrados(string customerId)
        {
            using (SqlCommand cmd = new SqlCommand("Usp_CustomersEncontrados", cn))
            { 
            cmd.CommandType=CommandType.StoredProcedure;
            cmd.Parameters.Add("@CustomerId", SqlDbType.VarChar, 5).Value = customerId;
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
