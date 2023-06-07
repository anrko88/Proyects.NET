using System;
using System.Collections.Generic;
using System.Text;
using System.IO;        //FileStream,FileReader

namespace Consola
{
    class Program5
    {
        static void Main(string[] args)
        { 
        //Abriendo el archivo de texto con FileMode.Open
            FileStream stream = new FileStream("c:\\documento.txt",FileMode.Open);
            //Lectura del archivo abierto
            StreamReader reader = new StreamReader(stream);
            //obteniendo la longitud del archivo
            int size = (int)stream.Length;
            //creando un arreglo con el tamaño de la longitud del archivo
            char[] contenido = new char[size];
            for (int i = 0; i < size; i++)
            { //leyendo letra por letra
                contenido[i] = (char)reader.Read();
            }
            //cerrando el lector de archivos
            reader.Close();
            resumiendo(contenido);
           }

        static void resumiendo(char[] contenido)
        {
            int vocales = 0, consonantes = 0, lineas = 0;
            //recorriendo el contenido del arreglo
            foreach(char caracter in contenido)
            {
            //verificando si el caracter es letra
                if(Char.IsLetter(caracter))
                {
                    if ("AEIOUaeiou".IndexOf(caracter) != -1)
                    {
                        vocales++;
                    }
                    else
                    {
                        consonantes++;
                    }
                }
                else if (caracter == '\n')
                {
                    lineas++;
                }
            }
            Console.WriteLine("Total De caracteres : {0}",contenido.Length);
            Console.WriteLine("Total De Vocales : {0}", vocales);
            Console.WriteLine("Total De Lineas : {0}", lineas);
            Console.ReadLine();
        }
    }
}
