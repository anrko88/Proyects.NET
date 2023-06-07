using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace Business.Aplication_Categories
{
    public class BDAplic2
    {
        public static SqlConnection cn = new SqlConnection(Cls_Conexion.cn_Northwind);

        public static List<BECategorias> listarCategorias(string letra)
        {
            using (SqlCommand cmd = new SqlCommand("Usp_CategoriasLetras", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@letra", SqlDbType.VarChar, 10).Value = letra;
                cn.Open();
                SqlDataReader dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                List<BECategorias> categorias = new List<BECategorias>();
                
                while (dr.Read())
                {
                    BECategorias c = new BECategorias();
                    c.CategoryID = Convert.ToInt16(dr[0].ToString());
                    c.CategoryName = dr[1].ToString();                  
                    categorias.Add(c);
                }
                dr.Close();   return categorias;
            }
        }

        public static List<BEProductos> listaproductos(string categoryName,int stock)
        {
            using (SqlCommand cmd = new SqlCommand("usp_ProdxCategoria", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@CAtegoryName", SqlDbType.VarChar,20).Value = categoryName;
                cmd.Parameters.Add("@stock", SqlDbType.Int).Value = stock;
                cn.Open();
                SqlDataReader  dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                List<BEProductos> productos = new List<BEProductos>();

                while (dr.Read ())   
                {
                    BEProductos p = new BEProductos();
                    p.CategoryName = dr[0].ToString();
                    p.CategoryID = dr[1].ToString();
                    p.ProductID = Convert.ToInt16(dr[2].ToString ());
                    p.ProductName = dr[3].ToString();
                    p.Stock = Convert.ToInt16(dr[4].ToString());
                    productos.Add (p);
                }
                dr.Close();   return productos;
            }
        }
        public static List<BEProductos> InserProductos(BEProductos productos)
        {
            using (SqlCommand cmd = new SqlCommand("Usp_InserProductos", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@ProductID", SqlDbType.Int).Value = productos.ProductID ;
                cmd.Parameters.Add("@ProductName",SqlDbType.VarChar,100).Value=productos.ProductName;
                cmd.Parameters.Add("@UnitPrice",SqlDbType.Float ).Value=productos.UnitPrice ;
                cmd.Parameters.Add("@UnitsInStock",SqlDbType.Int ).Value=productos.Stock ;
                
                SqlDataReader dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                List<BEProductos> insert = new List<BEProductos>();

                while (dr.Read())
                {
                    BEProductos p = new BEProductos();
                    p.ProductID = Convert.ToInt16(dr[0].ToString());
                    p.ProductName  = dr[1].ToString();
                    p.UnitPrice  = Convert.ToInt16 (dr[2].ToString());
                    p.Stock  = Convert.ToInt16(dr[3].ToString());
                    insert.Add(p);
                }
                dr.Close();
                return insert;
            }
        }
    }
}
