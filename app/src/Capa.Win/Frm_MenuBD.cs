using System;
using System.Windows.Forms;

namespace Capa.Win
{
    public partial class Frm_MenuBD : Form
    {
        public Frm_MenuBD()
        {
            InitializeComponent();
        }

        private void btnform1_Click(object sender, EventArgs e)
        {
            FrmProduct frm = new FrmProduct();
            frm.Show();
            Hide();
        }

        private void btnform2_Click(object sender, EventArgs e)
        {
            FrmProductOrder frm = new FrmProductOrder();
            frm.Show();
            Hide();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            FrmCustomer frm = new FrmCustomer();
            frm.Show();
            Hide();
        }
    }
}