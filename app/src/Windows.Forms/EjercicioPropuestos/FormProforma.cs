using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class FormProforma : Form
    {
        public FormProforma()
        {
            InitializeComponent();
        }
        string[] producto = new string[] { "PC","MOUSE","TECLADO","IMPRESORA","SCANER","YOYSTICK",
                        "CD","DISKET","LAPTOM","LABORATORIO"};
        double[] precio = new double[] { 500.50, 15.99, 12.00, 87.00, 150.00, 29.00,
                                               45.0, 3.00, 1500.00, 3000.00 };
        string[] descripcion = new string[] {"Computadora", "Mouse Inalambrico", "Teclado Multimedia",
                                      "Impresora HP", "Scaner HP", "YOYSTICK Para Pc", "Cd Para Grabar", 
                                        "Disket 3.1/2", "Laptom HP", "Laboratio De Computo" };

         private void Selecionar_Producto(object sender, EventArgs e)
        {
            lblprecio.Text = precio[cmbProducto.SelectedIndex].ToString();
            txtdesc.Text = descripcion[cmbProducto.SelectedIndex].ToString();
            string ruta = Application.StartupPath.Substring(0, Application.StartupPath.Length - 9);
            pictureBox1.Image = Image.FromFile(ruta + "imagen\\" +
                Convert.ToString(cmbProducto.SelectedIndex) + ".JPG");
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            this.cmbProducto.Items.AddRange(producto);
            btnAgregar.Enabled = false;
        }     

        private void btnAgregar_Click(object sender, EventArgs e)
        {    
            //MessageBox.Show( Convert.ToString(cmbProducto.SelectedIndex));
            if (this.cmbProducto.SelectedIndex == -1 )
            {
                MessageBox.Show("Seleccione Un Producto Por Favor", "Error",
                    MessageBoxButtons.OK,MessageBoxIcon.Warning  );
                cmbProducto.Focus();
                return;
            }
            if (Convert.ToInt16(txtcant.Text) == 0)
            {
                MessageBox.Show("Ingrese Una Cantidad", "Error", MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);
                return;
            }        
            else
            {
              
            }
            lstProducto.Items.Add(cmbProducto.Text);
            lstPrecio.Items.Add(Convert.ToString(lblprecio.Text));
            lstCantidad.Items.Add(Convert.ToInt16(txtcant.Text));
            int cant = Convert.ToInt16(txtcant.Text);
            int  precio = int.Parse(lblprecio.Text);
            MessageBox.Show(Convert.ToString(precio ));
            
           // double prec = Convert.ToDouble(precio);

          ///  int subtotal = Convert.ToInt16(cant * Convert.ToInt16(lblprecio.Text));
         //   lstSub.Items.Add(Convert.ToString(subtotal));

           
        }

        private void txtcant_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (Convert.ToInt32(txtcant.SelectionLength) > 0)
            {
                btnAgregar.Enabled = true;
            }
            else
            {

                btnAgregar.Enabled = false;
            }//*/
        }
        private void btnMenu_Click(object sender, EventArgs e)
        {
            Form_Menu Form1 = new Form_Menu();
            Form1.Show();
            Hide();
        }
    }
}