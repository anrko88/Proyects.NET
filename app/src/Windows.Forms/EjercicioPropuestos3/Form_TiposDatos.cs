using System;
using System.Drawing;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class Form_TiposDatos : Form
    {
        public Form_TiposDatos()
        {
            InitializeComponent();
        }

        private void Form3_Load(object sender, EventArgs e)
        {
            pictureBox1.Image = Image.FromFile("TiposDeDatos.jpg");
        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {
            Form_TiposDatos fromtd = new Form_TiposDatos();
            fromtd.Hide();
        }

        private void pictureBox1_MouseClick(object sender, MouseEventArgs e)
        {
        
        }
    }
}