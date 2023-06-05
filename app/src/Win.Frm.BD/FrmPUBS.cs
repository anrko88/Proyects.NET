using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm.BD
{
    public partial class FrmPUBS : Form
    {
        public FrmPUBS()
        {
            InitializeComponent();
        }
        Business.ClsAplicacion5_PUBS obj5 = new Business.ClsAplicacion5_PUBS();
        private void Form5_PUBS_Load(object sender, EventArgs e)
        {
            cmbpais.DataSource = obj5.Usp_BUBSPaises();
            cmbpais.DisplayMember = "country";
            cmbEditorial.Text = ""; dataGridView1.Visible = false;
        }
      
        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
           string pais = cmbpais.Text;
           this.cmbEditorial.DataSource = obj5.Usp_PUBSEditoriales(pais);
           cmbEditorial.DisplayMember = "pub_name";
           dataGridView1.ClearSelection(); dataGridView1.Visible = true;    
         }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
                string editorial = cmbEditorial.Text;
               dataGridView1.DataSource = obj5.Usp_PUBSLibros(editorial);
        }
    }
}