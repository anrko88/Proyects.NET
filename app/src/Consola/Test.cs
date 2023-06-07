using System;
using System.Collections.Generic;
using System.Text;

namespace Consola
{
    public class Test
    {
        public static void Main()
        {
            string letra;
            do
            {
            int x;       //VALOR DE ENTRADA 1
            int y;      //VALOR DE ENTRADA 2
            int mayor;  //RESULTADO DESDE NUMEROMAYOR()
            int f;      //RESULTADO DE FACTORIAL
            bool ok;

                //LIMPIANDO LA PANTALLA
                Console.Clear();
                //OBTENER NUMEROS DE ENTRADA
                Console.Write("Ingrese El Primer Numero : " );
                x=int.Parse(Console.ReadLine());
                Console.Write("Ingrese El Segundo Numero : " );
                y=int.Parse(Console.ReadLine());

                //PROBANDO EL METODO NUMEROMAYOR
                mayor=Utils.numeromayor(x,y);
                Console.WriteLine("El Valor alto Es " + mayor);

                //PROBANDO EL METODO INTERCAMBIO
                Console.WriteLine("Antes De intercambiar :" + x + "," + y );
                Utils.intercambio(ref x, ref y);
                Console.WriteLine("Despues De intercambiar :" +x + "," + y);

                //OBTENIENDO EL VALOR PARA EL FACTORIAL

                Console.Write("Numero Para el Factorial");
                x=int.Parse(Console.ReadLine());

                //PROBANDO LA FUNCION DEL FACTORIAL
                ok=Utils.Factorial(x,out f);
                //RESULTADO DE SALIDA DEL FACTORIAL
                if(ok)
                    Console.WriteLine("Factorial(" + x + ")= " + f);
                else
                    Console.WriteLine("No se puede hacer el computo de este factorial");

                //PROBANDO LA FUNCTION DEL FACTORIAL (version recursiva)

                ok=Utils.RecurisveFactorial(x,out f);

                if(ok)
                    Console.WriteLine("Factorial("+ x +") = s" + f + "(recursive)");
                else
                    Console.WriteLine("No Se puede hacer el computo de este factorial (recursive)");
                Console.Write("Desea Salir de la Aplicaiocn [S = Continuar] [N = SAlir] : ");
                letra=Console.ReadLine();         

            } while(letra=="S");             
        }
    }
}
