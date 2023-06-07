using System;
using System.Collections.Generic;
using System.Text;

namespace Consola
{
    class Propu9
    {
        /* INGRESE LA CANTIDAD DE DOLARES A COMPRAR Y LA TASA DE CAMBIO DEL DIA, SE DEBERA
         * VISUALIZAR EL MONTO EN SOLES A PAGAR.
         *          RESULTADO
         *      CASA DE CAMBIO DE DOLARES
         *  Fecha De hoy : 14/03/09
         *  Tasa De Cambio : 3.46
         *  Monto En Soles : 5.19.00 */

        static void Main()
        {
            string letra;
            try
            {
                do{
                   Console.Write("Ingrese La Cantidad De Dolares : ");
                double cant=double.Parse(Console.ReadLine());
                double tasa = 3.46;
                double monto = cant * tasa ;
             /* DateTime fecha;*/
                Console.WriteLine("Fecha De Hoy : {0} , Tasa De Cambio : {1} ," +
              "Cantidad De Dòlar : {2} , Monto En Soles : {3}", cant, tasa, cant, monto);

                Console.WriteLine("Desea Continuar [SI = Y] [No = N]");
                letra = Console.ReadLine();
                }
                while(letra =="Y" || letra=="y");

             
            }
            catch(Exception ex)
            {
                Console.WriteLine("Error {0} ", ex.Message);
                Console.ReadLine();
            }
        }
    }
}
