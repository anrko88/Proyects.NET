namespace Win.Frm
{
    partial class FrmCustomer
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
            this.label1 = new System.Windows.Forms.Label();
            this.lblBirghtness = new System.Windows.Forms.TextBox();
            this.lblHue = new System.Windows.Forms.TextBox();
            this.lblSaturation = new System.Windows.Forms.TextBox();
            this.lstColors = new System.Windows.Forms.ListBox();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoEllipsis = true;
            this.label1.AutoSize = true;
            this.label1.BackColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.label1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.label1.Location = new System.Drawing.Point(12, 18);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(150, 15);
            this.label1.TabIndex = 0;
            this.label1.Text = "Choose a BackGround Color :";
            // 
            // lblBirghtness
            // 
            this.lblBirghtness.Location = new System.Drawing.Point(180, 18);
            this.lblBirghtness.Name = "lblBirghtness";
            this.lblBirghtness.Size = new System.Drawing.Size(100, 20);
            this.lblBirghtness.TabIndex = 1;
            this.lblBirghtness.Text = "Birghtness";
            // 
            // lblHue
            // 
            this.lblHue.Location = new System.Drawing.Point(180, 45);
            this.lblHue.Name = "lblHue";
            this.lblHue.Size = new System.Drawing.Size(100, 20);
            this.lblHue.TabIndex = 2;
            this.lblHue.Text = "Hue";
            // 
            // lblSaturation
            // 
            this.lblSaturation.Location = new System.Drawing.Point(180, 71);
            this.lblSaturation.Name = "lblSaturation";
            this.lblSaturation.Size = new System.Drawing.Size(100, 20);
            this.lblSaturation.TabIndex = 3;
            this.lblSaturation.Text = "Saturation";
            // 
            // lstColors
            // 
            this.lstColors.FormattingEnabled = true;
            this.lstColors.Location = new System.Drawing.Point(12, 45);
            this.lstColors.Name = "lstColors";
            this.lstColors.Size = new System.Drawing.Size(141, 199);
            this.lstColors.TabIndex = 4;
            this.lstColors.SelectedIndexChanged += new System.EventHandler(this.lstColors_SelectedIndexChanged);
            // 
            // Form2
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(292, 266);
            this.Controls.Add(this.lstColors);
            this.Controls.Add(this.lblSaturation);
            this.Controls.Add(this.lblHue);
            this.Controls.Add(this.lblBirghtness);
            this.Controls.Add(this.label1);
            this.DoubleBuffered = true;
            this.Name = "Form2";
            this.Text = "Form2";
            this.Load += new System.EventHandler(this.Form2_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox lblBirghtness;
        private System.Windows.Forms.TextBox lblHue;
        private System.Windows.Forms.TextBox lblSaturation;
        private System.Windows.Forms.ListBox lstColors;
    }
}