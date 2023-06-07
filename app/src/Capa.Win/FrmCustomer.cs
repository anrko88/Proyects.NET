using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Capa.Entidad;
using Capa.Negocio;

namespace Capa.Win
{
    public partial class FrmCustomer : Form
    {
        public FrmCustomer()
        {
            InitializeComponent();
        }
        Capa.Entidad.en_anrko objE = new Capa.Entidad.en_anrko();
        Capa.Negocio.ne_anrko objN = new Capa.Negocio.ne_anrko();
        private void radioButton1_CheckedChanged(object sender, EventArgs e)
        {
            objE.Letra = "A-C";           
            listBox1.DataSource = ne_anrko.LetraCustomersNEG(objE);
            listBox1.DisplayMember = "companyname";
        }

        private void radioButton2_CheckedChanged(object sender, EventArgs e)
        {
            objE.Letra = "E-G";           
            listBox1.DataSource = ne_anrko.LetraCustomersNEG(objE);
            listBox1.DisplayMember = "companyname";
        }

        private void radioButton3_CheckedChanged(object sender, EventArgs e)
        {
             objE.Letra = "H-K";          
            listBox1.DataSource = ne_anrko.LetraCustomersNEG(objE);
            listBox1.DisplayMember = "companyname";
        }

        private void radioButton4_CheckedChanged(object sender, EventArgs e)
        {
             objE.Letra = "L-O";            
            listBox1.DataSource = ne_anrko.LetraCustomersNEG(objE);
            listBox1.DisplayMember = "companyname";
        }

        private void radioButton5_CheckedChanged(object sender, EventArgs e)
        {
            objE.Letra = "P-S";            
            listBox1.DataSource = ne_anrko.LetraCustomersNEG(objE);
            listBox1.DisplayMember = "companyname";
        }

        private void radioButton6_CheckedChanged(object sender, EventArgs e)
        {
            objE.Letra = "T-Z";            
            listBox1.DataSource = ne_anrko.LetraCustomersNEG(objE);
            listBox1.DisplayMember = "companyname";
        }

        private void button1_Click(object sender, EventArgs e)
        {
            ListView1();
            objE.Letra = listBox1.Text;
            objE.Fecha1 = maskedTextBox1.Text;
            objE.Fecha2 = maskedTextBox2.Text;
            listView1.Items.Clear();
            DataTable tbl = new DataTable();
            tbl = ne_anrko.FechaNEG(objE);

            for (int i = 0; i < tbl.Rows.Count; i++)
            {
                ListViewItem ListView;
                ListView = listView1.Items.Add(tbl.Rows[i][0].ToString());
                ListView.SubItems.Add(tbl.Rows[i][1].ToString());
                ListView.SubItems.Add(tbl.Rows[i][2].ToString());
                ListView.SubItems.Add(tbl.Rows[i][3].ToString());
                ListView.SubItems.Add(tbl.Rows[i][4].ToString());
            }
        }

        private void listView1_Click(object sender, EventArgs e)
        {
            listView2.Clear();            
            int orden = Convert.ToInt16(listView1.Items[listView1.SelectedIndices[0]].SubItems[0].Text);
            objE.Orderid = orden;
            DataTable tbl = new DataTable();
            tbl = ne_anrko.DEtalleVentaNEG(objE);
            for (int i = 0; i < tbl.Rows.Count; i++)
            {
                ListViewItem lstv;
                lstv = listView2.Items.Add(tbl.Rows[i][0].ToString());
                lstv.SubItems.Add(tbl.Rows[i][1].ToString());
                lstv.SubItems.Add(tbl.Rows[i][2].ToString());
                lstv.SubItems.Add(tbl.Rows[i][3].ToString());
                lstv.SubItems.Add(tbl.Rows[i][4].ToString());
            }
            ListView2();
        }

         void ListView1()
        {
            listView1.View = View.Details;
            listView1.GridLines = true;
            listView1.Columns.Add("OrderId", 50, HorizontalAlignment.Center);
            listView1.Columns.Add("ShippedDate", 150, HorizontalAlignment.Center);
            listView1.Columns.Add("Total_Venta", 100, HorizontalAlignment.Center);
            listView1.Columns.Add("Dias_Envio", 100, HorizontalAlignment.Center);
            listView1.Columns.Add("Estado_Envio", 150, HorizontalAlignment.Center);
        }
        void ListView2()
        {
            listView2.View = View.Details;
            listView2.GridLines = true;
            listView2.Columns.Add("ProductID", 50, HorizontalAlignment.Center);
            listView2.Columns.Add("ProductName", 150, HorizontalAlignment.Center);
            listView2.Columns.Add("UnitPrice", 100, HorizontalAlignment.Center);
            listView2.Columns.Add("Quantity", 100, HorizontalAlignment.Center);
            listView2.Columns.Add("total", 150, HorizontalAlignment.Center);
        }

       }
        
}
/*    
        04/07/1996      04/10/1997
 
 */