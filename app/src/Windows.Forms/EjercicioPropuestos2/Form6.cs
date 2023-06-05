using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class Form6 : Form
    {
        public Form6()
        {
            InitializeComponent();
        }
         private void Form6_Load(object sender, EventArgs e)
        {
   /*  AGREGANDO EL ENLACE , APARTIR DEL INIIO Y FINAL DE LA CADENA AL DARLE CLICK ,
    lnkBuy.Links.Add('inicio de cadena','numero de caracteres a marcar','Link Del Sitiio'); */
            lnkBuy.Links.Add(10, 10, "http://www.amazon.com");
            lnkBuy.Links.Add(23, 16, "http://www.bn.com");
            lnkWebSite.Links.Add(4, 17, "http://www.prosetech.com");
        }
             
        private void linkWebSite_Clicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
          e.Link.Visited = true;
            System.Diagnostics.Process.Start((string)e.Link.LinkData);
        }

        private void linkBuy_Clicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            e.Link.Visited = true;
            System.Diagnostics.Process.Start((string)e.Link.LinkData);
        }

        
    }
}