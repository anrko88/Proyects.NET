using System;
using System.Windows.Forms;

namespace Win.Frm.BD
{
    public partial class FrmCountriesCustomerOrder : Form
    {
        public FrmCountriesCustomerOrder()
        {
            InitializeComponent();
        }
        Business.ClsAplicacion8 obj6 = new Business.ClsAplicacion8();
          private void Form7_Load(object sender, EventArgs e)
        {

            ComboBox1.DataSource = obj6.MostrarPaises();
            ComboBox1.DisplayMember = "country";
            //ComboBox1.ValueMember = "CustomerID";
        }
        private void ComboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

            ListBox1.DataSource = obj6.ClientesPorPais(ComboBox1.Text);
            ListBox1.DisplayMember = "CompanyName";
            ListBox1.ValueMember = "CustomerID";
            // LBLCANT.Text = tbl.Rows.Count();
        }

        private void ListBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            //DataGridView1.DataSource = obj6.OrdenesPorCliente(ListBox1.SelectedValue.ToString());
        }

       
    }
}