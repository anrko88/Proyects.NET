using System;
using System.Collections.Generic;
using System.Text;

namespace Consola
{
    class Program2
    {
        public static void Main()
        {
            Console.BackgroundColor = ConsoleColor.DarkBlue;
            Console.ForegroundColor = ConsoleColor.White;
            Console.WriteLine("Visual C# Net 2008");

            Console.BackgroundColor = ConsoleColor.Black;
            Console.ForegroundColor = ConsoleColor.Yellow;
            Console.Write("Bienvenidos - ");

            Console.ForegroundColor = ConsoleColor.Magenta;
            Console.Write("Seccion 3692");
            Console.WriteLine();

            Console.ForegroundColor = ConsoleColor.Cyan;

            DateTime hoy = DateTime.Now;
            Console.WriteLine("Formato Normal : " + hoy.ToString());
            Console.WriteLine("Formato Fecha Corta : " + hoy.ToShortDateString());
            Console.WriteLine("Formato Fecha Larga : " + hoy.ToLongDateString());

            Console.ReadKey();
            Console.BackgroundColor = ConsoleColor.White;
            Console.ForegroundColor = ConsoleColor.DarkRed;
            Console.Clear();
         }
     }
}
