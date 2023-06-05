using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Capa.Entidad;
using Capa.Negocio;

namespace Capa.Win
{
    public partial class FrmProductSearch : Form
    {
        public FrmProductSearch()
        {
            InitializeComponent();
        }
        EN_Aplicacion2 objEN = new EN_Aplicacion2();
        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            //  BUSQUEDA DE PRODUCTOS
            objEN.Datos = textBox1.Text.Trim();
            DataTable tbl = NE_Aplicacion2.BusquedaProductosBL(objEN);
            dataGridView1.DataSource = tbl;
            lblCantidad.Text = tbl.Rows.Count.ToString();
            dataGridView1.Columns[0].Width = 80;
            dataGridView1.Columns[1].Width=180;
            dataGridView1.Columns[2].Width = 90;      
        }
              
        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            modulo.ProductID = Convert.ToInt16 (dataGridView1[0, dataGridView1.CurrentCell.RowIndex].Value);
            modulo.Producto = Convert.ToString(dataGridView1[1, dataGridView1.CurrentCell.RowIndex].Value);
            modulo.Precio = Convert.ToDouble(dataGridView1[2, dataGridView1.CurrentCell.RowIndex].Value);
            this.Close();
        }

        private void Form2_Load(object sender, EventArgs e)
        {
            textBox1.Focus();
        }
    }
}