using System;
using System.Collections.Generic;
using System.Text;

namespace Consola
{
    class Propu11
    {
        /* Se Debera Ingresar EL Sueldo De Un Trabajador Y Se Debera De Mostrar Cuantos
         * Billetes De 100, 50 , 20 , 10 , 5 , 2 y 1 sol le toca al trabajador en base al 
         * sueldo que percibe               
         *          RESULTADO :
         *                      DESGLOZADOR DE BILLETES
         * 
         * TRABAJADOR : Robert Vivar
         * Sueldo   : 1583
         * -------------------------------------
         *      Billetes De 100 : 15
         *      Billetes De 50 : 1
         *      Billetes De 20 : 1
         *      Billetes De 10 : 1
         *      Billetes De 5 : 0
         *      Billetes De 2 : 1
         *      Billetes De 1 : 1 */

        static void Main()
        {
            string letra;
            try
            {
                do
                {
                    Console.Write("Ingrese Su Nombre De Trabajador : ");
                    string nombre = Console.ReadLine();
                    Console.Write("Ingrese El Sueldo De Un Trabajador : ");
                    int sueldo = int.Parse(Console.ReadLine());
                    int billete100 = sueldo / 100;

                    // int s = sueldo / 100;
                    // int d = (sueldo )
                  Console.WriteLine("Trabajdor : {0} ,Sueldo : {1} ,Billetes De 100 : {2} ," +
                    "Billetes De 50 : {3} ,Billetes De 20 : {4} ,Billetes De 10 : {5} ," +
                    "Billetes De 5 : {6} ,Billetes De 2 : {7} ,"  +
                    "Billetes De 1 : {8}",nombre,sueldo,billete100);
                    Console.WriteLine("Desea Continuar [SI = Y] [NO = N]");
                    letra = Console.ReadLine();

                }
                while (letra == "y" || letra == "Y");
            }
            catch (Exception e)
            {
                Console.WriteLine("Error {0}", e.Message);
                Console.ReadLine();
            }
        }



    }
}
