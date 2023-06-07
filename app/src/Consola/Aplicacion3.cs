using System;
using System.Collections.Generic;
using System.Text;

namespace Consola
{
    class Aplicacion3
    {
        enum carreras
        {
            //constantes 0, 1 , 2 , 3
            Computacion,Diseño,Electronica,Secretariado
         }

        static void Main()
        {
            String letra;
            try 
            { 
                do
                {   
                    Console.Clear();    //limpiar consola
                    Console.Write("Nombre Del Alumno : ");
                    string alumno=Console.ReadLine();
                    Console.Write("Elija un carrera profesional " +
                        " [0=Computacion , 1 = Diseño , 3= Electronica , 4=Secretariado ]:");
                    int nrocarrera=Convert.ToInt16(Console.ReadLine());
                    //recuperando el nombre de la carrera desde el enus
                    carreras ncarrera = (carreras)(nrocarrera); ; //enum y indice
                    Console.WriteLine("he Elegido La carrera de {0}", nrocarrera );
                    //estableciendo la pension para  cada carrera
                    double pension=0;
                    switch(nrocarrera)
                    {
                        case 0: // computacion
                            pension=350 ;
                            break;
                        case 1 : // Diseño
                            pension= 400 ;
                            break;
                        case 2 : // Electronica
                            pension = 250 ;
                            break ; 
                        case 3 : //Secretariado
                            pension = 250;
                            break;
                        default : // si no existe la carrera
                            pension=0;
                            break;
                      }
                    Console.WriteLine("El Alumno {0} debera de pagar {1}" ,
                                alumno , pension);
                    Console.WriteLine("Deseas Realizar otra operacion" +
                            "(Y = Continuar , N = SAlir )" );
                    letra = Console.ReadLine();
                }
                while(letra =="Y" || letra=="y");
             }
            catch(Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

        }
    }
}
