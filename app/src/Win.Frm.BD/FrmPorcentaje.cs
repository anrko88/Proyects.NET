using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm.BD
{
    public partial class FrmPorcentaje : Form
    {
        public FrmPorcentaje()
        {
            InitializeComponent();
        }
        Business.ClsAplicacion7 obj7 = new Business.ClsAplicacion7();

        private void Form7_Load(object sender, EventArgs e)
        {
            dataGridView1.DataSource = obj7.Porcentaje();
        }
    }
}