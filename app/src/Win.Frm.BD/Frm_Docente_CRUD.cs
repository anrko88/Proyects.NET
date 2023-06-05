using Business.Aplication_Docente;
using System;
using System.Collections.Generic;
using System.Windows.Forms;

namespace Win.Frm.BD
{
    public partial class Frm_Docente_CRUD : Form
    {
        public Frm_Docente_CRUD()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            comboBox1.Items.Add("Electronica");
            comboBox1.Items.Add("Sistemas");
            comboBox1.Items.Add("contabilidad");
            lblcodigo.Text = BDClientesApli3.GenerarCodigo();
            mostrarclientes();
        }

        void mostrarclientes()
        {
            List<BLClientesApli3> clientes = BDClientesApli3.ListarClientes();
            dataGridView1.DataSource = clientes;
            lblcantidad.Text = clientes.Count.ToString();
        }

        private void BtnNuevo_Click(object sender, EventArgs e)
        {
            txtnombres.Clear();
            comboBox1.Text = "";
            lblcodigo.Text = BDClientesApli3.GenerarCodigo();
        }

            private void btnGuardar_Click(object sender, EventArgs e)
        {
            BLClientesApli3 clientes=new BLClientesApli3();
            clientes.Codigo = lblcodigo.Text;
            clientes.Nombres = txtnombres.Text;
            clientes.Especialidad = comboBox1.Text;
            bool estado = BDClientesApli3.AgregarDocentes(clientes);

            if (estado)
            {
                MessageBox.Show("El cliente ah Sido Registrado");
                mostrarclientes();
            }
            else
            {
                MessageBox.Show("el Cliente no ah sido ingresado");
            }
        }

        private void btnBuscar_Click(object sender, EventArgs e)
        {
            try 
            {
                string codigo = dataGridView1[0,
                    dataGridView1.CurrentCell.RowIndex].Value.ToString();
                BLClientesApli3 clientes = BDClientesApli3.BuscarDocentes(codigo);
               // MessageBox.Show(codigo);
                lblcodigo.Text = clientes.Codigo;
                txtnombres.Text = clientes.Nombres;
                comboBox1.Text = clientes.Especialidad;
            }
            catch(Exception ex)
            {
                MessageBox.Show("Seleccione una fila del dataGridview1", ex.Message);
            }
        }

        private void btEliminar_Click(object sender, EventArgs e)
        {
            try 
            {
                string codigo = dataGridView1[0, dataGridView1.CurrentCell.RowIndex].
                    Value.ToString();
                BLClientesApli3 clientes = new BLClientesApli3();
                clientes.Codigo = codigo;
                bool estado = BDClientesApli3.EliminarDocentes(clientes);

                if (estado)
                {
                    MessageBox.Show("clientes ah sido eliminado");
                    mostrarclientes();
                }
            }
            catch(Exception ex)
            {  MessageBox.Show("Selecione una fila del dataGridview1", ex.Message);            }
        }

        private void btnActualizar_Click(object sender, EventArgs e)
        {
            try
            {
                string codigo = dataGridView1[0, dataGridView1.CurrentCell.RowIndex].Value.ToString();
                BLClientesApli3 clientes = new BLClientesApli3();
                clientes.Nombres = txtnombres.Text;
                clientes.Especialidad = comboBox1.Text;
                clientes.Codigo = lblcodigo.Text;
                bool estado = BDClientesApli3.UpdateDocentes(clientes);
                if (estado)
                {
                    MessageBox.Show("El cliente ah Sido Actualizado");
                    mostrarclientes();
                }
                else { MessageBox.Show("El Cliente no ah sido Actualizado"); }
            }
            catch(Exception ex)
            {
                MessageBox.Show("Seleccion Una Fila Del DatagridView1", ex.Message);
            }
            
        }


    }
}