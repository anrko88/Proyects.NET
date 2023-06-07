using System;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class Aplicacion_02 : Form
    {
        public Aplicacion_02()
        {
            InitializeComponent();
        }

        string[] productos = new string[] { "Teclado ABC", "Monitor LCD" ,
            "Procesador INTEL core Duo", "DIsco Duro","Memoria"};
        double[] precio = new double[] { 25.50, 750.89, 980.85, 400, 250.50 };
        string[] clientes = new string[] { "Juan Fabio", "Miguel Angel" ,
            "Eduardo Rivas","Carlos Antonio","Arturo Bargaran"};

        private void cmbProducto_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtprecio.Text = precio[cmbProducto.SelectedIndex].ToString();
        }

        private void Form2_Load(object sender, EventArgs e)
        {   // estableciendo el formato del ListView
            listView1.View = View.Details;
            listView1.GridLines = true;
            listView1.FullRowSelect = true;

            //columnas
            listView1.Columns.Add("Productos",180,HorizontalAlignment.Left);
            listView1.Columns.Add("Precio", 70, HorizontalAlignment.Left);
            listView1.Columns.Add("Cantidad", 60, HorizontalAlignment.Left);
            listView1.Columns.Add("Total", 80, HorizontalAlignment.Left);
             //cargando los combobox
            cmbcliente.Items.AddRange(clientes);
            cmbProducto.Items.AddRange(productos);
        }
        
        private void cmdAgregar_Click(object sender, EventArgs e)
        {
            //if(Convert.ToInt16(numericUpDown1.Value)==0)
            if (Convert.ToInt16(numericUpDown1.Value) == 0)
            {
            MessageBox.Show ("Seleccione Una Cantidad", "Validacion",
                MessageBoxButtons.OK, MessageBoxIcon.Warning);
            return; //salir del procedimiento
            }
            //recuperando la cantidad de elemtos , para buscar si el producto esta repetido.
            int cant = listView1.Items.Count;
            if (cant > 0)
            { 
            //buscar el elemento para actualizar
                for (int i = 0; i < cant; i++)
                { 
                    if(listView1.Items[i].Text == cmbProducto.Text)
                    {   //si ah sido encontrado
                        MessageBox.Show("El Producto Ya Existe", "Validacion");
                        //sumando la nueva cantidad
                        int cantidad = Convert.ToInt16(listView1.Items[i].SubItems[2].Text) +
                            Convert.ToInt16(numericUpDown1.Value);
                        //estableciendo la  nueva cantidad en el listview1
                        listView1.Items[i].SubItems[2].Text = cantidad.ToString();
                        //obteniendo el precio

                        double precio = Convert.ToDouble(listView1.Items[i].SubItems[1].Text);
                        //sacando el neuvo total de venta
                        double NTotal = precio * cantidad;
                        //estableciendo el nuevo total en el listview1
                        listView1.Items[i].SubItems[3].Text = NTotal.ToString();
                      totales();
                        return;//salir del procediemiento
                        
                    }
                }
            }
            ListViewItem ivitem;
            ivitem = listView1.Items.Add(cmbProducto.Text);
            ivitem.SubItems.Add(txtprecio.Text);
            ivitem.SubItems.Add(numericUpDown1.Value.ToString());
            double total = Convert.ToDouble(txtprecio.Text) * Convert.ToDouble(numericUpDown1.Value);
            ivitem.SubItems.Add(total.ToString());
            totales();            
        }
        void totales()
        { 
            double suma=0;
            for (int i = 0; i < listView1.Items.Count;i++ )
            {   //recuperando   los totales en subitems[3]
                suma += Convert.ToDouble(listView1.Items[i].SubItems[3].Text);
            }
            txtsubtotal.Text = suma.ToString("c");
            double igv = suma * 0.19;
            txtigv.Text = igv.ToString("c");
            double total = suma + igv;
            txttotal.Text = total.ToString("c");
        }

        private void cmdEliminar_Click(object sender, EventArgs e)
        {
            //Eliminar el producto seleccionado
            listView1.Items.RemoveAt(listView1.SelectedIndices[0]);
            totales();
        }

        private void cmdCancelar_Click(object sender, EventArgs e)
        {
            listView1.Items.Clear();
            totales();
        }

        private void cmsalir_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Desea Salir", "Venta De Productos",
                MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                Application.Exit();
            }
        }

        private void listView1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

          }
}