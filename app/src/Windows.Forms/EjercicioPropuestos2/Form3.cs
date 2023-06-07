using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class Form3 : Form
    {
        public Form3()
        {
            InitializeComponent();
        }

        private void ctrlClick(object sender, EventArgs e)
        {
            Control ctrl = (Control)sender;
            //MessageBox.Show("You clicked :" + ctrl.Name);
            MessageBox.Show("Has Echo Click En el Control :" + ctrl.Name);
        }
    }
}