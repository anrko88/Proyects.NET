using System;
using System.Collections.Generic;
using System.Text;

namespace Consola
{
    class Utils
    {
 //LLamda de funciones entre clases. CRearemos una clase y lo llamaremos Utils.cs
        public static int numeromayor(int a, int b)
        {
            if (a > b)
                return a;
            else
                return b;
            //otra alternativa
            //return ( a > b ) > ( a ) : ( b );
        }
        //intercambio de enteros ,pasados por refeencia

        public static void intercambio(ref int a, ref int b)
        {
            int temp = a;
            a = b;
            b = temp;
        }

  //calculo de factorial y retorna el resultado como un paramero de salida out

        public static bool Factorial(int n, out int respuesta)
        {
            int k;  //bucle contador
            int f;  //valor trabajado
            bool ok = true; //true si e sok,false si no es

            //chequeando el valor de entrada

            if (n < 0)
                ok = false;

            //calculando el valor del factorial como el
            //producto de todos los numeros de 2 para n

            try
            {
                checked
                {
                    f = 1;
                    for (k = 2; k <= n; ++k)
                    {
                        f = f * k;
                    }

                    //AQUI OTRA ALTERNATIVA
                    //for(f=1, k<= n; ++k)
                    //  f*=k;
                }
            }
            catch (Exception)
            {
                f = 0;
                ok = false;
            }
            //ASIGNANDO EL VALOR COMO RESULTADO
            respuesta = f;

            //RETURN PARA LA LLAMADA
            return ok;
        }
        //FUNCION DEL FACTORIAL RECURSIVA

        public static bool RecurisveFactorial(int n, out int f)
        {
            bool ok = true;
            //entradas negativas
            if (n < 0)
            {
                f = 0;
                ok = false;
            }

            if (n <= 1)
                f = 1;
            else
            {
                try
                {
                    int pf;
                    checked
                    {
                        ok = RecurisveFactorial(n - 1, out pf);
                        f = n * pf;
                    }
                }
                catch (Exception)
                {
                    f = 0;
                    ok = false;
                }
            }
            return ok;
        }
    }
}
