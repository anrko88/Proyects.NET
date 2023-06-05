using System;
using System.Collections.Generic;
using System.Text;

namespace Consola
{
    class Aplicacion4
    {
        enum meses
        {
            Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,
            Octubre,Noviembre,Diciembre
        }
            
        static void Main()
        {
            //crear un arreglo del ultimo dia del mes
            int[] diafinales = new int[12] { 31, 28,
                31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
            Console.Write("Ingrese un numero de dia entre 1 a 365 ");
            int numdia = int.Parse(Console.ReadLine());
            //verificando el rango de dias
            if (numdia < 1 || numdia > 365)
            {
                Console.WriteLine("Dia Fuera De Rango");
                Console.ReadLine();
                return; // salir del procedimiento
            }
            int numeromes = 0;
            foreach (int dia in diafinales)//recorriendo el areglo de dias
            {
                if (numdia <= dia)
                    break;
                else
                {       //restando el dia  ingresado con el dia del arreglo
                    numdia = numdia - dia;
                    numeromes++;//incrementando el siguiente mes
                }
            }
            //recuperando el mes seleccionado desde el enum
            meses mes = (meses)numeromes;
            Console.WriteLine("{0}{1}" , numdia , mes);
            Console.WriteLine();
                            
        }
    }
}
