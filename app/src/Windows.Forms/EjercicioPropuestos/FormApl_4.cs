using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class FormApl_4 : Form
    {
        public FormApl_4()
        {
            InitializeComponent();
        }
           private void Form5_Load(object sender, EventArgs e)
        {
            txtApellidos.Focus();
        }

           private void btnMostrar_Click(object sender, EventArgs e)
        {
            if (txtPension.Text == "")
            {
                MessageBox.Show("Ingrese Pension", "Validacion",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                txtPension.Focus();
            }
            else
            {
                double pension = Convert.ToDouble(txtPension.Text);
                double turno, traslado;
                if (rbtTarde.Checked == true)
                {
                    turno = pension * 0.10;
                    txtDesTur.Text = " 10 %";
                    txtTotal1.Text = Convert.ToString(turno);
                                   }
                if (rbtNoche.Checked == true)
                {
                    turno = pension * 0.20;
                    txtDesTur.Text = " 20 %";
                    txtTotal1.Text = Convert.ToString(turno);
                }
                if (rbtmañana.Checked == true)
                {
                    turno = pension * 0.20;
                    txtDesTur.Text = " 0 %";
                    txtTotal1.Text = Convert.ToString(turno);
                }

                if (chkTraslado.Checked == true)
                {
                    traslado = pension * 0.30;
                    txtIncTras.Text = "30 % ";
                    txtTotal2.Text = Convert.ToString(traslado);
                }
                else
                {
                    traslado = pension * 0.50;
                    txtIncTras.Text = " 0 % ";
                    txtTotal2.Text = Convert.ToString(traslado);
                }
             

            } 
        }
        private void btnNuevo_Click(object sender, EventArgs e)
        {

        }

       

        private void btnMenu_Click(object sender, EventArgs e)
        {
            Form_Menu Form1 = new Form_Menu();
            Form1.Show();
            Hide();
        }

      

    }
}