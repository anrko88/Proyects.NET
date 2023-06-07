using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class Form_Menu : Form
    {
        public Form_Menu()
        {
            InitializeComponent();
        }

        private void btnForm2_Click(object sender, EventArgs e)
        {
            FormApl_1 Frm = new FormApl_1();
            Frm.Show();
            Hide();
        }

        private void btnForm3_Click(object sender, EventArgs e)
        {
            FormApl_2 Frm = new FormApl_2();
            Frm.Show();
            Hide();
        }

        private void btnForm4_Click(object sender, EventArgs e)
        {
            FormApl_3 Frm = new FormApl_3();
            Frm.Show();
            Hide();
        }

        private void btnForm5_Click(object sender, EventArgs e)
        {
            FormApl_4 Frm = new FormApl_4();
            Frm.Show();
            Hide();
        }

        private void btnForm6_Click(object sender, EventArgs e)
        {
            FormApl_5 Frm = new FormApl_5();
            Frm.Show();
            Hide();
        }

        private void btnForm7_Click(object sender, EventArgs e)
        {
            FormApl_6 Frm = new FormApl_6();
            Frm.Show();
        }

        private void btnElaborarProforma_Click(object sender, EventArgs e)
        {
            FormProforma Frm = new FormProforma();
            Frm.Show();
            Hide();
        }

      
  

     

       
    }
}