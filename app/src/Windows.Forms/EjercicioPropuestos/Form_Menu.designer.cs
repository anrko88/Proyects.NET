namespace Win.Frm
{
    partial class Form_Menu
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
            this.btnForm2 = new System.Windows.Forms.Button();
            this.btnForm3 = new System.Windows.Forms.Button();
            this.btnForm4 = new System.Windows.Forms.Button();
            this.btnForm5 = new System.Windows.Forms.Button();
            this.btnForm6 = new System.Windows.Forms.Button();
            this.btnElaborarProforma = new System.Windows.Forms.Button();
            this.btnForm7 = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // btnForm2
            // 
            this.btnForm2.Location = new System.Drawing.Point(12, 12);
            this.btnForm2.Name = "btnForm2";
            this.btnForm2.Size = new System.Drawing.Size(112, 39);
            this.btnForm2.TabIndex = 0;
            this.btnForm2.Text = "APLICACION 1";
            this.btnForm2.UseVisualStyleBackColor = true;
            this.btnForm2.Click += new System.EventHandler(this.btnForm2_Click);
            // 
            // btnForm3
            // 
            this.btnForm3.Location = new System.Drawing.Point(139, 12);
            this.btnForm3.Name = "btnForm3";
            this.btnForm3.Size = new System.Drawing.Size(112, 39);
            this.btnForm3.TabIndex = 1;
            this.btnForm3.Text = "APLICACION 2";
            this.btnForm3.UseVisualStyleBackColor = true;
            this.btnForm3.Click += new System.EventHandler(this.btnForm3_Click);
            // 
            // btnForm4
            // 
            this.btnForm4.Location = new System.Drawing.Point(274, 12);
            this.btnForm4.Name = "btnForm4";
            this.btnForm4.Size = new System.Drawing.Size(112, 39);
            this.btnForm4.TabIndex = 2;
            this.btnForm4.Text = "APLICACION 3";
            this.btnForm4.UseVisualStyleBackColor = true;
            this.btnForm4.Click += new System.EventHandler(this.btnForm4_Click);
            // 
            // btnForm5
            // 
            this.btnForm5.Location = new System.Drawing.Point(12, 63);
            this.btnForm5.Name = "btnForm5";
            this.btnForm5.Size = new System.Drawing.Size(112, 39);
            this.btnForm5.TabIndex = 3;
            this.btnForm5.Text = "Matricula De ALumnos";
            this.btnForm5.UseVisualStyleBackColor = true;
            this.btnForm5.Click += new System.EventHandler(this.btnForm5_Click);
            // 
            // btnForm6
            // 
            this.btnForm6.Location = new System.Drawing.Point(139, 63);
            this.btnForm6.Name = "btnForm6";
            this.btnForm6.Size = new System.Drawing.Size(112, 39);
            this.btnForm6.TabIndex = 4;
            this.btnForm6.Text = "Tabla De Multiplicar";
            this.btnForm6.UseVisualStyleBackColor = true;
            this.btnForm6.Click += new System.EventHandler(this.btnForm6_Click);
            // 
            // btnElaborarProforma
            // 
            this.btnElaborarProforma.Location = new System.Drawing.Point(90, 108);
            this.btnElaborarProforma.Name = "btnElaborarProforma";
            this.btnElaborarProforma.Size = new System.Drawing.Size(215, 24);
            this.btnElaborarProforma.TabIndex = 5;
            this.btnElaborarProforma.Text = "ELABORAR PROFORMA";
            this.btnElaborarProforma.UseVisualStyleBackColor = true;
            this.btnElaborarProforma.Click += new System.EventHandler(this.btnElaborarProforma_Click);
            // 
            // btnForm7
            // 
            this.btnForm7.Location = new System.Drawing.Point(271, 63);
            this.btnForm7.Name = "btnForm7";
            this.btnForm7.Size = new System.Drawing.Size(112, 39);
            this.btnForm7.TabIndex = 6;
            this.btnForm7.Text = "Intercambio De Numeros";
            this.btnForm7.UseVisualStyleBackColor = true;
            this.btnForm7.Click += new System.EventHandler(this.btnForm7_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(395, 149);
            this.Controls.Add(this.btnForm7);
            this.Controls.Add(this.btnElaborarProforma);
            this.Controls.Add(this.btnForm6);
            this.Controls.Add(this.btnForm5);
            this.Controls.Add(this.btnForm4);
            this.Controls.Add(this.btnForm3);
            this.Controls.Add(this.btnForm2);
            this.MaximumSize = new System.Drawing.Size(403, 183);
            this.MinimumSize = new System.Drawing.Size(403, 183);
            this.Name = "Form1";
            this.Text = "Ejercicios ProPuestos";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button btnForm2;
        private System.Windows.Forms.Button btnForm3;
        private System.Windows.Forms.Button btnForm4;
        private System.Windows.Forms.Button btnForm5;
        private System.Windows.Forms.Button btnForm6;
        private System.Windows.Forms.Button btnElaborarProforma;
        private System.Windows.Forms.Button btnForm7;
    }
}