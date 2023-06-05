using Business.Aplication_Employees;
using System;
using System.Windows.Forms;

namespace Win.Frm.BD
{
    public partial class FrmEmployeed_CRUD : Form
    {
        public FrmEmployeed_CRUD()
        {
            InitializeComponent();
        }
        
        private void Form3_MantEmpl_Load(object sender, EventArgs e)
        {
            Cbopais.Items.Add("Peru");
            Cbopais.Items.Add("Brasil");
            Cbopais.Items.Add("Chile");
            Cbosexo.Items.Add("Femenino");
            Cbosexo.Items.Add("Masculino");
            Lblcodemp.Text = BDAplic3.GenerarCodigo();
            DataGridView1.DataSource = BDAplic3.listaClientes();
        }
        
        void Nuevo()
        {
            txtcodigo.Text = "";
            TxtNombres.Text = "";
            Cbopais.SelectedIndex = 0;
            Cbosexo.SelectedIndex = 0;
            MskfechaNaci.Text = "";
            TxtNombres.Focus();
        }

        private void Cmdnuevo_Click(object sender, EventArgs e)
        {

        }
        private void Cmdgrabar_Click(object sender, EventArgs e)
        {
            BEEmpleado empleados = new BEEmpleado();
        
            empleados.CodigoEmp = Lblcodemp.Text ;
            empleados.NombreEmp = TxtNombres.Text ;
            empleados.PaisEmp = Cbopais.Text;
            empleados.FechaNacEmp =MskfechaNaci.Text ;
            empleados.SexoEmp = Cbosexo.Text;
                
        }
        private void CmdEditar_Click(object sender, EventArgs e)
        {

        }
        private void CmdEliminar_Click(object sender, EventArgs e)
        {

        }

        private void CmdBusqueda_Click(object sender, EventArgs e)
        {

        }

        private void CmdCerrar_Click(object sender, EventArgs e)
        {

        }

      

     
    }
}