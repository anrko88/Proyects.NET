namespace Win.Frm
{
    partial class Form6
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
            this.lnkWebSite = new System.Windows.Forms.LinkLabel();
            this.lnkBuy = new System.Windows.Forms.LinkLabel();
            this.SuspendLayout();
            // 
            // lnkWebSite
            // 
            this.lnkWebSite.AutoSize = true;
            this.lnkWebSite.Location = new System.Drawing.Point(36, 25);
            this.lnkWebSite.Name = "lnkWebSite";
            this.lnkWebSite.Size = new System.Drawing.Size(238, 13);
            this.lnkWebSite.TabIndex = 1;
            this.lnkWebSite.TabStop = true;
            this.lnkWebSite.Text = "Vea www.prosetech.com  para mas informacion. ";
            this.lnkWebSite.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkWebSite_Clicked);
            // 
            // lnkBuy
            // 
            this.lnkBuy.AutoSize = true;
            this.lnkBuy.Location = new System.Drawing.Point(50, 67);
            this.lnkBuy.Name = "lnkBuy";
            this.lnkBuy.Size = new System.Drawing.Size(211, 13);
            this.lnkBuy.TabIndex = 4;
            this.lnkBuy.TabStop = true;
            this.lnkBuy.Text = "Compre en Amazon.com o Barnes y Macro.";
            this.lnkBuy.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.linkBuy_Clicked);
            // 
            // Form6
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(330, 107);
            this.Controls.Add(this.lnkBuy);
            this.Controls.Add(this.lnkWebSite);
            this.ForeColor = System.Drawing.SystemColors.ActiveCaptionText;
            this.MaximumSize = new System.Drawing.Size(338, 141);
            this.MinimumSize = new System.Drawing.Size(338, 141);
            this.Name = "Form6";
            this.Text = "Etiquetas Links";
            this.Load += new System.EventHandler(this.Form6_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.LinkLabel lnkWebSite;
        private System.Windows.Forms.LinkLabel lnkBuy;
    }
}