
namespace Win.Frm.BD
{
    partial class FrmCustomerOrder
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.comboBox1 = new System.Windows.Forms.ComboBox();
            this.label2 = new System.Windows.Forms.Label();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.label3 = new System.Windows.Forms.Label();
            this.lblcantPedidos = new System.Windows.Forms.Label();
            this.lbltotal = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.btnform2 = new System.Windows.Forms.Button();
            this.btnform3 = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(131, 12);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(126, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "LISTADO DE CLIENTES";
            // 
            // comboBox1
            // 
            this.comboBox1.FormattingEnabled = true;
            this.comboBox1.Location = new System.Drawing.Point(273, 12);
            this.comboBox1.Name = "comboBox1";
            this.comboBox1.Size = new System.Drawing.Size(193, 21);
            this.comboBox1.TabIndex = 1;
            this.comboBox1.SelectedIndexChanged += new System.EventHandler(this.comboBox1_SelectedIndexChanged);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(13, 50);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(298, 13);
            this.label2.TabIndex = 2;
            this.label2.Text = "ORDENES COMPRADAS POR CLIENTE SELECCIONADOS";
            // 
            // dataGridView1
            // 
            this.dataGridView1.AllowUserToAddRows = false;
            this.dataGridView1.AllowUserToDeleteRows = false;
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Location = new System.Drawing.Point(12, 66);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.ReadOnly = true;
            this.dataGridView1.Size = new System.Drawing.Size(533, 150);
            this.dataGridView1.TabIndex = 3;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(313, 224);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(137, 13);
            this.label3.TabIndex = 4;
            this.label3.Text = "CANTIDAD DE PEDIDOS :";
            // 
            // lblcantPedidos
            // 
            this.lblcantPedidos.AutoSize = true;
            this.lblcantPedidos.Location = new System.Drawing.Point(467, 224);
            this.lblcantPedidos.Name = "lblcantPedidos";
            this.lblcantPedidos.Size = new System.Drawing.Size(76, 13);
            this.lblcantPedidos.TabIndex = 5;
            this.lblcantPedidos.Text = "lblcantPedidos";
            // 
            // lbltotal
            // 
            this.lbltotal.AutoSize = true;
            this.lbltotal.Location = new System.Drawing.Point(467, 251);
            this.lbltotal.Name = "lbltotal";
            this.lbltotal.Size = new System.Drawing.Size(37, 13);
            this.lbltotal.TabIndex = 7;
            this.lbltotal.Text = "lbltotal";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(326, 251);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(122, 13);
            this.label6.TabIndex = 6;
            this.label6.Text = "TOTAL DE COMPRAS :";
            // 
            // btnform2
            // 
            this.btnform2.Location = new System.Drawing.Point(47, 224);
            this.btnform2.Name = "btnform2";
            this.btnform2.Size = new System.Drawing.Size(75, 23);
            this.btnform2.TabIndex = 8;
            this.btnform2.Text = "Form2";
            this.btnform2.UseVisualStyleBackColor = true;
            this.btnform2.Click += new System.EventHandler(this.btnform2_Click);
            // 
            // btnform3
            // 
            this.btnform3.Location = new System.Drawing.Point(134, 224);
            this.btnform3.Name = "btnform3";
            this.btnform3.Size = new System.Drawing.Size(75, 23);
            this.btnform3.TabIndex = 9;
            this.btnform3.Text = "MantEmp";
            this.btnform3.UseVisualStyleBackColor = true;
            this.btnform3.Click += new System.EventHandler(this.btnform3_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(550, 284);
            this.Controls.Add(this.btnform3);
            this.Controls.Add(this.btnform2);
            this.Controls.Add(this.lbltotal);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.lblcantPedidos);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.dataGridView1);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.comboBox1);
            this.Controls.Add(this.label1);
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox comboBox1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.DataGridView dataGridView1;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label lblcantPedidos;
        private System.Windows.Forms.Label lbltotal;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Button btnform2;
        private System.Windows.Forms.Button btnform3;
    }
}

