using System;
using System.Collections.Generic;
using System.Text;

namespace Consola
{
    class Aplicacion2
    {
        static void Main(string[] args)
        {
            try
            {
                double descuento = 0;
                double monto = 500;
                Console.Write("Ingrese Un Nombre : ");
                String nombre = Console.ReadLine();
                Console.Write("Escribe La Editorial A Comprar(Macro,Bruño) :");
                String editorial = Console.ReadLine();
                Console.Write("Tipo de comprador(1 = Estudiante, 2 = Publico ) :");
                int tipo = int.Parse(Console.ReadLine());
                //evaluando la editorial y el tipo de empleado para si
                //descuento en base el monto establecido.
                if (editorial == "Macro")
                {
                    if (tipo == 1)
                        descuento = monto * 0.25;
                    else
                        descuento = monto * 0.15;
                }
                else
                {
                    if (tipo == 1) 
                    descuento = monto * 0.20;
                    else
                    descuento=monto*0.12;

                }
                Console.WriteLine("El Cliente {0} tendra que pagar {1} " ,
                                nombre , monto - descuento);
            }
            catch (Exception ex)
            {
                Console.Write("Mesnaje de Error {0}", ex.Message);
            }
                //haiga o no haiga error
            finally
            {
                Console.ReadLine();//detenga pantalla
            }

        }
    }
}
