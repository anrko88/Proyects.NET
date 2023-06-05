using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Business.Aplication_Customer;

namespace Win.Frm.BD
{
    public partial class FrmCustomerOrder : Form
    {
        public FrmCustomerOrder()
        {
            InitializeComponent();
        }
        
                private void Form1_Load(object sender, EventArgs e)
                {           //desactivar evento del combobox1
                   comboBox1.SelectedIndexChanged -= new EventHandler(comboBox1_SelectedIndexChanged);
                    List<BEClientes> clientes = BDAplic.listaClientes();

                    comboBox1.DataSource = clientes;
                    comboBox1.DisplayMember = "CompanyName";
                    comboBox1.ValueMember = "CustomerID";
                    //activando el evento del combobox1
                    comboBox1.SelectedIndexChanged += new EventHandler(comboBox1_SelectedIndexChanged);                       
                         }

                private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
                {
                    BDAplic.TotalGeneral = 0 ;
                    List<BEOrdenes> ordenes = BDAplic.OrdenesporCliente(comboBox1.SelectedValue.ToString ());
                    dataGridView1.DataSource = ordenes;
                    lblcantPedidos.Text = ordenes.Count .ToString();
                    lbltotal.Text = BDAplic.TotalGeneral.ToString();
                    //para llear u listview
                    //for (int i = 0; i < ordenes.count; i++)
                    //{
                    //    listview1.item.add(ordenes[i].orderid.Tostring());
                    //    subitems.add(ordenes[i].orderdate.Tostring());
                    //}
                }

        private void btnform2_Click(object sender, EventArgs e)
        {
            FrmCategoryProduct form2 = new FrmCategoryProduct();
          form2.Show();
        }

        private void btnform3_Click(object sender, EventArgs e)
        {
            FrmEmployeed_CRUD Form3_MantEmpl = new FrmEmployeed_CRUD();
            Form3_MantEmpl.Show();
        }
    }
}