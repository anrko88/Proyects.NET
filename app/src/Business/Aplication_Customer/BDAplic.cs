using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace Business.Aplication_Customer
{
    public static class BDAplic
    {    
        private static SqlConnection cn = new SqlConnection(Cls_Conexion.cn_Northwind);

        public static List<BEClientes> listaClientes()
        {
            using (SqlCommand cmd = new SqlCommand("USP_CLIENTES", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                SqlDataReader dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                List<BEClientes> clientes = new List<BEClientes>();

                        while (dr.Read())
                        {
                            BEClientes c = new BEClientes();
                            c.CustomerID = dr[0].ToString();
                            c.Companyname = dr[1].ToString();
                            clientes.Add(c);
                        }
                        dr.Close();
                        return clientes;
            }
        }

        public static List<BEOrdenes> OrdenesporCliente(string codigo)
        {
            using (SqlCommand cmd = new SqlCommand("USP_OrdenesPorClientes", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@CustomerID", SqlDbType.VarChar, 5).Value = codigo;
                cn.Open();
                SqlDataReader dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                List<BEOrdenes> ordenes = new List<BEOrdenes>();
                           
                            while (dr.Read())
                            {
                                BEOrdenes o = new BEOrdenes();
                                o.OrderID =Convert.ToInt16( dr[0].ToString());
                                o.OrderDate =Convert.ToDateTime(dr[1]);
                                o.CustomerId = dr[2].ToString(); 
                                o.Freight = Convert.ToDouble(dr[3]);
                                o.Compratotal = Convert.ToDouble(dr[4]);
                                totalGeneral += Convert.ToDouble(dr[4]);
                                ordenes.Add(o);
                            }
                            dr.Close();
                            return ordenes;
            }
        }
                
        private static double totalGeneral;

        public static double TotalGeneral
        {
            get { return totalGeneral; }
            set { totalGeneral = value; }
        }
                    

    }
}
