using System;
using System.Collections.Generic;
using System.Text;

namespace Consola
{
    public enum Tipocuenta {cheque,deposito }
    public struct CuentaBancaria
    {
        public long Nrocuenta;
        public decimal balancecta;
        public Tipocuenta Tcuenta;
    }
    
    class Program1
    {
        static void Main()
        {
            CuentaBancaria cuentaoro;
            Console.Write("Ingrese El Numero De Cuenta : ");
            cuentaoro.Nrocuenta = long.Parse(Console.ReadLine());

            cuentaoro.Tcuenta = Tipocuenta.cheque;
            cuentaoro.balancecta = (decimal)3200.00;

            Console.WriteLine("**** Resumen de cuenta ****");
            Console.WriteLine("Numero de cuenta : {0}", cuentaoro.Tcuenta);
            Console.WriteLine("Tipo de cuenta : {0}", cuentaoro.Tcuenta);
            Console.WriteLine("Balance de cuenta : {0} :", cuentaoro.balancecta);
            Console.ReadLine();
         }
    }
}
