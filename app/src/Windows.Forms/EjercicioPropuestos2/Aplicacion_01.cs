using System;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class Aplicacion_01 : Form
    {
        public Aplicacion_01()
        {
            InitializeComponent();
        }
        string[] arrayproductos;
        string[] arraycategorias;

        private void Form1_Load(object sender, EventArgs e)
        {
            comboBox1.Items.Add("Dispositivos De Entrada");
            comboBox1.Items.Add("Dispositivos De Salida");
        }
        
        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (comboBox1.SelectedIndex)
            {
                case 0: //Dispositivo de entrada
                    {
                        string[] categorias = new string[] { "Camaras digitales", "Mouse" };
                        //copiar el arreglo de categorias si elñ arreglo arraycate...
                        arraycategorias = (string[])categorias.Clone();
                        break;
                    }
                case 1: //   dispositivo de salida
                    {
                        string[] categorias = new string[] { "Inyecion de tintas", "Laser" };
                        arraycategorias = (string[])categorias.Clone();
                        break;
                    }
            }
            listBox1.Items.Clear();
            listBox1.Items.AddRange(arraycategorias);
        }

        private void Seleccione(object sender, EventArgs e)
        {
            switch (comboBox1.SelectedIndex)
            {
                case 0://Dispositivo de entrada
                    {
                        switch (listBox1.SelectedIndex)
                        {
                            case 0:// Camara Digital
                                {
                                    string[] productos = new string[] { "Photo PC", "Sony 700", "Panasonic HD" };
                                    arrayproductos = (string[])productos.Clone();
                                    break;

                                }
                            case 1:// Mouse
                                {
                                    string[] productos = new string[] { "Logitech", "Mouse Phone", "Easy Mouse" };
                                    arrayproductos = (string[])productos.Clone();
                                    break;

                                }
                        }
                        checkedListBox1.Items.Clear();
                        checkedListBox1.Items.AddRange(arrayproductos);
                        break;
                    }
            }
        }                  


        private void button1_Click(object sender, EventArgs e)
        {
            string mensaje = "";
            foreach (object item in checkedListBox1.CheckedItems)
            {
                mensaje += item.ToString() + ",";
            }
            if (mensaje == "")
            {
                MessageBox.Show("Seleccione Un Elemento");
                return;     //salir del procedimiento
            }
            MessageBox.Show(mensaje.Substring(0, mensaje.Length - 1));
        }

        private void button2_Click(object sender, EventArgs e)
        {
        Form form2 =new Aplicacion_02();
        form2.Show();
        }
        
    }
}