using System;
using System.Collections.Generic;
using System.Text;

namespace Capa.Win
{
    public static class modulo
    {
        private static int productID;

        public static int ProductID
        {
            get { return modulo.productID; }
            set { modulo.productID = value; }
        }
        private static string producto;

        public static string Producto
        {
            get { return modulo.producto; }
            set { modulo.producto = value; }
        }
        private static double precio;

        public static double Precio
        {
            get { return modulo.precio; }
            set { modulo.precio = value; }
        }

    }
}
