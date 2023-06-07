namespace Capa.Win
{
    partial class Frm_MenuBD
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
            this.btnform1 = new System.Windows.Forms.Button();
            this.btnform2 = new System.Windows.Forms.Button();
            this.button1 = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // btnform1
            // 
            this.btnform1.Location = new System.Drawing.Point(12, 12);
            this.btnform1.Name = "btnform1";
            this.btnform1.Size = new System.Drawing.Size(119, 23);
            this.btnform1.TabIndex = 0;
            this.btnform1.Text = "Product";
            this.btnform1.UseVisualStyleBackColor = true;
            this.btnform1.Click += new System.EventHandler(this.btnform1_Click);
            // 
            // btnform2
            // 
            this.btnform2.Location = new System.Drawing.Point(137, 12);
            this.btnform2.Name = "btnform2";
            this.btnform2.Size = new System.Drawing.Size(104, 23);
            this.btnform2.TabIndex = 1;
            this.btnform2.Text = "Product Order";
            this.btnform2.UseVisualStyleBackColor = true;
            this.btnform2.Click += new System.EventHandler(this.btnform2_Click);
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(247, 12);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(104, 23);
            this.button1.TabIndex = 2;
            this.button1.Text = "Customer";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // Frm_MenuBD
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(528, 114);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.btnform2);
            this.Controls.Add(this.btnform1);
            this.Name = "Frm_MenuBD";
            this.Text = "FrmMenuBD";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button btnform1;
        private System.Windows.Forms.Button btnform2;
        private System.Windows.Forms.Button button1;
    }
}