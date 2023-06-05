using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class FormApl_2 : Form
    {
        public FormApl_2()
        {
            InitializeComponent();
        }
        string[] Productos = new string[] { "Televisor", "Teclado", "Impresora", "DVD", "Equipo" };
        
        private void Form3_Load(object sender, EventArgs e)
        {
            cboProducto.Focus();
            cboProducto.Items.AddRange(Productos);
        }
        private void btnCalcular_Click(object sender, EventArgs e)
        {
            if (cboProducto.Text == "")
            {
                MessageBox.Show("Selecione Un Producto", "Validacion",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            if(txtvalCompra.Text=="")
            {
                MessageBox.Show("Ingrese Un Valor De Compra", "Validacion",
                        MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            if (txtPorUtilidad .Text == "")
            {
                MessageBox.Show("Ingrese Una Utilidad", "Validacion",
                        MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            if (txtPorCliente .Text == "")
            {
                MessageBox.Show("Ingrese Un Descuento", "Validacion",
                        MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            else 
            {
                double igv = Convert.ToDouble(txtvalCompra.Text) * 0.19;
                double precioCompra = Convert.ToDouble(txtvalCompra.Text) + igv;
                double utilidad = precioCompra * Convert.ToDouble(txtPorUtilidad.Text);
                double precioPublico = precioCompra + utilidad;
                double descuento = precioPublico * Convert.ToDouble(txtPorCliente.Text);
                double precioDesc = precioPublico -  descuento;

                txtIgv.Text = igv.ToString();
                txtPreCompra.Text  = precioCompra.ToString();
                txtUtilidad.Text = utilidad.ToString();
                txtPrePubSug.Text = precioPublico.ToString();
                txtDescuento.Text = descuento.ToString();
                txtPreConDes.Text = precioDesc.ToString();
            }
        }

       

        private void btnNuevo_Click(object sender, EventArgs e)
        {
            foreach (Control c in this.Controls)
            {
                if (c is TextBox)
                {
                    c.Text = "";
                    cboProducto.Text = "";
                    MessageBox.Show("Limpio","", MessageBoxButtons.OK, MessageBoxIcon.Question);
                }
            }
        }

         private void btnMenu_Click(object sender, EventArgs e)
        {
            Form_Menu Frm = new Form_Menu();
            Frm.Show();
            Hide();
        }
    }
}