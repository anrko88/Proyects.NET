using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class FormApl_3 : Form
    {
        public FormApl_3()
        {
            InitializeComponent();
        }

        private void Form4_Load(object sender, EventArgs e)
        {
            txttrabajador.Focus();
        }

        private void btnCalcular_Click(object sender, EventArgs e)
        {
            if (txttrabajador.Text == "") 
            {
                MessageBox.Show("Ingrese Nombre Del Trabajador", "",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            if (txtsueldo.Text == "" || (Convert.ToDouble(txtsueldo.Text)== 0))
            {
                MessageBox.Show("Ingrese Sueldo", "",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            else 
            {
                //dim cad As String = Microsoft.VisualBasic.Right(Me.txtusuario.Text, 12)
                int n = Convert.ToInt16(txtsueldo.Text);
               int num = Convert.ToInt32(txtsueldo.Text.Remove(2));
             //  int bill100 = Convert.ToInt16(txtsueldo.Text) / num;
               int bill50 = (Convert.ToInt32(txtsueldo.Text) % 100) / 50;
               int bill20 = ((Convert.ToInt32(txtsueldo.Text) % 100) % 50) / 20;
               int bill10 = (((Convert.ToInt32(txtsueldo.Text) % 100) % 50) % 20) / 10;
               int bill5 = ((((Convert.ToInt32(txtsueldo.Text) % 100) % 50) % 20) % 10) / 5;
               int bill2 = ((((((Convert.ToInt32(txtsueldo.Text) % 100) % 50) % 20) % 10) % 5) / 2);
               int bill1 = ((((((Convert.ToInt32(txtsueldo.Text) % 100) % 50) % 20) % 10) % 5) % 2);
             //MessageBox.Show(Convert.ToString(num));
               this.txt100.Text = Convert.ToString(num);
               this.txt50.Text = Convert.ToString(bill50);
               this.txt20.Text = Convert.ToString(bill20);
               this.txt10.Text = Convert.ToString(bill10);
               this.txt5.Text = Convert.ToString(bill5);
               this.txt2.Text = Convert.ToString(bill2);
               this.txt1.Text = Convert.ToString(bill1);
            }

        }
        
        private void btnMenu_Click(object sender, EventArgs e)
        {
            Form_Menu Form1 = new Form_Menu();
            Form1.Show();
            Hide();
        }

        private void btnSalir_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Desea Salir", "Formularios",
                           MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                Application.Exit();
            }
        }

        private void btnNuevo_Click(object sender, EventArgs e)
        {

        }
    }
}