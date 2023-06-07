using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class Frm_Menu : Form
    {
        public Frm_Menu()
        {
            InitializeComponent();
        }

        private void BtnForm1_Click(object sender, EventArgs e)
        {
            FrmCategory form1 = new FrmCategory();
            form1.Show();
        }

        private void btnform2_Click(object sender, EventArgs e)
        {
            FrmCustomer form2 = new FrmCustomer();
            form2.Show();
        }

        private void btnform3_Click(object sender, EventArgs e)
        {
            Form3 Form3 = new Form3();
            Form3.Show();
        }

        private void btnform4_Click(object sender, EventArgs e)
        {
            Form4 Form4 = new Form4();
            Form4.Show();
        }

        private void btnform5_Click(object sender, EventArgs e)
        {
            Form5 Form5 = new Form5();
            Form5.Show();
        }

        private void btnform6_Click(object sender, EventArgs e)
        {
            Form6 Form6 = new Form6();
            Form6.Show();
        }

        private void btnform7_Click(object sender, EventArgs e)
        {
            Form7 Form7 = new Form7();
            Form7.Show();
        }
        private void btnForm8_Click(object sender, EventArgs e)
        {
            Form8 Form8 = new Form8();
            Form8.Show();
        }
        private void bntaplicacion01_Click(object sender, EventArgs e)
        {
            Aplicacion_01 Aplicacion_01 = new Aplicacion_01();
            Aplicacion_01.Show();
        }

        private void btnaplicacion02_Click(object sender, EventArgs e)
        {
            Aplicacion_02 Aplicacion_02 = new Aplicacion_02();
            Aplicacion_02.Show();
        }

        private void btnAplicacion03_Click(object sender, EventArgs e)
        {
            Aplicacion_03 Aplicacion_03 = new Aplicacion_03();
            Aplicacion_03.Show();
        }

        private void btnsalir_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Desea Salir", "Formularios",
               MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                Application.Exit();
            }

            
        }

        
    }
}