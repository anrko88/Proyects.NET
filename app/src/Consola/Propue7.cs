using System;
using System.Collections.Generic;
using System.Text;

namespace Consola
{
    class Propue7
    {
        /*INGRESE LA CANTIDAD DE ALUMNOS MATRICULADO Y VISUALICE LA CANTIDAD DE 
         * AULAS LLENAS Y EL NUMERO DE ALUMNOS QUE FALTA PARA LLENAR UN AULA 
         * (TOME EN CUENTA QUE UNA AULA SE LLENA  CON 40 ALUMNOS ).
         *          RESULTADO
         *      CALCULO DE CANTIDAD DE ALUMNOS MATRICULADO
         *          NRO DE ALUMNOS : 190
         *       -------------------------------
         *  RESULTADOS DE AULAS Y ALUMNOS
         *  NRO DE AULAS : 4
         * NRO DE ALUMNOS FALTANTES : 30 */

        static void Main()
        {
            string letra;
            try
            {
                do
                {
                    Console.Write("INGRESE LA CANTIDAD DE ALUMNOS MATRICULADOS : ");
                    int cant = int.Parse(Console.ReadLine());
                   // int aulallena = 40;
                    int aula = cant / 4;
                    int cont = 0;
                    for (int i = 0; i <= cant ; i++ )
                    {
                        for (int j = 0; j <= 39; j++)
                        {
                            cont = cont + 1;
                        }
                    }
                    
                        Console.WriteLine("CALCULADO DE ALUMNOS MATRICULADOS");
                    Console.WriteLine("Nro De Alumnos : {0} ", cant);

                    Console.WriteLine("RESULTADOS DE AULAS Y ALUMNOS");
                    Console.WriteLine("Nro De Aulas : {0} , " +
                        "Nro De Alumnos Faltantes : {1} ", cont);

                    Console.WriteLine("Desea Continuar [SI = Y] [No = N]");
                    letra = Console.ReadLine();
                }
                while (letra == "Y" || letra == "y");
            }
            catch(Exception ex)
            {
                Console.WriteLine("Error {0}",ex.Message);
                Console.ReadLine();

            }

        }


         
    }
}
