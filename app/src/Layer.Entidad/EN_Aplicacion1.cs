using System;

namespace Layer.Entidad
{
    public class EN_Aplicacion1
    {
        private string articulo;

        public string Articulo
        {
            get { return articulo; }
            set { articulo = value; }
        }
        private string fac_num;

        public string Fac_num
        {
            get { return fac_num; }
            set { fac_num = value; }
        }
        private DateTime fac_fec;

        public DateTime Fac_fec
        {
            get { return fac_fec; }
            set { fac_fec = value; }
        }
        private string cli_cod;

        public string Cli_cod
        {
            get { return cli_cod; }
            set { cli_cod = value; }
        }
        private string fac_igv;

        public string Fac_igv
        {
            get { return fac_igv; }
            set { fac_igv = value; }
        }
        private double total;

        public double Total
        {
            get { return total; }
            set { total = value; }
        }
        private string art_cod;

        public string Art_cod
        {
            get { return art_cod; }
            set { art_cod = value; }
        }
        private double art_pre;

        public double Art_pre
        {
            get { return art_pre; }
            set { art_pre = value; }
        }
        private int art_cant;

        public int Art_cant
        {
            get { return art_cant; }
            set { art_cant = value; }
        }

        
    }
}
