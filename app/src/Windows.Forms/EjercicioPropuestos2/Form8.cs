using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class Form8 : Form
    {
        public Form8()
        {
            InitializeComponent();
        }

        private void btnDeclaringVariables_Click(object sender, EventArgs e)
        {
            int intValue1 = 0;
            MessageBox.Show(intValue1.ToString());
        }

        private void btnStringVariables_Click(object sender, EventArgs e)
        {
            string strNombrecompleto = "Robert Vivar";
            int intLocEspacio;          //LOCALIZAR EL ESPACIO
            string strPrimerNombre;
            string strUltimoNombre;

            //OBTENIEDNO EL INDICE DEL ESPACIO DEL NOMBRE
            intLocEspacio = strNombrecompleto.IndexOf(" ");

            //USANDO EL INDICE DEL ESPACIO PARA OBTENER EL PRIMER Y ULTIMO NOMBRE
            strPrimerNombre = strNombrecompleto.Substring(0, intLocEspacio);
            strUltimoNombre = strNombrecompleto.Substring(intLocEspacio + 1);

            //MOSTRANDO EL PRIMER Y ULTIMO NOMBRE
            MessageBox.Show("El primer nombre es :" + strPrimerNombre  + 
                "\nEl ultimo Nombre es : " + strUltimoNombre);
        }

        private void btnAssigningVariables_Click(object sender, EventArgs e)
        {
            int inValue1 = 3;
            int intValue2;

            intValue2 = inValue1 * 5;

            MessageBox.Show(intValue2.ToString());
        }

        private void btnConvertingTypes_Click(object sender, EventArgs e)
        {
            double dblValor = 2.7;
            int intValorTotal1;
            int intValorTotal2;

            //    PRIMERA FORMA DE CONVERSION EXPLICITA
            intValorTotal1 = (int)dblValor;

            MessageBox.Show(intValorTotal1.ToString());

            //  LA SEGUNDA FORMA ES PARA EL USO DE LOS METODOS DE CLASES DE CONVERT
            intValorTotal2 = Convert.ToInt32((dblValor));

            MessageBox.Show(intValorTotal2.ToString());

        }

        enum Months
        {
            Enero, Febrero, Marzo, Abril, Mayo, Junio, Julio, Agosto,
            Septiembre, Octubre, Noviembre, Diciembre
        };

        private void btnEnumerations_Click(object sender, EventArgs e)
        {
            MessageBox.Show(Months.Abril.ToString());
        }
        const string BakeTemp = "450º";

        private void btnConstantes_Click(object sender, EventArgs e)
        {
            string strMessage = "The Temperatura deberia de ser para : " + BakeTemp;
            MessageBox.Show(strMessage);
        }

        

    }
}