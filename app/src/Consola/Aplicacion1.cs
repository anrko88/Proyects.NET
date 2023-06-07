using System;

namespace Consola
{
    class Aplicacion1
    {
        static void Main(string[] args)
        {
            
            try{
                Console.Write("ingrese el Primer Numero : ");
                int i=int.Parse(Console.ReadLine());
                Console.Write("Ingrese el Segundo Numero :");
                int x = int.Parse(Console.ReadLine());
                int j = i/ x;           //division
                int residuo = i / j;    //modulo
                Console.WriteLine("La division de (0) entre (1)" +
                    "Es (2), y el residuro es (3) " , i , x , j , residuo ) ;
                Console.ReadLine(); //ver resultado o detener pantalla


            }
                catch(Exception ez)
                {
                    Console.WriteLine("Mensje  de Error {0}", ez.Message);
                    Console.ReadLine(); //detener pantalla
                }
        }
    }
}
