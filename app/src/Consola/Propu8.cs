using System;
using System.Collections.Generic;
using System.Text;

namespace Consola
{
    class Propu8
    {
        /* Ingrese un numero que sera el total de segundos y visualice
         * la cantidad de horas , minutos y segundos que hay ,
         *      EJEMPLO :   Total Segundos = 7600
         *                  Horas = 2 
         *                  Minutos = 6
         *                  Segundos = 40
         *  RESULTADO
         *      HALLAR LA HORA - MINUTOS - SEGUNDOS
         *      Ingrese el total de segundos : 7600
         *  ---------------------------------------
         *        RESULTADO Hora - Minuto - Segundos
         *      Hora :2
         *      Minutos :6
         *      Segundos :40  */
        static void Main()
        {
            string letra;
            try
            {
                do{
                Console.Write("Ingrese El Total De Segundos : ");
                int num = int.Parse(Console.ReadLine());


                Console.WriteLine("RESULTADO HORA - MINUTO - SEGUNDOS");
                    Console.WriteLine("HoRa : {} , Minutos : {} , Segundos {} " ,+
                        num);

                Console.WriteLine("Desea Continuar [Si= Y] [No = N]");
                letra =Console.ReadLine();
                }
                while(letra == "Y" || letra =="y");
                }
            catch (Exception ex)
            {
                Console.WriteLine("Error {}", ex.Message);
                Console.ReadLine();
            }
        }

         
    }
}
