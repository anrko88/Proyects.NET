using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Win.Frm
{
    public partial class Form4 : Form
    {
        public Form4()
        {
            InitializeComponent();
        }

        private Form4_OwnedForm frmOwned = new Form4_OwnedForm();

        private void Form4_Load(object sender, EventArgs e)
        {
            this.Show();
            frmOwned.Show();
        }
        private void btnEstablecer_Click(object sender, EventArgs e)
        {
            //this.AddOwnedForm(frmOwned);
            this.AddOwnedForm(frmOwned);
          // frmOwned.lbl = "Yo Soy el propietario";
        }

        private void btnRemover_Click(object sender, EventArgs e)
        {
            RemoveOwnedForm(frmOwned);
          //  frmOwned.= "Yo Soy Libre";
        }

        
    }
}