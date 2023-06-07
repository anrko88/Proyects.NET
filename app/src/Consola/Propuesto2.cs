using System;
using System.Collections.Generic;
using System.Text;

namespace Consola
{
    class Propuesto2
    {
     /*INGRESE EL NOMBRE DE UN ALUMNO Y SUS 3 NOTAS , SE DEBERA  VISUALIZAR EL 
       NOMBRE DEL ALUMNO CON EL PROMEDIO DE SUS NOTAS (TOMAR EN CUENTA QUE LA
       TERCERA NOTA TIENE PESO DOBLE)
                EJEMPLO :
                  INGRESO DE NOTAS
                  Alumno : Robert
                  Edad : 20 
               --------------------------
                  RESULTADO DE NOTAS 
                        //  NOTA 1:15
                        //  NOTA 2:13
                        //  NOTA 3:08
                        //  PROMEDIO : 11           */

        static void Main()
        {
            string letra;
            try
            { 
            do
            {
               
                Console.Write(" INGRESE SU NOMBRE : ");
                string nombre=Console.ReadLine();
                Console.Write(" INGRESE SU EDAD : ");
                int edad=int.Parse(Console.ReadLine());

               
                Console.WriteLine(" ****  INGRESO DE NOTAS **** ");
                Console.Write(" NOTA 1 : ");
                int n1=int.Parse(Console.ReadLine());
                Console.Write(" NOTA 2 : ");
                int n2=int.Parse(Console.ReadLine());
                Console.Write(" NOTA 3 : ");
                int n3 =int.Parse(Console.ReadLine());

               int promedio = (n1+n2+(n3*2))/4;
         
                Console.WriteLine(" **** RESULTADO DE NOTAS **** ");
                Console.WriteLine(" NOTA 1 : {0} , NOTA 2 : {1} , NOTA 3 : {2} " +
                    "Y EL PROMEDIO : {3} " , n1,n2,n3,promedio );

                Console.WriteLine("Desea continuar [ SI = Y ] [ NO = N ]");
                letra=Console.ReadLine();
            }
            while(letra == "Y" || letra =="y");
            }
            catch(Exception ex)
            {
                Console.WriteLine("Error {0}", ex.Message);
                Console.ReadLine();
            }
        }
    }
}
