using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm.BD
{
    public partial class FrmCategoryOrder : Form
    {
        public FrmCategoryOrder()
        {
            InitializeComponent();
        }

        Business.ClsAplicacion1 obj = new Business.ClsAplicacion1();

      private void Form1_Load(object sender, EventArgs e)
        {
            lstCategorias.DataSource = obj.MostrarCategorias();
            lstCategorias.DisplayMember = "CategoryName";
            lstCategorias.ValueMember = "CategoryID";
        }

     

        private void lstCategorias_Click(object sender, EventArgs e)
        {
            int IdCategoria = int.Parse(lstCategorias.SelectedValue.ToString());
            DataTable tbl = obj.ProductosPorCategoria(IdCategoria);
            lstProductos.Items.Clear();

            for (int i = 0; i < tbl.Rows.Count; i++)
            {
                lstProductos.Items.Add(tbl.Rows[i][0].ToString() + "  ==> " +
                                        tbl.Rows[i][1].ToString());
            }
        }

        private void btnMostrar_Click(object sender, EventArgs e)
        {//MOSTRAR LAS ORDENES
            string codigo = "";
            for (int i = 0; i < lstProductos.Items.Count; i++)
            { //preguntamos si el elemento fue seleccionado
                if (lstProductos.GetSelected (i))
                {   //recuperando los codigos mediante subtracion de cadenas 1,2,3,4
                    codigo += lstProductos.Items[i].ToString().Substring(0, 2).Trim() + ",";
                }
            }
            //quitando la coma sobrante 1,2,3
            codigo = codigo.Remove(codigo.Length - 1).ToString();
            //variable para recuperar el valor del parametro out
            double NVenta = 0;
            DataTable tbl = obj.OrdenesPorProductos(codigo, out NVenta);
            dataGridView1.DataSource = tbl;
            LBLCARGA.Text = NVenta.ToString("c");   //c-->formato moneda
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            double TVentapedido = 0;
            int OrderID = int.Parse(dataGridView1[0, e.RowIndex].Value.ToString());
            dataGridView2.DataSource = obj.ProductosVendidos (OrderID, out TVentapedido);
            lblVenta.Text = TVentapedido.ToString("c");
        }

        private void btnMenu_Click(object sender, EventArgs e)
        {
            Frm_MenuBD clip = new Frm_MenuBD();
            clip.Show();                    
            Hide();
        }

      

    }
}