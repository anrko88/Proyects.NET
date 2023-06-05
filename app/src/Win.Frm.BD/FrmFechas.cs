using System;
using System.Windows.Forms;

namespace Win.Frm.BD
{
    public partial class FrmFechas : Form
    {
        public FrmFechas()
        {
            InitializeComponent();
        }

        Business.ClsAplicacion6 obj6 = new Business.ClsAplicacion6();        
        private void BtnMostrar_Click(object sender, EventArgs e)
        {         
            string fecha1 = maskedTextBox1.Text;
            string fecha2 = maskedTextBox2.Text;
            dataGridView1.DataSource = 
            obj6.MostrarConsultaDeFecha(fecha1.ToString(),fecha2.ToString() );
            lblCantidad.Text = dataGridView1.RowCount.ToString();            
         }              
}

       
  
}//