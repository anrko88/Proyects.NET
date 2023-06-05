using System;
using System.Collections.Generic;
using System.Text;

namespace Consola
{
    class Program3
    {
        enum carreras
        { 
        Computacion,Electronica,Diseño,Secretariado
        }
        public static void Main()
        {
            try 
            { 
             String alumno;
            Console.Write("Nombre Del Alumno : ");
            alumno = Console.ReadLine();//solo cadenas
            Console.Write("Elija una carrera [Computacion=0 ," +
                "Electronica=1, Diseño=2, Secretariado = 3 ] :");
            string nrocarrera = Console.ReadLine();
            //Ingresar un numero entero , que sera considerado como cadena

            carreras n = (carreras)int.Parse(nrocarrera);
            Console.WriteLine("La Carrera Elegida Es : " + n);
            }
           catch(Exception e)
            {
                Console.WriteLine(e.Message);
           }
           Console.ReadKey();//haciendo una pausa
        }
    }
}
