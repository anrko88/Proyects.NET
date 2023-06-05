namespace Win.Frm
{
    partial class FormApl_3
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
            this.label6 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.txttrabajador = new System.Windows.Forms.TextBox();
            this.txtsueldo = new System.Windows.Forms.TextBox();
            this.btnMenu = new System.Windows.Forms.Button();
            this.btnNuevo = new System.Windows.Forms.Button();
            this.btnCalcular = new System.Windows.Forms.Button();
            this.btnSalir = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.label10 = new System.Windows.Forms.Label();
            this.label11 = new System.Windows.Forms.Label();
            this.txt100 = new System.Windows.Forms.TextBox();
            this.txt50 = new System.Windows.Forms.TextBox();
            this.txt20 = new System.Windows.Forms.TextBox();
            this.txt10 = new System.Windows.Forms.TextBox();
            this.txt5 = new System.Windows.Forms.TextBox();
            this.txt2 = new System.Windows.Forms.TextBox();
            this.txt1 = new System.Windows.Forms.TextBox();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Comic Sans MS", 11.25F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Underline))), System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label6.Location = new System.Drawing.Point(69, 109);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(112, 21);
            this.label6.TabIndex = 10;
            this.label6.Text = "RESULTADOS";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Comic Sans MS", 11.25F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Underline))), System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(102, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(229, 21);
            this.label1.TabIndex = 11;
            this.label1.Text = "DESGLOZADOR DE BILLETES";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(99, 51);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(85, 13);
            this.label2.TabIndex = 12;
            this.label2.Text = "TRABAJADOR :";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(110, 75);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(57, 13);
            this.label3.TabIndex = 13;
            this.label3.Text = "SUELDO :";
            // 
            // txttrabajador
            // 
            this.txttrabajador.Location = new System.Drawing.Point(190, 44);
            this.txttrabajador.Name = "txttrabajador";
            this.txttrabajador.Size = new System.Drawing.Size(100, 20);
            this.txttrabajador.TabIndex = 14;
            // 
            // txtsueldo
            // 
            this.txtsueldo.Location = new System.Drawing.Point(190, 75);
            this.txtsueldo.Name = "txtsueldo";
            this.txtsueldo.Size = new System.Drawing.Size(100, 20);
            this.txtsueldo.TabIndex = 15;
            // 
            // btnMenu
            // 
            this.btnMenu.Location = new System.Drawing.Point(254, 228);
            this.btnMenu.Name = "btnMenu";
            this.btnMenu.Size = new System.Drawing.Size(118, 23);
            this.btnMenu.TabIndex = 21;
            this.btnMenu.Text = "Menu Principal";
            this.btnMenu.UseVisualStyleBackColor = true;
            this.btnMenu.Click += new System.EventHandler(this.btnMenu_Click);
            // 
            // btnNuevo
            // 
            this.btnNuevo.Location = new System.Drawing.Point(275, 170);
            this.btnNuevo.Name = "btnNuevo";
            this.btnNuevo.Size = new System.Drawing.Size(75, 23);
            this.btnNuevo.TabIndex = 20;
            this.btnNuevo.Text = "Nuevo";
            this.btnNuevo.UseVisualStyleBackColor = true;
            this.btnNuevo.Click += new System.EventHandler(this.btnNuevo_Click);
            // 
            // btnCalcular
            // 
            this.btnCalcular.Location = new System.Drawing.Point(275, 143);
            this.btnCalcular.Name = "btnCalcular";
            this.btnCalcular.Size = new System.Drawing.Size(75, 23);
            this.btnCalcular.TabIndex = 19;
            this.btnCalcular.Text = "Calcular";
            this.btnCalcular.UseVisualStyleBackColor = true;
            this.btnCalcular.Click += new System.EventHandler(this.btnCalcular_Click);
            // 
            // btnSalir
            // 
            this.btnSalir.Location = new System.Drawing.Point(275, 199);
            this.btnSalir.Name = "btnSalir";
            this.btnSalir.Size = new System.Drawing.Size(75, 23);
            this.btnSalir.TabIndex = 22;
            this.btnSalir.Text = "Salir";
            this.btnSalir.UseVisualStyleBackColor = true;
            this.btnSalir.Click += new System.EventHandler(this.btnSalir_Click);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(6, 16);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(102, 13);
            this.label4.TabIndex = 23;
            this.label4.Text = "BILLETES DE 100 :";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(10, 38);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(96, 13);
            this.label5.TabIndex = 24;
            this.label5.Text = "BILLETES DE 50 :";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(11, 61);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(96, 13);
            this.label7.TabIndex = 25;
            this.label7.Text = "BILLETES DE 20 :";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(10, 83);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(96, 13);
            this.label8.TabIndex = 26;
            this.label8.Text = "BILLETES DE 10 :";
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(15, 107);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(90, 13);
            this.label9.TabIndex = 27;
            this.label9.Text = "BILLETES DE 5 :";
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(16, 131);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(90, 13);
            this.label10.TabIndex = 28;
            this.label10.Text = "BILLETES DE 2 :";
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Location = new System.Drawing.Point(18, 154);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(90, 13);
            this.label11.TabIndex = 29;
            this.label11.Text = "BILLETES DE 1 :";
            // 
            // txt100
            // 
            this.txt100.Location = new System.Drawing.Point(114, 13);
            this.txt100.Name = "txt100";
            this.txt100.Size = new System.Drawing.Size(64, 20);
            this.txt100.TabIndex = 30;
            // 
            // txt50
            // 
            this.txt50.Location = new System.Drawing.Point(114, 35);
            this.txt50.Name = "txt50";
            this.txt50.Size = new System.Drawing.Size(64, 20);
            this.txt50.TabIndex = 31;
            // 
            // txt20
            // 
            this.txt20.Location = new System.Drawing.Point(114, 58);
            this.txt20.Name = "txt20";
            this.txt20.Size = new System.Drawing.Size(64, 20);
            this.txt20.TabIndex = 32;
            // 
            // txt10
            // 
            this.txt10.Location = new System.Drawing.Point(114, 81);
            this.txt10.Name = "txt10";
            this.txt10.Size = new System.Drawing.Size(64, 20);
            this.txt10.TabIndex = 33;
            // 
            // txt5
            // 
            this.txt5.Location = new System.Drawing.Point(114, 104);
            this.txt5.Name = "txt5";
            this.txt5.Size = new System.Drawing.Size(64, 20);
            this.txt5.TabIndex = 34;
            // 
            // txt2
            // 
            this.txt2.Location = new System.Drawing.Point(113, 128);
            this.txt2.Name = "txt2";
            this.txt2.Size = new System.Drawing.Size(64, 20);
            this.txt2.TabIndex = 35;
            // 
            // txt1
            // 
            this.txt1.Location = new System.Drawing.Point(113, 153);
            this.txt1.Name = "txt1";
            this.txt1.Size = new System.Drawing.Size(64, 20);
            this.txt1.TabIndex = 36;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.label4);
            this.groupBox1.Controls.Add(this.txt1);
            this.groupBox1.Controls.Add(this.label5);
            this.groupBox1.Controls.Add(this.txt2);
            this.groupBox1.Controls.Add(this.label7);
            this.groupBox1.Controls.Add(this.txt5);
            this.groupBox1.Controls.Add(this.label8);
            this.groupBox1.Controls.Add(this.txt10);
            this.groupBox1.Controls.Add(this.label9);
            this.groupBox1.Controls.Add(this.txt20);
            this.groupBox1.Controls.Add(this.label10);
            this.groupBox1.Controls.Add(this.txt50);
            this.groupBox1.Controls.Add(this.label11);
            this.groupBox1.Controls.Add(this.txt100);
            this.groupBox1.Location = new System.Drawing.Point(39, 133);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(193, 186);
            this.groupBox1.TabIndex = 37;
            this.groupBox1.TabStop = false;
            // 
            // Form4
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(396, 337);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.btnSalir);
            this.Controls.Add(this.btnMenu);
            this.Controls.Add(this.btnNuevo);
            this.Controls.Add(this.btnCalcular);
            this.Controls.Add(this.txtsueldo);
            this.Controls.Add(this.txttrabajador);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.label6);
            this.MaximumSize = new System.Drawing.Size(404, 371);
            this.MinimumSize = new System.Drawing.Size(404, 371);
            this.Name = "FormApl_3";
            this.Text = "DESGLOZADOR DE BILLETES";
            this.Load += new System.EventHandler(this.Form4_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox txttrabajador;
        private System.Windows.Forms.TextBox txtsueldo;
        private System.Windows.Forms.Button btnMenu;
        private System.Windows.Forms.Button btnNuevo;
        private System.Windows.Forms.Button btnCalcular;
        private System.Windows.Forms.Button btnSalir;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.TextBox txt100;
        private System.Windows.Forms.TextBox txt50;
        private System.Windows.Forms.TextBox txt20;
        private System.Windows.Forms.TextBox txt10;
        private System.Windows.Forms.TextBox txt5;
        private System.Windows.Forms.TextBox txt2;
        private System.Windows.Forms.TextBox txt1;
        private System.Windows.Forms.GroupBox groupBox1;
    }
}