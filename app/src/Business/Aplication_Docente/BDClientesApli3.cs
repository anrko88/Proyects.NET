using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace Business.Aplication_Docente
{
    public class BDClientesApli3
    {
        private static SqlConnection cn = new SqlConnection(Cls_Conexion.cn_Northwind);

        public static string GenerarCodigo()
        {
            using (SqlCommand cmd = new SqlCommand("Usp_GeneraCodigoDocente", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@codigo", SqlDbType.Char, 6).Direction =
                    ParameterDirection.Output;
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
                return cmd.Parameters["@codigo"].Value.ToString();
            }
        }

        public static bool AgregarDocentes(BLClientesApli3 clientes)
        {
            using (SqlCommand cmd = new SqlCommand("Usp_InserDocente", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@codigo", SqlDbType.Char, 6).Value = clientes.Codigo;
                cmd.Parameters.Add("@nombres", SqlDbType.VarChar, 100).Value = clientes.Nombres;
                cmd.Parameters.Add("@especialidad", SqlDbType.VarChar, 100).Value = clientes.Especialidad;

                try
                {
                    cn.Open();
                    cmd.ExecuteNonQuery();
                    return true;
                }
                catch (SqlException)
                {
                    return false;
                }
                finally
                {
                    cn.Close();
                }
            }
        }

        public static bool EliminarDocentes(BLClientesApli3 clientes)
        {
            using (SqlCommand cmd = new SqlCommand("usp_EliDocente", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@codigo", SqlDbType.Char, 6).Value = clientes.Codigo;

                try
                {
                    cn.Open();
                    cmd.ExecuteNonQuery();
                    return true;
                }
                catch (SqlException)
                {
                    return false;
                }
                finally
                {
                    cn.Close();
                }
            }
        }

        public static BLClientesApli3 BuscarDocentes(string codigo)
        {
            using (SqlCommand cmd = new SqlCommand("Usp_BuscarDocente", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@codigo", SqlDbType.Char, 6).Value = codigo;
                cn.Open();
                SqlDataReader dr = cmd.ExecuteReader(CommandBehavior.SingleRow );

                if (dr.Read())
                {
                    BLClientesApli3 clientes = new BLClientesApli3();
                    clientes.Codigo = dr[0].ToString();
                    clientes.Nombres = dr[1].ToString();
                    clientes.Especialidad = dr[2].ToString();
                    cn.Close();
                    return clientes;
                }
                else
                {
                    cn.Close();
                    return null;
                }
            }
        }

        public static List<BLClientesApli3> ListarClientes()
        {
            using (SqlCommand cmd = new SqlCommand("Usp_ListarDocentes", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                List<BLClientesApli3> clientes = new List<BLClientesApli3>();
                cn.Open();
                SqlDataReader dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);

                while (dr.Read())
                {
                    BLClientesApli3 c = new BLClientesApli3();
                    c.Codigo = dr[0].ToString();
                    c.Nombres = dr[1].ToString();
                    c.Especialidad = dr[2].ToString();
                    clientes.Add(c);
                }
                dr.Close();
                return clientes;
            }
        }

        public static bool UpdateDocentes(BLClientesApli3 clientes)
        {
            using (SqlCommand cmd = new SqlCommand("Usp_UpdateDocentes", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@nombres", SqlDbType.VarChar, 100).Value = clientes.Nombres;
                cmd.Parameters.Add("@especialidad", SqlDbType.VarChar, 100).Value = clientes.Especialidad;
                cmd.Parameters.Add("@codigo", SqlDbType.Char, 6).Value = clientes.Codigo;
                try
                {
                    cn.Open();
                    cmd.ExecuteNonQuery();
                    return true;
                }
                catch (SqlException)
                {
                    return false;
                }
                finally { cn.Close(); }
            }
        }


    }
}
