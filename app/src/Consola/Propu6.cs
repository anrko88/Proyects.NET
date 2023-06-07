using System;
using System.Collections.Generic;
using System.Text;

namespace Consola
{
    class Propu6
    {
        /* Ingrese el nombre de un artefacto , precio,cantidad y el numero de 
        cuotas en la que piensa pagar el valor de venta (Precio * Cantidad).
        Al Precionar La Tecla [Enter] Debera Visualizar la cuota inicial
        (35% de valor de venta ), el saldo (Valor De Venta - Cuota Inicial)
         Asi Como tambien el valor de cada cuota(Saldo/Nro de cuotas).
                          RESULTADO :
                  VENTA DE ARTEFACTO AL CREDITO
                     Artefacto : Televisor
                      Precio :    550
                      Cantidad :  2 
                     Nro De Cuotas   : 3
               ----------------------------------
                  Cuota Inicial : 385
                  Saldo   : 715
                  Valor De Cuota : 238.33           */

        static void Main()
        {
            String letra;
            try 
            {
                do
           {
                    Console.Write("Ingrese El Nombre De Un Artefacto : ");
                          string nombre=Console.ReadLine();
                    Console.Write("Ingrese El Precio Del Artefacto : ");
                         int precio=int.Parse(Console.ReadLine());
                    Console.Write("Ingrese La Cantidad Del Artefacto : ");
                         int cant = int.Parse(Console.ReadLine());
                    Console.Write("Ingrese El Numero De Cuotas : ");
                         int nrocuota = int.Parse(Console.ReadLine());

                    int venta = precio * cant;
                  
                    Double cuotainicial = venta * 0.35;
                    double saldo = venta - cuotainicial;
                    double valorcuota = saldo/nrocuota;

                    Console.WriteLine("** VENTA DE ARTEFACTO AL CREDITO **");
                    Console.WriteLine("Artefacto :{0} , Precio : {1} , " +
                   "Cantidad : {2} , Nro Cuotas : {3} , Cuota Inicial : {4} ," +
                    "Saldo : {5} , Valor De Cuota : {6} " +
                  nombre, precio, cant, nrocuota, cuotainicial, saldo, valorcuota);

                Console.WriteLine("Desea Continuar [SI = Y] [NO = N]");
                 letra=Console.ReadLine();
              }
                while(letra == "Y" || letra == "y");
            }
            catch(Exception ex)
            {
                Console.WriteLine("Error {0}", ex.Message);
                Console.ReadLine();
            }
    }
    }
}