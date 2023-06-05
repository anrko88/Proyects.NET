using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class FrmCustomer : Form
    {
        public FrmCustomer()
        {
            InitializeComponent();
        }

        private void Form2_Load(object sender, EventArgs e)
        {
            string[] colorNames;
            colorNames = System.Enum.GetNames(typeof(KnownColor));
                //  CARGANDO LOS COLORES
            lstColors.Items.AddRange(colorNames );
        }

        private void lstColors_SelectedIndexChanged(object sender, EventArgs e)
        {
            
            KnownColor selectedColor;   //SELECCIONADO EL CONTROL
            selectedColor=(KnownColor)System.Enum .Parse(typeof(KnownColor),lstColors.Text);

            this.BackColor = System.Drawing.Color.FromKnownColor(selectedColor);

            //  MOSTRANDO LA INFORMACION DEL COLOR
            lblBirghtness.Text="Brillo = " + this.BackColor.GetBrightness().ToString();
            lblHue.Text="Hue = " + this.BackColor.GetHue().ToString();
            lblSaturation.Text="Saturacion = " + this.BackColor.GetSaturation().ToString();
        }
    }
}