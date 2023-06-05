using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm.BD
{
    public partial class FrmCountry : Form
    {
        public FrmCountry()
        {
            InitializeComponent();
        }
        Business.ClsAplicacion3 obj2 = new Business.ClsAplicacion3();

        private void Form2_Load(object sender, EventArgs e)
        {
            CmbPais.DataSource = obj2.MostrarPaises();
            CmbPais.DisplayMember = "country";
            CmbPais.ValueMember = "country";
            dataGridView1.ClearSelection();
            CmbPais.Text = "";
            dataGridView1.Visible  = false;          
        }
        private void Clip(object sender, EventArgs e)
        {                         
           try 
            {
                dataGridView1.Visible = true;    
                string pais = CmbPais.Text;
                DataTable tbl = obj2.OrdenesEmitidasPorPais(pais );
                dataGridView1.DataSource = tbl;
            }
            catch(Exception ex)
            {
                ex.ToString();
            }
            //int OrderID = int.Parse(CmbPais.SelectedValue.ToString());
           // DataTable tbl = obj2.OrdenesEmitidasPorPais(OrderID);
           //  MessageBox.Show(Convert.ToString(CmbPais.Text));
        }
               

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            int Orden = int.Parse(dataGridView1[0, e.RowIndex].Value.ToString());
            dataGridView2.DataSource = obj2.DetalleOrden(Orden);
        }
        
        private void btnMenu_Click(object sender, EventArgs e)
        {
            Frm_MenuBD clip = new Frm_MenuBD();
            clip.Show();
            Hide();
        }
        
    }
}