using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class FormApl_6 : Form
    {
        public FormApl_6()
        {
            InitializeComponent();
        }
      
        string []lista1 =  new string []{};
                
        private void Form7_Load(object sender, EventArgs e)
        {
             listBox1.Items.Clear();
             Random rnd = new Random();
             //Random rnd = new Random(DateTime.Now.Millisecond);            
           
            for (int i = 0; i <=9; i++)
            {
               int num = rnd.Next(100);
                //MessageBox.Show(Convert.ToString(num));
                listBox1.Items.Add(num);                
            }
            Llenar();
        }
      
        void Llenar()
        {
            lbl1.Text = "Elementos :" + listBox1.Items.Count; ;
            lbl2.Text = "Elementos :" + listBox2.Items.Count; ;
        }

        void Mensaje()
        {
             MessageBox.Show("Seleccione Un Numero De La Lista", "Validacion",
                 MessageBoxButtons.OK, MessageBoxIcon.Warning);
        }

        private void Btn01_Click(object sender, EventArgs e)
        {   
       //MessageBox.Show(Convert.ToString(listBox1.SelectedIndex+1));  //=>> 0

             if (listBox1.SelectedIndex >= 0)
              {                
                listBox2.Items.Add(listBox1.SelectedItem);
                listBox1.Items.Remove(listBox1.SelectedItem);
                Llenar();
            }
            else
            {
                Mensaje();
            }
        }                       
        
        private void Btn03_Click(object sender, EventArgs e)
        {
            if (listBox2.SelectedIndex >= 0)
            {
                listBox1.Items.Add(listBox2.SelectedItem);
                listBox2.Items.Remove(listBox2.SelectedItem);
                Llenar();
            }
            else
            {
                Mensaje();
            }
      }

        private void Btn02_Click(object sender, EventArgs e)
        {
            MessageBox.Show(Convert.ToString(listBox1.Items.Add(listBox1.SelectedValue)));  //=>> 0
            //if (listBox1.SelectedIndex >= 0)
            //{
            //    listBox2.Items.Add(listBox1.SelectedItem);
            //}
        }

        private void Btn04_Click(object sender, EventArgs e)
        {

        }       

      

    }
}