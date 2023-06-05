using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace Business.Aplication_Employees
{
    public class BDAplic3
    {
        public static SqlConnection cn = new SqlConnection(Cls_Conexion.cn_Northwind);

        public static string GenerarCodigo()
        {
            using (SqlCommand cmd = new SqlCommand("Usp_GeneraCodigoEmpleado", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@Emp_cod",SqlDbType.Char , 5).Direction=ParameterDirection.Output;
                cn.Open();
                cmd.ExecuteNonQuery();
                cn.Close();
                return cmd.Parameters["@Emp_cod"].Value.ToString();
            }
        }

        public static bool AgregarEmpleado(BEEmpleado  empleados)
        {
            using (SqlCommand cmd = new SqlCommand("Usp_InserEmpleado", cn))
            {
                /*@Emp_cod CHAR(6),@Emp_nom VARCHAR(50),@Emp_pais VARCHAR (50),
                    @Emp_fecha_nac CHAR(12),@Emp_sexo CHAR(20)*/

                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@Emp_cod", SqlDbType.Char, 5).Value = empleados.CodigoEmp;
                cmd.Parameters.Add("@Emp_nom", SqlDbType.VarChar , 50).Value = empleados.NombreEmp ;
                cmd.Parameters.Add("@Emp_pais", SqlDbType.Char, 50).Value = empleados.PaisEmp ;
                cmd.Parameters.Add("@Emp_fecha_nac", SqlDbType.Char, 12).Value = empleados.FechaNacEmp ;
                cmd.Parameters.Add("@Emp_sexo", SqlDbType.Char, 12).Value = empleados.SexoEmp ;

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

        public static List<BEEmpleado> listaClientes()
        {
            using (SqlCommand cmd = new SqlCommand("Usp_ListarEmpleado", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cn.Open();
                SqlDataReader dr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                List<BEEmpleado> empleado = new List<BEEmpleado>();

                while (dr.Read())
                {
                    BEEmpleado e = new BEEmpleado();
                    e.CodigoEmp = dr[0].ToString();
                    e.NombreEmp = dr[1].ToString();
                    e.PaisEmp = dr[2].ToString();
                    e.FechaNacEmp = dr[3].ToString();
                    e.SexoEmp = dr[4].ToString();
                    empleado.Add(e);
              }
              dr.Close();
              return empleado;
            }
        }
        
    }
}
