using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm.BD
{
    public partial class Frm_MenuBD : Form
    {
        public Frm_MenuBD()
        {
            InitializeComponent();
        }

        private void btnform1_Click(object sender, EventArgs e)
        {
            FrmCategoryOrder frm = new FrmCategoryOrder();
            frm.Show();
            Hide();
        }

        private void btnform2_Click(object sender, EventArgs e)
        {
            FrmCustomer frm = new FrmCustomer();
            frm.Show();
            Hide();
        }

        private void btnform3_Click(object sender, EventArgs e)
        {
            FrmCountry frm = new FrmCountry();
            frm.Show();
            Hide();
        }

        private void btnform4_Click(object sender, EventArgs e)
        {
            FrmCustomerOrder_Search frm = new FrmCustomerOrder_Search();
            frm.Show();
            Hide();
        }

        private void btnform5_Click(object sender, EventArgs e)
        {
            FrmPUBS frm = new FrmPUBS();
            frm.Show();
            Hide();
        }

        private void btnform6_Click(object sender, EventArgs e)
        {
            FrmFechas frm = new FrmFechas();
            frm.Show();
            Hide();
        }

        private void btnform7_Click(object sender, EventArgs e)
        {
            FrmPorcentaje frm = new FrmPorcentaje();
            frm.Show();
            Hide();
        }

        private void btnform8_Click(object sender, EventArgs e)
        {
            FrmCountriesCustomerOrder frm = new FrmCountriesCustomerOrder();
            frm.Show();
            Hide();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            FrmCustomerOrder frm = new FrmCustomerOrder();
            frm.Show();
            Hide();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            FrmCategoryProduct frm = new FrmCategoryProduct();
            frm.Show();
            Hide();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            FrmEmployeed_CRUD frm = new FrmEmployeed_CRUD();
            frm.Show();
            Hide();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            Frm_Docente_CRUD frm = new Frm_Docente_CRUD();
            frm.Show();
            Hide();
        }
    }
}