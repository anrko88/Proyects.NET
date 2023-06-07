namespace Win.Frm.BD
{
    partial class FrmCountriesCustomerOrder
    {
        /// <summary>
        /// Variable del diseñador requerida.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Limpiar los recursos que se estén utilizando.
        /// </summary>
        /// <param name="disposing">true si los recursos administrados se deben eliminar; false en caso contrario, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Código generado por el Diseñador de Windows Forms

        /// <summary>
        /// Método necesario para admitir el Diseñador. No se puede modificar
        /// el contenido del método con el editor de código.
        /// </summary>
        private void InitializeComponent()
        {
            this.DataGridView1 = new System.Windows.Forms.DataGridView();
            this.ListBox1 = new System.Windows.Forms.ListBox();
            this.ComboBox1 = new System.Windows.Forms.ComboBox();
            this.LBLCANT = new System.Windows.Forms.Label();
            this.LBLVENTATOTAL = new System.Windows.Forms.Label();
            this.Label5 = new System.Windows.Forms.Label();
            this.Label4 = new System.Windows.Forms.Label();
            this.Label2 = new System.Windows.Forms.Label();
            this.Label1 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.DataGridView1)).BeginInit();
            this.SuspendLayout();
            // 
            // DataGridView1
            // 
            this.DataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.DataGridView1.Location = new System.Drawing.Point(12, 208);
            this.DataGridView1.Name = "DataGridView1";
            this.DataGridView1.Size = new System.Drawing.Size(480, 150);
            this.DataGridView1.TabIndex = 21;
            // 
            // ListBox1
            // 
            this.ListBox1.FormattingEnabled = true;
            this.ListBox1.Location = new System.Drawing.Point(12, 76);
            this.ListBox1.Name = "ListBox1";
            this.ListBox1.Size = new System.Drawing.Size(395, 95);
            this.ListBox1.TabIndex = 20;
            this.ListBox1.SelectedIndexChanged += new System.EventHandler(this.ListBox1_SelectedIndexChanged);
            // 
            // ComboBox1
            // 
            this.ComboBox1.FormattingEnabled = true;
            this.ComboBox1.Location = new System.Drawing.Point(12, 25);
            this.ComboBox1.Name = "ComboBox1";
            this.ComboBox1.Size = new System.Drawing.Size(217, 21);
            this.ComboBox1.TabIndex = 19;
            this.ComboBox1.SelectedIndexChanged += new System.EventHandler(this.ComboBox1_SelectedIndexChanged);
            // 
            // LBLCANT
            // 
            this.LBLCANT.AutoSize = true;
            this.LBLCANT.Location = new System.Drawing.Point(187, 60);
            this.LBLCANT.Name = "LBLCANT";
            this.LBLCANT.Size = new System.Drawing.Size(55, 13);
            this.LBLCANT.TabIndex = 18;
            this.LBLCANT.Text = "LBLCANT";
            // 
            // LBLVENTATOTAL
            // 
            this.LBLVENTATOTAL.AutoSize = true;
            this.LBLVENTATOTAL.Location = new System.Drawing.Point(132, 371);
            this.LBLVENTATOTAL.Name = "LBLVENTATOTAL";
            this.LBLVENTATOTAL.Size = new System.Drawing.Size(97, 13);
            this.LBLVENTATOTAL.TabIndex = 17;
            this.LBLVENTATOTAL.Text = "LBLVENTATOTAL";
            // 
            // Label5
            // 
            this.Label5.AutoSize = true;
            this.Label5.Location = new System.Drawing.Point(12, 371);
            this.Label5.Name = "Label5";
            this.Label5.Size = new System.Drawing.Size(112, 13);
            this.Label5.TabIndex = 14;
            this.Label5.Text = "TOTAL DE  VENTAS:";
            // 
            // Label4
            // 
            this.Label4.AutoSize = true;
            this.Label4.Location = new System.Drawing.Point(12, 192);
            this.Label4.Name = "Label4";
            this.Label4.Size = new System.Drawing.Size(344, 13);
            this.Label4.TabIndex = 13;
            this.Label4.Text = "MOSTRAR LAS 5 ORDENES  CON MAYOR VENTA DE UN CLIENTE";
            // 
            // Label2
            // 
            this.Label2.AutoSize = true;
            this.Label2.Location = new System.Drawing.Point(12, 60);
            this.Label2.Name = "Label2";
            this.Label2.Size = new System.Drawing.Size(172, 13);
            this.Label2.TabIndex = 16;
            this.Label2.Text = "MOSTRAR CLIENTES POR PAIS:";
            // 
            // Label1
            // 
            this.Label1.AutoSize = true;
            this.Label1.Location = new System.Drawing.Point(12, 9);
            this.Label1.Name = "Label1";
            this.Label1.Size = new System.Drawing.Size(175, 13);
            this.Label1.TabIndex = 15;
            this.Label1.Text = "MOSTRAR PAISES DE CLIENTES";
            // 
            // Form7
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(508, 400);
            this.Controls.Add(this.DataGridView1);
            this.Controls.Add(this.ListBox1);
            this.Controls.Add(this.ComboBox1);
            this.Controls.Add(this.LBLCANT);
            this.Controls.Add(this.LBLVENTATOTAL);
            this.Controls.Add(this.Label5);
            this.Controls.Add(this.Label4);
            this.Controls.Add(this.Label2);
            this.Controls.Add(this.Label1);
            this.Name = "Form7";
            this.Text = "MANEJO DE COMPONENTES (NORTHWIND)";
            this.Load += new System.EventHandler(this.Form7_Load);
            ((System.ComponentModel.ISupportInitialize)(this.DataGridView1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        internal System.Windows.Forms.DataGridView DataGridView1;
        internal System.Windows.Forms.ListBox ListBox1;
        internal System.Windows.Forms.ComboBox ComboBox1;
        internal System.Windows.Forms.Label LBLCANT;
        internal System.Windows.Forms.Label LBLVENTATOTAL;
        internal System.Windows.Forms.Label Label5;
        internal System.Windows.Forms.Label Label4;
        internal System.Windows.Forms.Label Label2;
        internal System.Windows.Forms.Label Label1;
    }
}