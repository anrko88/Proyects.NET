using System;
using System.Collections.Generic;
using System.Text;

namespace Consola
{
    class Propuesto1
    {
        /*INGRESE UN NUMERO Y AL PRESIONAR [ENTER], SE VISUALIZARAN 
        EL DOBLE ,LA MITAD Y EL CUBO DEL NUMERO INGRESADO
                EJEMPLO :
                        NUMERO => 25
                        MITAD => 12.5
                       DOBLE =>  50
                        CUBO => 15625       */
        static void Main()
        {
            String letra;
           try
           {
               do
               {

                   Console.Clear();
                   Console.Write("INGRESE UN NUMERO : ");
                   int n = int.Parse(Console.ReadLine());
                   double mitad = n /2;
                   int doble = n * 2;
                   int cubo = n * n * n;
                   Console.WriteLine();
                   Console.WriteLine("LA MITAD ES {1} , EL DOBLE ES {2} " +
                                             "Y EL CUBO ES {3} ", n, mitad, doble, cubo);
                
                   Console.WriteLine();
                   Console.WriteLine("  DESEAS CONTINUAR [CONTINUAR = Y ] [SALIR = N]");
                   letra = Console.ReadLine();
               }
               while (letra == "Y" || letra == "y");
          
           }

           catch(Exception ex)
            {
              Console.WriteLine("Mensaje De Error {0} " , ex.Message);
              Console.ReadLine();
            }           

        
        }
    }
}
