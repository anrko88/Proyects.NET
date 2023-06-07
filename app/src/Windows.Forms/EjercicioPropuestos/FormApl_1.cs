using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class FormApl_1 : Form
    {
        public FormApl_1()
        {
            InitializeComponent();
        }

        string[] artefactos = new string[] { "Televisor", "Teclado", "Impresora", "DVD", "Equipo" };
       
        private void Form2_Load(object sender, EventArgs e)
        {
            comboBox1.Focus();
            comboBox1.Items.AddRange(artefactos);
        }

        private void btnCalcular_Click(object sender, EventArgs e)
        {
           /*
            if(Convert.ToInt16(numericUpDown1.Value )==0 || 
                Convert.ToInt16(numericUpDown2.Value )==0 ) 
            {
                MessageBox.Show("Selecione Una Cantidad","Validacion",
                    MessageBoxButtons.OK ,MessageBoxIcon.Warning );*/
            if (comboBox1.Text == "")
            {
                MessageBox.Show("Selecione Un Artefacto", "Validacion",
                        MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            if (txtprecio.Text == "")
            {
                MessageBox.Show("Ingrese Precio", "Validacion",
                            MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            else
            {
                double cuotaInicial = Convert.ToDouble(txtprecio.Text) * 0.35;
                double saldo = Convert.ToDouble(txtprecio.Text) - cuotaInicial;
                double valorCuota = saldo / (Convert.ToDouble(NumCuotas.Value));

                txtcuotainicial.Text = cuotaInicial.ToString();
                txtsaldo.Text = saldo.ToString();
                txtvalorcuota.Text = valorCuota.ToString();
            }
               
                   
            }

        private void btnNuevo_Click(object sender, EventArgs e)
        {
            
            foreach (Control c in this.Controls )
            {
                if (c is TextBox)
                {
                    c.Text = "";
                    comboBox1.Text = "";
                    NumCantidad.Value = 1;
                    NumCuotas .Value= 1;                    
                }
            }
            comboBox1.Focus();
        }

        private void btnMenu_Click(object sender, EventArgs e)
        {
            Form_Menu Form1 =new Form_Menu() ;
            Form1.Show();
            Hide();
        }

        
          
        }
        

        
 }
