using System;
using System.Collections.Generic;
using System.Text;

namespace Consola
{
    class Z_Class1
    {
        public static void Main()
        {
            string letra;
            try 
            {
                do
                {
                    Console.WriteLine("Please enter the first integer");
                    string temp = Console.ReadLine();
                    int i = Int32.Parse(temp);

                    Console.WriteLine("Please enter the second integer");
                    temp = Console.ReadLine();
                    int j = Int32.Parse(temp);

                    int k = i / j;
                    Console.WriteLine("The result of dividing {0} by {1} is {2}", i, j, k);

                    Console.WriteLine("Desea Continuar [SI = Y] [NO = N]");
                     letra =Console.ReadLine();
                }
                while (letra == "Y" ||  letra == "y");
            
            }catch(Exception e)
            {
                Console.WriteLine("Error {0}",e.Message );
                Console.ReadLine();
            }
        }
    }
}
