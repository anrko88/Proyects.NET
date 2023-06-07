using System;
using System.Collections.Generic;
using System.Text;

namespace Consola
{
    class Propuesto4
    {
        /* INGRESE EL NOMBRE DE UN TRABAJADOR Y LA CANTIDAD DE BALDES QUE HACE 
        DICHO TRABAJADOR, SE DEBERA VISUALIZAR EL PAGO AL TRABAJADOR
         (Tomar en cuenta que se paga 0.25 por balde hecho ).
                    RESULTADO
        PAGOS AL TRABAJADOR POR CANTIDAD DE BALDES
              TRABAJADOR : ROBERT VIVAR
              #.BALDES :30
          ---------------------------------
        Pago por balde : 0.25
        Visualizar pago al trabajador :7.5  */

        static void Main()
        {
            string letra;
            try 
            {
                do
                {
                    //  Console.Clear();
                 Console.Write("INGRESE EL NOMBRE DE UN TRABAJADOR : ");
                    string nombre=Console.ReadLine();
                Console.WriteLine("Ingrese La Cantidad De Baldes : ");
                    int cant=int.Parse(Console.ReadLine());
                        
                double pago= cant*0.25;
                /* Console.BackgroundColor = ConsoleColor.DarkBlue;*/
                Console.ForegroundColor = ConsoleColor.White;
               Console.WriteLine("PAGOS AL TRABAJADOR POR CANTIDAD DE BALDES");
               Console.ForegroundColor = ConsoleColor.Red;
               Console.WriteLine(" Trabajador : {0} , Num Baldes : {1} " +
  "Pago Por Balde : 0.25 , Visualizar Pago Al Trabajador {2} ", nombre, cant, pago);

               Console.WriteLine("Desea Continuar [SI = Y] [NO = N]");
               letra = Console.ReadLine();
                }
                while(letra == "Y" || letra =="y");
            }
            catch(Exception ex)
            {
                Console.WriteLine("Error{0}",ex.Message);
                Console.ReadLine();
            }
        }

    }
}
