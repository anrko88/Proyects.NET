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
    public partial class FrmProduct : Form
    {
        public FrmProduct()
        {
            InitializeComponent();
        }
        EN_Aplicacion2 objEN = new EN_Aplicacion2();
        private void BtnBusqueda_Click(object sender, EventArgs e)
        {
            FrmProductSearch Form2 = new FrmProductSearch();
            Form2.ShowDialog();
            lblNombreProducto.Text = modulo.Producto;
            lblProductoID.Text = modulo.ProductID.ToString();
            lblUnitPrice.Text = modulo.Precio.ToString();
        }
        DataRow dr;//Representa un a fila De Datos De Un Datable
        DataTable tbldetalle;
        private void Form1_Load(object sender, EventArgs e)
        {
            tbldetalle = new DataTable("Detalle");
            tbldetalle.Columns.Add(new DataColumn("ProductID", typeof(int)));
            tbldetalle.Columns.Add(new DataColumn("ProductName", typeof(string)));
            tbldetalle.Columns.Add(new DataColumn("UnitPrice", typeof(double)));
            tbldetalle.Columns.Add(new DataColumn("Quantity", typeof(int)));            
            tbldetalle.Columns.Add(new DataColumn("Total", typeof(double)));
            tbldetalle.PrimaryKey = new DataColumn[] { tbldetalle.Columns[0] };
            dataGridView1.DataSource = tbldetalle;
            //Formato Del ListView1
            listView1.View = View.Details;
            listView1.GridLines = true;
            listView1.Columns.Add("ProdcutID",80,HorizontalAlignment.Left );
            listView1.Columns.Add("ProductName", 170, HorizontalAlignment.Left);
            listView1.Columns.Add("Cantidad", 80, HorizontalAlignment.Left);

          /*  DataTable tbl= new DataTable();
            tbl= BL_Aplicacion1.ListaProductosVendidosBL();
             dataGridView1.DataSource = tbl;*/
        }

        private void btnAgregar_Click(object sender, EventArgs e)
        {
            try 
            {
                dr = tbldetalle.NewRow();
                dr[0] = int.Parse(lblProductoID.Text);
                dr[1] = lblNombreProducto.Text;
                dr[2] = Convert.ToDouble(lblUnitPrice.Text);
                dr[3] = Convert.ToInt16(numericUpDown1.Value );
                dr[4] = Math.Round(Convert.ToDouble(dr[2]) * Convert.ToInt16(dr[3]), 4);
                tbldetalle.Rows.Add(dr);
                tbldetalle.AcceptChanges();
                  sumatotales() ;
            }
            catch(Exception ex)
            {
                if (MessageBox.Show("El producto ya existe", "Actualizar Stock",
                    MessageBoxButtons.YesNo, MessageBoxIcon.Information) == DialogResult.Yes)
                {
                    dr = tbldetalle.Rows.Find(Convert.ToInt16(lblProductoID.Text));
                    dr.BeginEdit();
                    dr["Quantity"] = Convert.ToInt16(dr["Quantity"]) + Convert.ToInt16(numericUpDown1.Value);
                    dr["Total"] = Convert.ToDouble(dr["Unitprice"]) * Convert.ToDouble(dr["Quantity"]);
                    dr.EndEdit();
                    tbldetalle.AcceptChanges();
                    sumatotales();                    
                }
                ex.ToString();
            }
        }
        void sumatotales()
        { 
            //VERIFICANDO SI LA SUMA DE TOTALES ES NULO
            lblVentaTotal.Text = tbldetalle.Compute("sum(total)", "").Equals(DBNull.Value)?
                "0.00" : tbldetalle.Compute("sum(total)", "").ToString(); 
        }

        private void BtnELiminar_Click(object sender, EventArgs e)
        {
            try 
            {
                int codigo = Convert.ToInt16(dataGridView1[0, dataGridView1.CurrentCell.RowIndex].Value);
                dr = tbldetalle.Rows.Find(codigo);
                dr.Delete();
                tbldetalle.AcceptChanges();
                sumatotales();
            }
            catch(Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        private void BtnCancelar_Click(object sender, EventArgs e)
        {
            tbldetalle.Rows.Clear();
            tbldetalle.AcceptChanges();
            sumatotales();
        }

        private void BtnCerrar_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void BtnGrabarProductos_Click(object sender, EventArgs e)
        {
                //GRABANDO LOS PRODUCTOS SELECCIONADOS EN SQL SERVER
            int i = 0;
            int j = 0;
            for (i = 0; i < tbldetalle.Rows.Count; i++)
            {
                objEN.ProductID = Convert.ToInt16(tbldetalle.Rows[i][0]);
                objEN.Producto = tbldetalle.Rows[i][1].ToString();
                objEN.Cantidad = Convert.ToInt16(tbldetalle.Rows[i][3]);
                j += NE_Aplicacion2.GrabarProductosBL(objEN);
            }
            MessageBox.Show(String.Format("Se Registraron {0} Productos", i.ToString()));
            //LISTADO DE PRODUCTOS SELECCIONADOS EN EL LISTVIEW1
            //PARA MOSTRAR EL RATING DE PRODCUTOS VENDIDOS
            DataTable tbl = NE_Aplicacion2.ListaProductosVendidosBL();
            ListViewItem lv;
            listView1.Items.Clear();
            for (int x = 0; x < tbl.Rows.Count; x++)
            {
                lv = listView1.Items.Add(tbl.Rows[x][0].ToString());
                lv.SubItems.Add(tbl.Rows[x][1].ToString());
                lv.SubItems.Add(tbl.Rows[x][2].ToString());
            }
        }

    }
}