namespace Win.Frm
{
    partial class Frm3
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
            this.Btnconvertir = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.txtmetros = new System.Windows.Forms.TextBox();
            this.lblresultado = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // Btnconvertir
            // 
            this.Btnconvertir.Location = new System.Drawing.Point(82, 59);
            this.Btnconvertir.Name = "Btnconvertir";
            this.Btnconvertir.Size = new System.Drawing.Size(210, 23);
            this.Btnconvertir.TabIndex = 0;
            this.Btnconvertir.Text = "button1";
            this.Btnconvertir.UseVisualStyleBackColor = true;
            this.Btnconvertir.Click += new System.EventHandler(this.Btnconvertir_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.Black;
            this.label1.Location = new System.Drawing.Point(41, 32);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(41, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "label1";
            // 
            // txtmetros
            // 
            this.txtmetros.Location = new System.Drawing.Point(237, 29);
            this.txtmetros.Name = "txtmetros";
            this.txtmetros.Size = new System.Drawing.Size(68, 20);
            this.txtmetros.TabIndex = 3;
            // 
            // lblresultado
            // 
            this.lblresultado.AutoSize = true;
            this.lblresultado.Font = new System.Drawing.Font("Comic Sans MS", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblresultado.ForeColor = System.Drawing.Color.Red;
            this.lblresultado.Location = new System.Drawing.Point(98, 97);
            this.lblresultado.Name = "lblresultado";
            this.lblresultado.Size = new System.Drawing.Size(47, 19);
            this.lblresultado.TabIndex = 4;
            this.lblresultado.Text = "label2";
            // 
            // Form3
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(391, 131);
            this.Controls.Add(this.lblresultado);
            this.Controls.Add(this.txtmetros);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.Btnconvertir);
            this.Name = "Frm3";
            this.Text = "Frm3";
            this.Load += new System.EventHandler(this.Form3_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button Btnconvertir;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox txtmetros;
        private System.Windows.Forms.Label lblresultado;
    }
}