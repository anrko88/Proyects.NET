namespace Win.Frm.BD
{
    partial class FrmCategoryProduct
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
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.label5 = new System.Windows.Forms.Label();
            this.listView2 = new System.Windows.Forms.ListView();
            this.label4 = new System.Windows.Forms.Label();
            this.BtnGrabar = new System.Windows.Forms.Button();
            this.lblstocktotal = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.listView1 = new System.Windows.Forms.ListView();
            this.btnMostrar = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.txtstock = new System.Windows.Forms.NumericUpDown();
            this.label1 = new System.Windows.Forms.Label();
            this.GroupBox1 = new System.Windows.Forms.GroupBox();
            this.OptTZ = new System.Windows.Forms.RadioButton();
            this.OptPS = new System.Windows.Forms.RadioButton();
            this.OptLO = new System.Windows.Forms.RadioButton();
            this.OptHK = new System.Windows.Forms.RadioButton();
            this.OptEG = new System.Windows.Forms.RadioButton();
            this.OptAD = new System.Windows.Forms.RadioButton();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtstock)).BeginInit();
            this.GroupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // dataGridView1
            // 
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Location = new System.Drawing.Point(12, 422);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.Size = new System.Drawing.Size(508, 97);
            this.dataGridView1.TabIndex = 26;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Arial", 9F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Underline))), System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.Location = new System.Drawing.Point(16, 403);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(236, 15);
            this.label5.TabIndex = 25;
            this.label5.Text = "MOSTRAR LOS PRODUCTOS GRABADOS";
            // 
            // listView2
            // 
            this.listView2.Location = new System.Drawing.Point(13, 235);
            this.listView2.Name = "listView2";
            this.listView2.Size = new System.Drawing.Size(507, 106);
            this.listView2.TabIndex = 24;
            this.listView2.UseCompatibleStateImageBehavior = false;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Arial", 9F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Underline))), System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.Location = new System.Drawing.Point(10, 64);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(152, 15);
            this.label4.TabIndex = 23;
            this.label4.Text = "LISTADO DE CATEGORIAS";
            // 
            // BtnGrabar
            // 
            this.BtnGrabar.Location = new System.Drawing.Point(36, 363);
            this.BtnGrabar.Name = "BtnGrabar";
            this.BtnGrabar.Size = new System.Drawing.Size(485, 37);
            this.BtnGrabar.TabIndex = 22;
            this.BtnGrabar.Text = "GRABAR PRODUCTOS MOSTRADOS EN EL LISTVIEW2 EN LA TABLA EN LA Tabla ProductoVendid" +
                "osExamen";
            this.BtnGrabar.UseVisualStyleBackColor = true;
            this.BtnGrabar.Click += new System.EventHandler(this.BtnGrabar_Click);
            // 
            // lblstocktotal
            // 
            this.lblstocktotal.AutoSize = true;
            this.lblstocktotal.Location = new System.Drawing.Point(438, 347);
            this.lblstocktotal.Name = "lblstocktotal";
            this.lblstocktotal.Size = new System.Drawing.Size(63, 13);
            this.lblstocktotal.TabIndex = 21;
            this.lblstocktotal.Text = "lblstocktotal";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Comic Sans MS", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.Location = new System.Drawing.Point(238, 344);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(194, 16);
            this.label3.TabIndex = 20;
            this.label3.Text = "Total De Stock De entrada -->";
            // 
            // listView1
            // 
            this.listView1.Location = new System.Drawing.Point(13, 82);
            this.listView1.Name = "listView1";
            this.listView1.Size = new System.Drawing.Size(280, 106);
            this.listView1.TabIndex = 19;
            this.listView1.UseCompatibleStateImageBehavior = false;
            // 
            // btnMostrar
            // 
            this.btnMostrar.Location = new System.Drawing.Point(297, 147);
            this.btnMostrar.Name = "btnMostrar";
            this.btnMostrar.Size = new System.Drawing.Size(111, 41);
            this.btnMostrar.TabIndex = 18;
            this.btnMostrar.Text = "Mostrar Producto Por Categorias";
            this.btnMostrar.UseVisualStyleBackColor = true;
            this.btnMostrar.Click += new System.EventHandler(this.btnMostrar_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Arial", 9F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Underline))), System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(12, 217);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(509, 15);
            this.label2.TabIndex = 17;
            this.label2.Text = "PRODUCTOS POR CATEGORIAS CUYO STOCK DE ENTRADA SEA MAYOR A LO INGRESADO";
            // 
            // txtstock
            // 
            this.txtstock.Location = new System.Drawing.Point(197, 194);
            this.txtstock.Name = "txtstock";
            this.txtstock.Size = new System.Drawing.Size(46, 20);
            this.txtstock.TabIndex = 16;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Comic Sans MS", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(16, 194);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(158, 16);
            this.label1.TabIndex = 15;
            this.label1.Text = "INGRESE SU SOTCK -->";
            // 
            // GroupBox1
            // 
            this.GroupBox1.Controls.Add(this.OptTZ);
            this.GroupBox1.Controls.Add(this.OptPS);
            this.GroupBox1.Controls.Add(this.OptLO);
            this.GroupBox1.Controls.Add(this.OptHK);
            this.GroupBox1.Controls.Add(this.OptEG);
            this.GroupBox1.Controls.Add(this.OptAD);
            this.GroupBox1.Font = new System.Drawing.Font("Tahoma", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.GroupBox1.Location = new System.Drawing.Point(12, 12);
            this.GroupBox1.Name = "GroupBox1";
            this.GroupBox1.Size = new System.Drawing.Size(396, 50);
            this.GroupBox1.TabIndex = 14;
            this.GroupBox1.TabStop = false;
            this.GroupBox1.Text = "Busqueda de Categorias por Rango de Letras";
            // 
            // OptTZ
            // 
            this.OptTZ.AutoSize = true;
            this.OptTZ.Location = new System.Drawing.Point(311, 21);
            this.OptTZ.Name = "OptTZ";
            this.OptTZ.Size = new System.Drawing.Size(44, 18);
            this.OptTZ.TabIndex = 5;
            this.OptTZ.TabStop = true;
            this.OptTZ.Text = "T-Z";
            this.OptTZ.UseVisualStyleBackColor = true;
            this.OptTZ.Click += new System.EventHandler(this.OptTZ_Click);
            // 
            // OptPS
            // 
            this.OptPS.AutoSize = true;
            this.OptPS.Location = new System.Drawing.Point(247, 21);
            this.OptPS.Name = "OptPS";
            this.OptPS.Size = new System.Drawing.Size(46, 18);
            this.OptPS.TabIndex = 4;
            this.OptPS.TabStop = true;
            this.OptPS.Text = "P-S";
            this.OptPS.UseVisualStyleBackColor = true;
            this.OptPS.Click += new System.EventHandler(this.OptPS_Click);
            // 
            // OptLO
            // 
            this.OptLO.AutoSize = true;
            this.OptLO.Location = new System.Drawing.Point(185, 21);
            this.OptLO.Name = "OptLO";
            this.OptLO.Size = new System.Drawing.Size(46, 18);
            this.OptLO.TabIndex = 3;
            this.OptLO.TabStop = true;
            this.OptLO.Text = "L-O";
            this.OptLO.UseVisualStyleBackColor = true;
            this.OptLO.Click += new System.EventHandler(this.OptLO_Click);
            // 
            // OptHK
            // 
            this.OptHK.AutoSize = true;
            this.OptHK.Location = new System.Drawing.Point(131, 21);
            this.OptHK.Name = "OptHK";
            this.OptHK.Size = new System.Drawing.Size(47, 18);
            this.OptHK.TabIndex = 2;
            this.OptHK.TabStop = true;
            this.OptHK.Text = "H-K";
            this.OptHK.UseVisualStyleBackColor = true;
            this.OptHK.Click += new System.EventHandler(this.OptHK_Click);
            // 
            // OptEG
            // 
            this.OptEG.AutoSize = true;
            this.OptEG.Location = new System.Drawing.Point(69, 21);
            this.OptEG.Name = "OptEG";
            this.OptEG.Size = new System.Drawing.Size(45, 18);
            this.OptEG.TabIndex = 1;
            this.OptEG.TabStop = true;
            this.OptEG.Text = "E-G";
            this.OptEG.UseVisualStyleBackColor = true;
            this.OptEG.Click += new System.EventHandler(this.OptEG_Click);
            // 
            // OptAD
            // 
            this.OptAD.AutoSize = true;
            this.OptAD.Location = new System.Drawing.Point(16, 21);
            this.OptAD.Name = "OptAD";
            this.OptAD.Size = new System.Drawing.Size(48, 18);
            this.OptAD.TabIndex = 0;
            this.OptAD.TabStop = true;
            this.OptAD.Text = "A-D";
            this.OptAD.UseVisualStyleBackColor = true;
            this.OptAD.Click += new System.EventHandler(this.OptAD_Click);
            // 
            // Form2
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(529, 531);
            this.Controls.Add(this.dataGridView1);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.listView2);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.BtnGrabar);
            this.Controls.Add(this.lblstocktotal);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.listView1);
            this.Controls.Add(this.btnMostrar);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.txtstock);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.GroupBox1);
            this.Name = "Form2";
            this.Text = "CONSULTA DE DATOS";
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtstock)).EndInit();
            this.GroupBox1.ResumeLayout(false);
            this.GroupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView dataGridView1;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.ListView listView2;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button BtnGrabar;
        private System.Windows.Forms.Label lblstocktotal;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.ListView listView1;
        private System.Windows.Forms.Button btnMostrar;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.NumericUpDown txtstock;
        private System.Windows.Forms.Label label1;
        internal System.Windows.Forms.GroupBox GroupBox1;
        internal System.Windows.Forms.RadioButton OptTZ;
        internal System.Windows.Forms.RadioButton OptPS;
        internal System.Windows.Forms.RadioButton OptLO;
        internal System.Windows.Forms.RadioButton OptHK;
        internal System.Windows.Forms.RadioButton OptEG;
        internal System.Windows.Forms.RadioButton OptAD;
    }
}