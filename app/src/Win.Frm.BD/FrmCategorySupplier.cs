using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm.BD
{

    public partial class FrmCategorySupplier : Form
    {
        public FrmCategorySupplier()
        {
            InitializeComponent();
        }
        Business.ClsAplicacion9 objP = new Business.ClsAplicacion9();

        private void Form1_Load(object sender, EventArgs e)
        {
            listBox2.SelectedIndexChanged -= new EventHandler(listBox2_SelectedIndexChanged);
            
             DataTable tbl=objP.ListarCategorias ();
            listBox1.DisplayMember = "companyname";
            listBox1.ValueMember = " SupplierID";
            listBox1.DataSource = tbl;

            listBox2.DisplayMember = "cantidad";
            listBox2.ValueMember = " SupplierID";
            listBox2.DataSource = tbl;
         
        }

        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            listBox2.SelectedIndexChanged -= new EventHandler(listBox2_SelectedIndexChanged);
            listBox1.SelectedIndexChanged -= new EventHandler(listBox1_SelectedIndexChanged);

            //string proveedor = listBox1.Text;
    /* DataTable tbl = objP.ListarProductos(proveedor);            
      //     MessageBox.Show(Convert.ToString(proveedor));
        for (int i = 0; i < listBox1.Items.Count; i++)
        {
            listBox1.Items.Add(tbl.Rows[i][0].ToString());
        }
            dataGridView1.DataSource = tbl;
        */
        }
        private void listBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            listBox2.SelectedIndexChanged -= new EventHandler(listBox2_SelectedIndexChanged);
            
            listBox2.SelectedIndexChanged += new EventHandler(listBox2_SelectedIndexChanged);
        }

        private void listBox2_Click(object sender, EventArgs e)
        {
            ListView();
           
        }
        void ListView()
        {         
            listView1.View = View.Details;
            listView1.GridLines = true;      listView1.FullRowSelect = true;
            listView1.Columns.Add("ProductID", 70, HorizontalAlignment.Left);
            listView1.Columns.Add("SupplierId", 70, HorizontalAlignment.Left);
            listView1.Columns.Add("CompanyName", 130, HorizontalAlignment.Left);
            listView1.Columns.Add("Unitprice", 70, HorizontalAlignment.Left);
            listView1.Columns.Add("Discontinued", 100, HorizontalAlignment.Left);

            DataTable tbl = new DataTable();
            string producto = listBox2.Text;
            tbl = objP.ListarProductos(producto);
            ListViewItem ListView = new ListViewItem();
            for (int i = 0; i < tbl.Rows.Count; i++)
            { 
                ListView = listView1.Items.Add(tbl.Rows[i][0].ToString ());
                ListView.SubItems.Add (tbl.Rows[i][1].ToString());
                ListView.SubItems.Add(tbl.Rows[i][2].ToString());
                ListView.SubItems.Add(tbl.Rows[i][3].ToString());
                ListView.SubItems.Add(tbl.Rows[i][4].ToString());
            }
            lblcantidad.Text = listView1.Items.Count.ToString();
        }

      



    }
}
