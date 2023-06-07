using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class FrmCategory : Form
    {
        public FrmCategory()
        {
            InitializeComponent();
        }

        private void txtcodigo_KeyPress(object sender, KeyPressEventArgs e)
        {
            if ((e.KeyChar < '0' || e.KeyChar > '9') && (e.KeyChar != 13) && (e.KeyChar != 8))
            {
                e.Handled = true;       // NO PERMITE EL INGRESO DE LA CADENA NO PEMRITIDO
            }
            else
            {
                if (txtcodigo.Text.Length == 5)
                {
                    txtcodigo.Focus();
                }
            }
        }       
            
        private void txtnombre_KeyPress(object sender, KeyPressEventArgs e)
        {
            //VALIDANDO POR CODIGOS ASCCI
            int tecla = Convert.ToInt32(e.KeyChar);
            if ((tecla >= 65 && tecla <= 90) || (tecla >= 97 && tecla <= 122)
                  || tecla == 8 || tecla == 32)
            {
                if (tecla == 13)
                {
                    txtedad.Focus();
                }
            }
            else
            {
                e.Handled = true;
            }
        }

        private void txtedad_Validating(object sender, CancelEventArgs e)
        {
            try
            {
                int edad = Convert.ToInt32(txtedad.Text );
                if ((edad < 18) || (edad > 65))
                {
                    //cancela el evento y selecciona el texto corecto por el usuario
                    e.Cancel = true;
                    MessageBox.Show("Ingrese La Edad Correcta");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
                txtedad.Text = "0";
            }
        }

        private void txtedad_KeyPress(object sender, KeyPressEventArgs e)
        {
            if ((e.KeyChar < '0' || e.KeyChar > '9') && (e.KeyChar != 8) && (e.KeyChar != 13))
            {
                e.Handled = true;
            }
            else
            {
                if (txtedad.Text.Length == 3 || txtedad.Text.Length == 2)
                {
                    cmdEnviar.Focus();
                }
            }
        }

        private void cmdNuevo_Click(object sender, EventArgs e)
        {
            //RECORRIENDO LOS CONTROLES DEL FORMULARIO
            foreach (Control c in this.Controls)
            {
                if (c is TextBox)//preguntando si el control es una caja de texto
                {
                    c.Text = "";
                }
            }
            this.txtcodigo.Focus();
        }

        private void cmdEnviar_Click(object sender, EventArgs e)
        {
            MessageBox.Show("Programa Validado", "Validacion Realizada");
        }
    }
}