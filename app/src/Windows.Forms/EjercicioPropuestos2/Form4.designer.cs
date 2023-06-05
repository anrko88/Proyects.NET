namespace Win.Frm
{
    partial class Form4
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
            this.lbltext = new System.Windows.Forms.Label();
            this.btnEstablecer = new System.Windows.Forms.Button();
            this.btnRemover = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // lbltext
            // 
            this.lbltext.AutoSize = true;
            this.lbltext.Location = new System.Drawing.Point(42, 33);
            this.lbltext.Name = "lbltext";
            this.lbltext.Size = new System.Drawing.Size(196, 52);
            this.lbltext.TabIndex = 0;
            this.lbltext.Text = "Para Probar El Miembro del Formulario,\r\nintente minimizar este formulario cuando\r" +
                "\nel segundo formulario sea su propietario,\r\nminimize este formulario cuando";
            // 
            // btnEstablecer
            // 
            this.btnEstablecer.Location = new System.Drawing.Point(12, 138);
            this.btnEstablecer.Name = "btnEstablecer";
            this.btnEstablecer.Size = new System.Drawing.Size(118, 36);
            this.btnEstablecer.TabIndex = 1;
            this.btnEstablecer.Text = "Establecer Propietario";
            this.btnEstablecer.UseVisualStyleBackColor = true;
            this.btnEstablecer.Click += new System.EventHandler(this.btnEstablecer_Click);
            // 
            // btnRemover
            // 
            this.btnRemover.Location = new System.Drawing.Point(162, 138);
            this.btnRemover.Name = "btnRemover";
            this.btnRemover.Size = new System.Drawing.Size(118, 36);
            this.btnRemover.TabIndex = 2;
            this.btnRemover.Text = "Remover Propietario";
            this.btnRemover.UseVisualStyleBackColor = true;
            this.btnRemover.Click += new System.EventHandler(this.btnRemover_Click);
            // 
            // Form4
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(292, 191);
            this.Controls.Add(this.btnRemover);
            this.Controls.Add(this.btnEstablecer);
            this.Controls.Add(this.lbltext);
            this.Name = "Form4";
            this.Text = "Propietario";
            this.Load += new System.EventHandler(this.Form4_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lbltext;
        private System.Windows.Forms.Button btnEstablecer;
        private System.Windows.Forms.Button btnRemover;
    }
}