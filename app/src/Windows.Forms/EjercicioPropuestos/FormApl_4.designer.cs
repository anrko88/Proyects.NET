namespace Win.Frm
{
    partial class FormApl_4
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
            this.btnMenu = new System.Windows.Forms.Button();
            this.btnNuevo = new System.Windows.Forms.Button();
            this.btnMostrar = new System.Windows.Forms.Button();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.txtPension = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
            this.txtNombres = new System.Windows.Forms.TextBox();
            this.label7 = new System.Windows.Forms.Label();
            this.txtApellidos = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.rbtNoche = new System.Windows.Forms.RadioButton();
            this.rbtTarde = new System.Windows.Forms.RadioButton();
            this.rbtmañana = new System.Windows.Forms.RadioButton();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.chkRepitente = new System.Windows.Forms.CheckBox();
            this.chkTraslado = new System.Windows.Forms.CheckBox();
            this.groupBox4 = new System.Windows.Forms.GroupBox();
            this.txtTotal3 = new System.Windows.Forms.TextBox();
            this.txtTotal2 = new System.Windows.Forms.TextBox();
            this.txtTotal1 = new System.Windows.Forms.TextBox();
            this.txtIncRep = new System.Windows.Forms.TextBox();
            this.txtIncTras = new System.Windows.Forms.TextBox();
            this.txtDesTur = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.txtPensionTotal = new System.Windows.Forms.TextBox();
            this.groupBox2.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.groupBox4.SuspendLayout();
            this.SuspendLayout();
            // 
            // btnMenu
            // 
            this.btnMenu.Location = new System.Drawing.Point(242, 299);
            this.btnMenu.Name = "btnMenu";
            this.btnMenu.Size = new System.Drawing.Size(145, 23);
            this.btnMenu.TabIndex = 25;
            this.btnMenu.Text = "Menu Principal";
            this.btnMenu.UseVisualStyleBackColor = true;
            this.btnMenu.Click += new System.EventHandler(this.btnMenu_Click);
            // 
            // btnNuevo
            // 
            this.btnNuevo.Location = new System.Drawing.Point(37, 299);
            this.btnNuevo.Name = "btnNuevo";
            this.btnNuevo.Size = new System.Drawing.Size(75, 23);
            this.btnNuevo.TabIndex = 24;
            this.btnNuevo.Text = "Nuevo";
            this.btnNuevo.UseVisualStyleBackColor = true;
            this.btnNuevo.Click += new System.EventHandler(this.btnNuevo_Click);
            // 
            // btnMostrar
            // 
            this.btnMostrar.Location = new System.Drawing.Point(143, 299);
            this.btnMostrar.Name = "btnMostrar";
            this.btnMostrar.Size = new System.Drawing.Size(75, 23);
            this.btnMostrar.TabIndex = 23;
            this.btnMostrar.Text = "Mostrar";
            this.btnMostrar.UseVisualStyleBackColor = true;
            this.btnMostrar.Click += new System.EventHandler(this.btnMostrar_Click);
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.txtPension);
            this.groupBox2.Controls.Add(this.label8);
            this.groupBox2.Controls.Add(this.txtNombres);
            this.groupBox2.Controls.Add(this.label7);
            this.groupBox2.Controls.Add(this.txtApellidos);
            this.groupBox2.Controls.Add(this.label6);
            this.groupBox2.Font = new System.Drawing.Font("Comic Sans MS", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.groupBox2.Location = new System.Drawing.Point(29, 12);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(357, 110);
            this.groupBox2.TabIndex = 22;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "DATOS DEL PRODUCTO :";
            // 
            // txtPension
            // 
            this.txtPension.Location = new System.Drawing.Point(137, 77);
            this.txtPension.Name = "txtPension";
            this.txtPension.Size = new System.Drawing.Size(100, 23);
            this.txtPension.TabIndex = 15;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(71, 24);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(60, 15);
            this.label8.TabIndex = 8;
            this.label8.Text = "Apellidos :";
            // 
            // txtNombres
            // 
            this.txtNombres.Location = new System.Drawing.Point(137, 45);
            this.txtNombres.Name = "txtNombres";
            this.txtNombres.Size = new System.Drawing.Size(208, 23);
            this.txtNombres.TabIndex = 14;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(73, 50);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(58, 15);
            this.label7.TabIndex = 9;
            this.label7.Text = "Nombres :";
            // 
            // txtApellidos
            // 
            this.txtApellidos.Location = new System.Drawing.Point(137, 18);
            this.txtApellidos.Name = "txtApellidos";
            this.txtApellidos.Size = new System.Drawing.Size(208, 23);
            this.txtApellidos.TabIndex = 13;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(79, 80);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(52, 15);
            this.label6.TabIndex = 10;
            this.label6.Text = "Pension :";
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.rbtNoche);
            this.groupBox1.Controls.Add(this.rbtTarde);
            this.groupBox1.Controls.Add(this.rbtmañana);
            this.groupBox1.Font = new System.Drawing.Font("Comic Sans MS", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.groupBox1.Location = new System.Drawing.Point(33, 126);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(354, 43);
            this.groupBox1.TabIndex = 23;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "TURNO";
            // 
            // rbtNoche
            // 
            this.rbtNoche.AutoSize = true;
            this.rbtNoche.Location = new System.Drawing.Point(220, 13);
            this.rbtNoche.Name = "rbtNoche";
            this.rbtNoche.Size = new System.Drawing.Size(65, 19);
            this.rbtNoche.TabIndex = 2;
            this.rbtNoche.TabStop = true;
            this.rbtNoche.Text = "NOCHE";
            this.rbtNoche.UseVisualStyleBackColor = true;
            // 
            // rbtTarde
            // 
            this.rbtTarde.AutoSize = true;
            this.rbtTarde.Location = new System.Drawing.Point(147, 15);
            this.rbtTarde.Name = "rbtTarde";
            this.rbtTarde.Size = new System.Drawing.Size(62, 19);
            this.rbtTarde.TabIndex = 1;
            this.rbtTarde.TabStop = true;
            this.rbtTarde.Text = "TARDE";
            this.rbtTarde.UseVisualStyleBackColor = true;
            // 
            // rbtmañana
            // 
            this.rbtmañana.AutoSize = true;
            this.rbtmañana.Location = new System.Drawing.Point(54, 14);
            this.rbtmañana.Name = "rbtmañana";
            this.rbtmañana.Size = new System.Drawing.Size(77, 19);
            this.rbtmañana.TabIndex = 0;
            this.rbtmañana.TabStop = true;
            this.rbtmañana.Text = "MAÑANA";
            this.rbtmañana.UseVisualStyleBackColor = true;
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.chkRepitente);
            this.groupBox3.Controls.Add(this.chkTraslado);
            this.groupBox3.Font = new System.Drawing.Font("Comic Sans MS", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.groupBox3.Location = new System.Drawing.Point(12, 175);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(113, 77);
            this.groupBox3.TabIndex = 24;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "OTROS DATOS";
            // 
            // chkRepitente
            // 
            this.chkRepitente.AutoSize = true;
            this.chkRepitente.Location = new System.Drawing.Point(19, 47);
            this.chkRepitente.Name = "chkRepitente";
            this.chkRepitente.Size = new System.Drawing.Size(75, 19);
            this.chkRepitente.TabIndex = 1;
            this.chkRepitente.Text = "Repitente";
            this.chkRepitente.UseVisualStyleBackColor = true;
            // 
            // chkTraslado
            // 
            this.chkTraslado.AutoSize = true;
            this.chkTraslado.Location = new System.Drawing.Point(19, 22);
            this.chkTraslado.Name = "chkTraslado";
            this.chkTraslado.Size = new System.Drawing.Size(70, 19);
            this.chkTraslado.TabIndex = 0;
            this.chkTraslado.Text = "Traslado";
            this.chkTraslado.UseVisualStyleBackColor = true;
            // 
            // groupBox4
            // 
            this.groupBox4.Controls.Add(this.txtTotal3);
            this.groupBox4.Controls.Add(this.txtTotal2);
            this.groupBox4.Controls.Add(this.txtTotal1);
            this.groupBox4.Controls.Add(this.txtIncRep);
            this.groupBox4.Controls.Add(this.txtIncTras);
            this.groupBox4.Controls.Add(this.txtDesTur);
            this.groupBox4.Controls.Add(this.label1);
            this.groupBox4.Controls.Add(this.label2);
            this.groupBox4.Controls.Add(this.label3);
            this.groupBox4.Font = new System.Drawing.Font("Comic Sans MS", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.groupBox4.Location = new System.Drawing.Point(132, 171);
            this.groupBox4.Name = "groupBox4";
            this.groupBox4.Size = new System.Drawing.Size(266, 96);
            this.groupBox4.TabIndex = 23;
            this.groupBox4.TabStop = false;
            this.groupBox4.Text = "CALCULO DE DESCUENTOS";
            // 
            // txtTotal3
            // 
            this.txtTotal3.Location = new System.Drawing.Point(180, 68);
            this.txtTotal3.Name = "txtTotal3";
            this.txtTotal3.Size = new System.Drawing.Size(75, 23);
            this.txtTotal3.TabIndex = 20;
            // 
            // txtTotal2
            // 
            this.txtTotal2.Location = new System.Drawing.Point(179, 42);
            this.txtTotal2.Name = "txtTotal2";
            this.txtTotal2.Size = new System.Drawing.Size(75, 23);
            this.txtTotal2.TabIndex = 19;
            // 
            // txtTotal1
            // 
            this.txtTotal1.Location = new System.Drawing.Point(179, 18);
            this.txtTotal1.Name = "txtTotal1";
            this.txtTotal1.Size = new System.Drawing.Size(75, 23);
            this.txtTotal1.TabIndex = 18;
            // 
            // txtIncRep
            // 
            this.txtIncRep.Location = new System.Drawing.Point(135, 68);
            this.txtIncRep.Name = "txtIncRep";
            this.txtIncRep.Size = new System.Drawing.Size(39, 23);
            this.txtIncRep.TabIndex = 17;
            // 
            // txtIncTras
            // 
            this.txtIncTras.Location = new System.Drawing.Point(134, 42);
            this.txtIncTras.Name = "txtIncTras";
            this.txtIncTras.Size = new System.Drawing.Size(39, 23);
            this.txtIncTras.TabIndex = 16;
            // 
            // txtDesTur
            // 
            this.txtDesTur.Location = new System.Drawing.Point(134, 18);
            this.txtDesTur.Name = "txtDesTur";
            this.txtDesTur.Size = new System.Drawing.Size(39, 23);
            this.txtDesTur.TabIndex = 15;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(4, 24);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(124, 15);
            this.label1.TabIndex = 8;
            this.label1.Text = "Descuentos Por Turno :";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(27, 51);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(101, 15);
            this.label2.TabIndex = 9;
            this.label2.Text = "Inc. Por Traslado :";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(23, 73);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(106, 15);
            this.label3.TabIndex = 10;
            this.label3.Text = "Inc. Por Repitente :";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Comic Sans MS", 11.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.Location = new System.Drawing.Point(65, 273);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(119, 21);
            this.label4.TabIndex = 21;
            this.label4.Text = "Pension Total :";
            // 
            // txtPensionTotal
            // 
            this.txtPensionTotal.Location = new System.Drawing.Point(190, 273);
            this.txtPensionTotal.Name = "txtPensionTotal";
            this.txtPensionTotal.Size = new System.Drawing.Size(100, 20);
            this.txtPensionTotal.TabIndex = 21;
            // 
            // Form5
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(430, 334);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.groupBox4);
            this.Controls.Add(this.groupBox3);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.btnMenu);
            this.Controls.Add(this.btnNuevo);
            this.Controls.Add(this.btnMostrar);
            this.Controls.Add(this.txtPensionTotal);
            this.Controls.Add(this.groupBox2);
            this.Name = "FormApl_4";
            this.Text = "Matricula De Alumnos";
            this.Load += new System.EventHandler(this.Form5_Load);
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.groupBox4.ResumeLayout(false);
            this.groupBox4.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnMenu;
        private System.Windows.Forms.Button btnNuevo;
        private System.Windows.Forms.Button btnMostrar;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.TextBox txtPension;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.TextBox txtNombres;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox txtApellidos;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.RadioButton rbtNoche;
        private System.Windows.Forms.RadioButton rbtTarde;
        private System.Windows.Forms.RadioButton rbtmañana;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.CheckBox chkRepitente;
        private System.Windows.Forms.CheckBox chkTraslado;
        private System.Windows.Forms.GroupBox groupBox4;
        private System.Windows.Forms.TextBox txtIncRep;
        private System.Windows.Forms.TextBox txtIncTras;
        private System.Windows.Forms.TextBox txtDesTur;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox txtTotal3;
        private System.Windows.Forms.TextBox txtTotal2;
        private System.Windows.Forms.TextBox txtTotal1;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox txtPensionTotal;
    }
}