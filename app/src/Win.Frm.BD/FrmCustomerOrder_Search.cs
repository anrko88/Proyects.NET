using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm.BD
{
    public partial class FrmCustomerOrder_Search : Form
    {
        public FrmCustomerOrder_Search()
        {
            InitializeComponent();
        }
        Business.ClsAplicacion4 obj3 = new Business.ClsAplicacion4();

         private void TxtCustomers_TextChanged(object sender, EventArgs e)
        {
            string customers = TxtCustomers.Text.Trim();
            DataTable tbl = obj3.CustomersBusqueda(customers);
            dataGridView1.DataSource = tbl;           
        }
        
        private void dataGridView1_CellClick(object sender, DataGridViewCellEventArgs e)
        {
           string customers = dataGridView1[0, e.RowIndex].Value.ToString();
           DataTable tbl = obj3.CustomersEncontrados(customers);
           listBox1.Items.Clear(); 
           for (int i = 0; i < tbl.Rows.Count; i++)
            {
                listBox1.Items.Add("===" + tbl.Rows[i][0].ToString() + "======" +
                                   tbl.Rows[i][1].ToString() + "======" + 
                                   tbl.Rows[i][2].ToString ()+ "===" );
            }
        }
        private void btnMenu_Click(object sender, EventArgs e)
        {
            Frm_MenuBD Clip = new Frm_MenuBD();
            Clip.Show();
            this.Hide();
        }
    }
}