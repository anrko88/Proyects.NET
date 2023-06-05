using System;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class Frm1 : Form
    {
        public Frm1()
        {
            InitializeComponent();
        }

        private void button1_TextChanged(object sender, EventArgs e)
        {
           
        }
       
        private void MostrarMensaje(object sender, EventArgs e)
        {
            label1.Text = "Mi Primer Programa";
        }

        private void BtnForm2_Click(object sender, EventArgs e)
        {
            Frm2 Frm = new Frm2();
            Frm.Show();
            this.Hide();
        }

        private void BtnSalir_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Desea Salir", "Aplicacion",
                MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                Application.Exit();//salir de la aplicacion
        }

        private void button2_Click(object sender, EventArgs e)
        {
            Form_TiposDatos Frm = new Form_TiposDatos();
            Frm.Show();
        }

        private void BtnForm3_Click(object sender, EventArgs e)
        {
            Frm3 Frm = new Frm3();
            Frm.Show();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            Frm1 Frm = new Frm1();
            Frm.Text = " ***  Form C# *** ";
            
        }
    }
}