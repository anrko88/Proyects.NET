using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm.BD
{
    public partial class FrmCustomer : Form
    {
        public FrmCustomer()
        {
            InitializeComponent();
        }
        Business.ClsAplicacion2 obj2= new Business.ClsAplicacion2();
        DataTable tbl;

        private void Form2_Load(object sender, EventArgs e)
        {
            tbl=obj2.MostrarCliente();
            lblcustomerId.DataBindings.Add("text", tbl, "customerid");
            lblCompanyName.DataBindings.Add("text", tbl, "CompanyName");
            LblContact.DataBindings.Add("text", tbl, "ContactName");
        }
        private void btn01_Click(object sender, EventArgs e)
        {
            BindingContext[tbl].Position = 0;
        }

        private void btn02_Click(object sender, EventArgs e)
        {
            BindingContext[tbl].Position -= 1;
        }

        private void btn03_Click(object sender, EventArgs e)
        {
            BindingContext[tbl].Position += 1;
        }

        private void btn04_Click(object sender, EventArgs e)
        {
            BindingContext[tbl].Position = tbl.Rows.Count;
        }

        private void btnmenu_Click(object sender, EventArgs e)
        {
            Frm_MenuBD clip = new Frm_MenuBD();
            clip.Show();
            this.Hide();
        }

        
    }
}