using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class FormApl_5 : Form
    {
        public FormApl_5()
        {
            InitializeComponent();
        }

        private void BtnGenerar_Click(object sender, EventArgs e)
        {
            
            if (txtcolumnas.Text == "")
            {
                MessageBox.Show("Ingrese Un Numero", "Validacion",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            else
            {
                int num = Convert.ToInt16(txtcolumnas.Text);
                listView1.Clear();
                  
                listView1.Columns.Add("Multiplicadores", 90, HorizontalAlignment.Left);
                for (int multi = 1; multi <= num; multi++)
                {
                    ListViewItem iviTem;
                    listView1.View = View.Details;
                    listView1.GridLines = true;
                    listView1.FullRowSelect = true;
                   // listView1.Items.Add(Convert.ToString(multi));
                    listView1.Columns.Add(Convert.ToString(multi), 30, HorizontalAlignment.Center);
                    iviTem = listView1.Items.Add(Convert.ToString(multi));
                    for (int f = 0; f <= num; f++)
                    {
                        iviTem.SubItems.Add(Convert.ToString((multi) *
                            Convert.ToInt16(iviTem.SubItems.Count)));
                    }                  
                 }            
             }
        }
        private void btnSalir_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Desea Salir", "Formularios",
                          MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                Application.Exit();
            }
        }

        private void btnMenu_Click(object sender, EventArgs e)
        {
            Form_Menu Form1 = new Form_Menu();
            Form1.Show();
            Hide();
        }
        
        private void Form6_Load(object sender, EventArgs e)
        {
            txtcolumnas.Focus();
        }


       
    }
}
