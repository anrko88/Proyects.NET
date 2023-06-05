using Business.Aplication_Categories;
using System;
using System.Collections.Generic;
using System.Data;
using System.Windows.Forms;

namespace Win.Frm.BD
{
    public partial class FrmCategoryProduct : Form
    {
        public FrmCategoryProduct()
        {
            InitializeComponent();
        }
        private void btnMostrar_Click(object sender, EventArgs e)
        {
            formatoListView2();
            string categoryId = Convert.ToString ( listView1.Items.ToString().Substring(0, 5));
            int stock = Convert.ToInt16(txtstock.ToString());
            //  MessageBox.Show(Convert.ToString(stock));
            List<BEProductos> productos = BDAplic2.listaproductos(categoryId,stock);
            ListViewItem Listview = new ListViewItem();
            for (int i = 0; i < productos.Count; i++)
            {
                Listview = listView1.Items.Add(productos[i].CategoryName .ToString());
                Listview.SubItems.Add(productos[i].CategoryID.ToString());
                Listview.SubItems.Add(productos[i].ProductID.ToString());
                Listview.SubItems.Add(productos[i].ProductName.ToString());
                Listview.SubItems.Add(productos[i].Stock .ToString());
            }
        }

        private void BtnGrabar_Click(object sender, EventArgs e)
        {

        }
        void formatoListView1()
        {
            DataTable tbl = new DataTable();
            listView1.View = View.Details;
            listView1.GridLines = true; listView1.FullRowSelect = true;
            listView1.Columns.Add("CategoryID", 100, HorizontalAlignment.Left);
            listView1.Columns.Add("CategoryName", 190, HorizontalAlignment.Left);
        }
        void formatoListView2()
        {
            DataTable tbl = new DataTable();
            listView1.View = View.Details;
            listView1.GridLines = true; listView1.FullRowSelect = true;
            listView1.Columns.Add("CategoryID", 100, HorizontalAlignment.Left);
            listView1.Columns.Add("CategoryName", 100, HorizontalAlignment.Left);
            listView1.Columns.Add("ProductID", 100, HorizontalAlignment.Left);
            listView1.Columns.Add("ProductName", 100, HorizontalAlignment.Left);
            listView1.Columns.Add("Stock", 80, HorizontalAlignment.Left);
        }
        private void OptAD_Click(object sender, EventArgs e) 
        {
            List<BECategorias> categorias = BDAplic2.listarCategorias(OptAD.Text);
            listView1.Items.Clear(); formatoListView1();
            ListViewItem Listview =new ListViewItem(); 
            for (int i = 0; i < categorias.Count; i++)
            {  Listview=listView1.Items.Add(categorias[i].CategoryID.ToString());
                Listview.SubItems.Add(categorias[i].CategoryName.ToString());
            }
        }
        private void OptEG_Click(object sender, EventArgs e)
        {
            List<BECategorias> categorias = BDAplic2.listarCategorias(OptEG.Text);
            listView1.Items.Clear(); formatoListView1();
            ListViewItem ListView = new ListViewItem();
            for (int i = 0; i < categorias.Count; i++)
            { ListView=listView1.Items.Add(categorias[i].CategoryID.ToString());
            ListView.SubItems.Add(categorias[i].CategoryName.ToString());               
            }            
        }

        private void OptHK_Click(object sender, EventArgs e)
        {
            List<BECategorias> categorias = BDAplic2.listarCategorias(OptHK.Text);
            listView1.Items.Clear(); formatoListView1();
            ListViewItem ListView = new ListViewItem();
            for (int i = 0; i < categorias.Count; i++)
            {
                ListView = listView1.Items.Add(categorias[i].CategoryID.ToString());
                ListView.SubItems.Add(categorias[i].CategoryName.ToString());
            }        
        }

        private void OptLO_Click(object sender, EventArgs e)
        {
            List<BECategorias> categorias = BDAplic2.listarCategorias(OptLO.Text);
            listView1.Items.Clear(); formatoListView1();
            ListViewItem ListView = new ListViewItem();
            for (int i = 0; i < categorias.Count; i++)
            {
                ListView = listView1.Items.Add(categorias[i].CategoryID.ToString());
                ListView.SubItems.Add(categorias[i].CategoryName.ToString());
            }       
        }

        private void OptPS_Click(object sender, EventArgs e)
        {
            List<BECategorias> categorias = BDAplic2.listarCategorias(OptPS.Text);
            listView1.Items.Clear(); formatoListView1();
            ListViewItem ListView = new ListViewItem();
            for (int i = 0; i < categorias.Count; i++)
            {
                ListView = listView1.Items.Add(categorias[i].CategoryID.ToString());
                ListView.SubItems.Add(categorias[i].CategoryName.ToString());
            }       
        }

        private void OptTZ_Click(object sender, EventArgs e)
        {
            List<BECategorias> categorias = BDAplic2.listarCategorias(OptTZ.Text);
            listView1.Items.Clear(); formatoListView1();
            ListViewItem ListView = new ListViewItem();
            for (int i = 0; i < categorias.Count; i++)
            {
                ListView = listView1.Items.Add(categorias[i].CategoryID.ToString());
                ListView.SubItems.Add(categorias[i].CategoryName.ToString());
            }       
        }
      

        
    }
}