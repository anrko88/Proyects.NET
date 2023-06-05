using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class Frm3 : Form
    {
        public Frm3()
        {
            InitializeComponent();
        }

        //INGRESE LA CANTIDAD DE METROS Y AL HACER CLIP EN UN BOTON 
        //CONVERTIRLO A CMS (1 metro = 100 cms )
        //      RESULTADO
        //  CONVERTIR DE METROS A CENTIMETROS
        //INGRESE LA CANTIDAD EN METROS : 2.5
        //EN CENTIMETROS ES 250.0

        private void Form3_Load(object sender, EventArgs e)
        {
            label1.Text = "Ingrese La Cantidad En Metros : ";
            Btnconvertir.Text = "Convertir A cms";
  
            lblresultado.Visible = false;
        }

        private void Btnconvertir_Click(object sender, EventArgs e)
        {
            Decimal cms = Decimal.Parse(this.txtmetros.Text);
            Decimal res = cms * 10;
            lblresultado.Visible = true;
            lblresultado.Text = "En Centimetros Es : " + res;
        }
    }
}