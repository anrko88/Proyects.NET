using Capa.Entidad;
using Capa.Negocio;
using System;
using System.Data;
using System.Drawing;
using System.IO;
using System.Windows.Forms;

namespace Capa.Win
{
    public partial class FrmProductOrder : Form
    {
        public FrmProductOrder()
        {
            InitializeComponent();
        }
        EN_Aplicacion1 objEN = new EN_Aplicacion1();
        private void Form1_Load(object sender, EventArgs e)
        {
            for (int i = 65; i <= 90; i++)
            { 
                listBox1.Items.Add(Convert.ToChar(i)); 
            }

            listView1.View  = View.Details;
            listView1.GridLines = true; 
            listView1.FullRowSelect = true;
            listView1.Columns.Add("ProductID", 80, HorizontalAlignment.Left);
            listView1.Columns.Add("ProductName", 120, HorizontalAlignment.Left );
            listView1.Columns.Add("UnitPrice", 100, HorizontalAlignment.Left);
            listView1.Columns.Add("CategoryID", 100, HorizontalAlignment.Left);            
        }

        private void listBox1_Click(object sender, EventArgs e)
        {
            try
            {
                string codigo = string.Empty;
                for (int i = 0; i < listBox1.Items.Count; i++)
                {
                    if (listBox1.GetSelected(i))
                    {
                        codigo += "'" + listBox1.Items[i].ToString() + "',";
                    }
                }

                if (codigo.Length == 0)
                {
                    listView1.Items.Clear ();
                    dataGridView1.DataSource = null;
                    lblEmploeeID.Text = "";
                    lblEmploeeID.Text = "";
                    pictureBox1.Image = null;
                    pictureBox2.Image = null;
                    return;
                }

                codigo = codigo.Substring(0, codigo.Length - 1);
                objEN.Letras = codigo;
                DataTable tbl = NE_Aplicacion1.BusquedaProductoProLetraNEG(objEN);
                ListViewItem lv;
                listView1.Items.Clear();
                for (int i = 0; i < tbl.Rows.Count; i++)
                {
                    lv = listView1.Items.Add(tbl.Rows[i][0].ToString());
                    lv.SubItems.Add(tbl.Rows[i][1].ToString());
                    lv.SubItems.Add(tbl.Rows[i][2].ToString());
                    lv.SubItems.Add(tbl.Rows[i][3].ToString());
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void listView1_Click(object sender, EventArgs e)
        {
            //RECUPERANDO EL CODGIO DE LA CATEGORIA
            int CategoryID = Convert.ToInt16(
                listView1.Items[listView1.SelectedIndices[0]].SubItems[3].Text);
            objEN.CategoryID = CategoryID;
            DataTable tbl = NE_Aplicacion1.FotoDeCategoriaNEG(objEN);
            lblcategoria.Text = tbl.Rows[0][0].ToString();
            Byte[] foto = (Byte[])tbl.Rows[0][1];
            MemoryStream ms = new MemoryStream();
            int desplazamiento = 78;
            ms.Write(foto, desplazamiento, foto.Length - desplazamiento);
            Bitmap bmp = new Bitmap(ms);
            ms.Close();
            pictureBox1.SizeMode = PictureBoxSizeMode.StretchImage;
            pictureBox1.Image = bmp;
            //Busqueda de ordenes
            int ProductID = Convert.ToInt16(
                listView1.Items[listView1.SelectedIndices[0]].Text);
            objEN.ProductID = ProductID;
            tbl = NE_Aplicacion1.OrdenesPorProductoNEG(objEN);
            dataGridView1.DataSource = tbl;
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            int orden = Convert.ToInt16(
                dataGridView1[0, dataGridView1.CurrentCell.RowIndex].Value);
            objEN.OrderID = orden;
            DataTable tbl = NE_Aplicacion1.FotoDeEmpleadoNg(objEN);
            lblEmploeeID.Text=tbl.Rows[0][0].ToString();
            lblEmpleado.Text=tbl.Rows[0][1].ToString();
            Byte[] foto = (Byte[])tbl.Rows[0][2];
            MemoryStream ms = new MemoryStream();
            int desplazamiento = 78;
            ms.Write(foto, desplazamiento, foto.Length - desplazamiento);
            Bitmap bmp = new Bitmap(ms);
            ms.Close();
            pictureBox2.SizeMode = PictureBoxSizeMode.StretchImage;
            pictureBox2.Image = bmp;           
        }                             
    }
}