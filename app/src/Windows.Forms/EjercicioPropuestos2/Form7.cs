using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class Form7 : Form
    {
        public Form7()
        {
            InitializeComponent();
        }

      
        private void btnIf_Click(object sender, EventArgs e)
        {
            if (this.textBox1.Text == "Mostrar")
            {
                this.textBox2.Text = "Este Texto se Esta Mostrando";
                MessageBox.Show("Tambien se muestra aqui");
            }
        }

        private void btnIfElse_Click(object sender, EventArgs e)
        {
            if (this.textBox1.Text == "Mostrar")
                this.textBox2.Text = "Este Se Esta Mostrando";
            else
                this.textBox2.Text = "El Texto No Se Esta Mostrando";
        }

        private void btnSwitchCase_Click(object sender, EventArgs e)
        {
            switch (textBox1.Text)
            { 
                case "1":
                    textBox2.Text="Lunes";
                    break ;
                case "2":
                    textBox2.Text = "Martes";
                    break;
                case "3":
                    textBox2.Text = "Miercoles";
                    break;
                case "4":
                    textBox2.Text = "Jueves";
                    break;
                case "5":
                    textBox2.Text = "Viernes";
                    break;
            }
        }

        private void btnSwitchCaseDefault_Click(object sender, EventArgs e)
        {
            switch(textBox1.Text)
            {
                case "1":
                    textBox2.Text = "Lunes";
                    break;
                case "2":
                    textBox2.Text = "Martes";
                    break;
                case "3":
                    textBox2.Text = "Miercoles";
                    break;
                case "4":
                    textBox2.Text = "Jueves";
                    break;
                case "5":
                    textBox2.Text = "Viernes";
                    break;
                default:
                    textBox2.Text = "Fin De Semana";
                    break;
            }
        }

        private void btnFor_Click(object sender, EventArgs e)
        {
          //    MUESTRA LA FECHA AGREGANDO UN MES ADICIONAL
            for (int i = 1; i < 6; i++)
            {
                textBox1.Text += DateTime.Today.AddMonths(i).ToShortDateString() +
                    Environment.NewLine;
            }

        }

        private void btnForEach_Click(object sender, EventArgs e)
        {
            //  CAMBIA DE COLOR A LOS CONTROLES
            foreach (Control ctlCurr in this.Controls)
            {
                ctlCurr.ForeColor = Color.Red;
            }
        }

        private void btnDoAndWhile_Click(object sender, EventArgs e)
        {
            // Environment.NewLine ==> Salto De Linea
            int intCurr = Convert.ToInt32(this.textBox1.Text);
            textBox2.Text = "Usando do" + Environment.NewLine;

            do
            {
                this.textBox2.Text +=
                DateTime.Today.AddMonths(intCurr).ToShortDateString()+
                Environment.NewLine;
                intCurr++;
            }
            while (intCurr < 5);

            intCurr = Convert.ToInt32(this.textBox1.Text);
            textBox2.Text += "Usando while" + Environment.NewLine;

            while (intCurr < 5)
            {
                textBox2.Text += DateTime.Today.AddMonths(intCurr).ToShortDateString() +
                     Environment.NewLine;
                intCurr++;
            };
        }

        private void BtnUnhandledException_Click(object sender, EventArgs e)
        {
            //      SIN MANEJADOR DE ERRORES
            int intCurr = Convert.ToInt32(textBox1.Text);
            textBox2.Text = Convert.ToString(intCurr + 3);
         }

        private void btnTryCatch_Click(object sender, EventArgs e)
        {
            //  UTILIZANDO EL MANEJADOR DE ERRORES
            try
            {
                int intCurr = Convert.ToInt32(textBox1.Text);
                textBox2.Text = Convert.ToString (intCurr + 3);
            }
            catch
            { 
            //mostrando el erros
                textBox2.Text = "Exception Ocurrido";
            }
        }

        private void btnTryCatchFinally_Click(object sender, EventArgs e)
        {
            try
            {
                int intCurr = Convert.ToInt32(textBox1.Text);
                textBox2.Text = Convert.ToString(intCurr + 3);
            }
            catch
            {
                textBox2.Text = "Exception Ocurrido";
            }
            finally 
            {
                textBox2.Text += Environment.NewLine + "Completado";
            }
        }       

    }
}