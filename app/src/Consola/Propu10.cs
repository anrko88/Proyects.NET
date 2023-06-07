using System;
using System.Collections.Generic;
using System.Text;

namespace Consola
{
    class Propu10
    {
        /* SE PIDE HACER UN PROGRAMA PARA REPARTIR DINERO ENTRE 3 SOCIOS PARA ESO SE DEBERA
         * INGRESAR EL MONTO A REPARTIR  Y EL PORCENTAJE QUE LE CORRESPONDE A CADA SOCIO.
         * AL FINAL SE DEBERA VISUALIZAR EL MONTO QUE LE CORRESPONDE A CADA SOCIO
         *      RESULTADO
         *  REPARTICION DE DINERO
         *        Ingrese El monto : 250
         *              % Socio 1 : 10
         *              % Socio 2 : 40
         *              % Socio 3 : 50
         *  ---------------------------------
         *           Monto Socio 1 : 25
         *           Monto Socio 2 : 100
         *           Monto Socio 3 : 125            */

        static void Main()
        {
            string letra;
            try
            { 
                do
                {
                    Console.WriteLine("Ingrese El Monto : ");
                    int monto = int.Parse(Console.ReadLine());
                    double socio1 = monto * 0.10;
                    double socio2 = monto * 0.40;
                    double socio3 = monto * 0.50;


                    Console.WriteLine(" ***** Reparticion De Dinero *****  ");
                    Console.WriteLine("Monto Socio 1 : {0} , Monto Socio 2 : {1} , " +
                        "Monto Socio 3 : {2} ", +socio1, socio2, socio3);
                    Console.WriteLine("----------------------------------  ");
                    Console.WriteLine("Desea Continuar [SI = Y] [NO = N]");
                    letra=Console.ReadLine();
                }
                while(letra =="Y" || letra=="y");
            }
            catch(Exception e)
            {
                Console.WriteLine("Error {0}", e.Message);
                Console.ReadLine();
            }

        }
    }
}

