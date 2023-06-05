using System;
using System.Collections.Generic;
using System.Text;

namespace Consola
{
    class Propuesto5
    {
     /*Realizae una compra donde se ingrese el nombre de un artefacto , 
         el precio del mismo y la cantidad a comprar. Se Deberara
         visualizar el valor de venta , el valor del igv(19% del valor de venta,
         el descuento 30 % del valor de venta  y el valor total que sera la
         suma de valor de venta + IGV - Descuento )
                         RESULTADO
              VENTAS DE ARTEFACTOS - CARSA
                  Artefacto : Ventilador
                  Precio :    70
                  Cantidad :  2
                  ------------------------
                  VALOR DE VENTA  :  140
                              IGV :  26.6
                  TOTAL DE VENTA  :  124.6 S/.          */

        static void Main()
        {
            String letra;
            try 
            { 
                do
                {
                Console.Write("Ingrese Nombre Del Artefacto : ");
                    string nombre=Console.ReadLine();
                Console.Write("Ingrese El Precio Del Artefacto : ");
                    int precio =int.Parse(Console.ReadLine());
                Console.Write("Ingrese Cantidad La Comprar : ");
                    int cant=int.Parse(Console.ReadLine());

                    int venta = precio * cant;
                    double igv = venta * 0.19;
                    double desc = venta * 0.30;
                    double total = (venta + igv) - desc;

                    Console.WriteLine("VENTAS DE ARTEFACTOS - CARSA");
                    Console.WriteLine("Artefacto : {0} , Precio : {1} " +
                    "Cantidad : {2} , Valor De Venta : {3} , IGV : {4} " +
                 "Total De Venta : {5} S/. ", nombre,precio,cant,venta,igv,total);

                    Console.WriteLine("Desea Contnuar [SI = Y] [NO = N]");
                    letra=Console.ReadLine();
                }
                while(letra =="Y" || letra=="y");
                
            }
            catch(Exception ex)
            {
                Console.WriteLine("Error {0}", ex.Message);
                Console.ReadLine();
            }
        }
    }
}
