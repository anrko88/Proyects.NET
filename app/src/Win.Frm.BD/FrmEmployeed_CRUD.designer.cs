namespace Win.Frm.BD
{
    partial class FrmEmployeed_CRUD
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(FrmEmployeed_CRUD));
            this.Label8 = new System.Windows.Forms.Label();
            this.lblcantreg = new System.Windows.Forms.Label();
            this.Label6 = new System.Windows.Forms.Label();
            this.DataGridView1 = new System.Windows.Forms.DataGridView();
            this.GroupBox1 = new System.Windows.Forms.GroupBox();
            this.Label7 = new System.Windows.Forms.Label();
            this.Cbosexo = new System.Windows.Forms.ComboBox();
            this.MskfechaNaci = new System.Windows.Forms.MaskedTextBox();
            this.Cbopais = new System.Windows.Forms.ComboBox();
            this.TxtNombres = new System.Windows.Forms.TextBox();
            this.Lblcodemp = new System.Windows.Forms.Label();
            this.Label5 = new System.Windows.Forms.Label();
            this.Label4 = new System.Windows.Forms.Label();
            this.Label3 = new System.Windows.Forms.Label();
            this.Label2 = new System.Windows.Forms.Label();
            this.Label1 = new System.Windows.Forms.Label();
            this.ToolStrip1 = new System.Windows.Forms.ToolStrip();
            this.Cmdnuevo = new System.Windows.Forms.ToolStripButton();
            this.Cmdgrabar = new System.Windows.Forms.ToolStripButton();
            this.CmdEditar = new System.Windows.Forms.ToolStripButton();
            this.CmdEliminar = new System.Windows.Forms.ToolStripButton();
            this.ToolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.CmdBusqueda = new System.Windows.Forms.ToolStripButton();
            this.ToolStripLabel1 = new System.Windows.Forms.ToolStripLabel();
            this.txtcodigo = new System.Windows.Forms.ToolStripTextBox();
            this.ToolStripSeparator2 = new System.Windows.Forms.ToolStripSeparator();
            this.CmdCerrar = new System.Windows.Forms.ToolStripButton();
            ((System.ComponentModel.ISupportInitialize)(this.DataGridView1)).BeginInit();
            this.GroupBox1.SuspendLayout();
            this.ToolStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // Label8
            // 
            this.Label8.BackColor = System.Drawing.SystemColors.Desktop;
            this.Label8.Font = new System.Drawing.Font("Tahoma", 9.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Label8.ForeColor = System.Drawing.Color.White;
            this.Label8.Location = new System.Drawing.Point(12, 242);
            this.Label8.Name = "Label8";
            this.Label8.Size = new System.Drawing.Size(529, 19);
            this.Label8.TabIndex = 11;
            this.Label8.Text = "LISTADO DE EMPLEDOS";
            this.Label8.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lblcantreg
            // 
            this.lblcantreg.AutoSize = true;
            this.lblcantreg.Font = new System.Drawing.Font("Tahoma", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblcantreg.Location = new System.Drawing.Point(154, 422);
            this.lblcantreg.Name = "lblcantreg";
            this.lblcantreg.Size = new System.Drawing.Size(68, 14);
            this.lblcantreg.TabIndex = 10;
            this.lblcantreg.Text = "lblcantreg";
            // 
            // Label6
            // 
            this.Label6.AutoSize = true;
            this.Label6.Font = new System.Drawing.Font("Tahoma", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.Label6.Location = new System.Drawing.Point(12, 422);
            this.Label6.Name = "Label6";
            this.Label6.Size = new System.Drawing.Size(139, 14);
            this.Label6.TabIndex = 9;
            this.Label6.Text = "Total de registros =>";
            // 
            // DataGridView1
            // 
            this.DataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.DataGridView1.Location = new System.Drawing.Point(12, 261);
            this.DataGridView1.Name = "DataGridView1";
            this.DataGridView1.Size = new System.Drawing.Size(529, 154);
            this.DataGridView1.TabIndex = 8;
            // 
            // GroupBox1
            // 
            this.GroupBox1.Controls.Add(this.Label7);
            this.GroupBox1.Controls.Add(this.Cbosexo);
            this.GroupBox1.Controls.Add(this.MskfechaNaci);
            this.GroupBox1.Controls.Add(this.Cbopais);
            this.GroupBox1.Controls.Add(this.TxtNombres);
            this.GroupBox1.Controls.Add(this.Lblcodemp);
            this.GroupBox1.Controls.Add(this.Label5);
            this.GroupBox1.Controls.Add(this.Label4);
            this.GroupBox1.Controls.Add(this.Label3);
            this.GroupBox1.Controls.Add(this.Label2);
            this.GroupBox1.Controls.Add(this.Label1);
            this.GroupBox1.Font = new System.Drawing.Font("Tahoma", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.GroupBox1.Location = new System.Drawing.Point(29, 48);
            this.GroupBox1.Name = "GroupBox1";
            this.GroupBox1.Size = new System.Drawing.Size(497, 177);
            this.GroupBox1.TabIndex = 7;
            this.GroupBox1.TabStop = false;
            this.GroupBox1.Text = "INGRESE DATOS DEL EMPLEADO";
            // 
            // Label7
            // 
            this.Label7.AutoSize = true;
            this.Label7.Location = new System.Drawing.Point(284, 117);
            this.Label7.Name = "Label7";
            this.Label7.Size = new System.Drawing.Size(87, 14);
            this.Label7.TabIndex = 10;
            this.Label7.Text = "dd/mm/yyyy";
            // 
            // Cbosexo
            // 
            this.Cbosexo.FormattingEnabled = true;
            this.Cbosexo.Location = new System.Drawing.Point(166, 143);
            this.Cbosexo.Name = "Cbosexo";
            this.Cbosexo.Size = new System.Drawing.Size(121, 22);
            this.Cbosexo.TabIndex = 9;
            // 
            // MskfechaNaci
            // 
            this.MskfechaNaci.Location = new System.Drawing.Point(167, 114);
            this.MskfechaNaci.Mask = "00/00/0000";
            this.MskfechaNaci.Name = "MskfechaNaci";
            this.MskfechaNaci.Size = new System.Drawing.Size(101, 22);
            this.MskfechaNaci.TabIndex = 8;
            this.MskfechaNaci.ValidatingType = typeof(System.DateTime);
            // 
            // Cbopais
            // 
            this.Cbopais.FormattingEnabled = true;
            this.Cbopais.Location = new System.Drawing.Point(166, 85);
            this.Cbopais.Name = "Cbopais";
            this.Cbopais.Size = new System.Drawing.Size(168, 22);
            this.Cbopais.TabIndex = 7;
            // 
            // TxtNombres
            // 
            this.TxtNombres.Location = new System.Drawing.Point(166, 54);
            this.TxtNombres.Name = "TxtNombres";
            this.TxtNombres.Size = new System.Drawing.Size(277, 22);
            this.TxtNombres.TabIndex = 6;
            // 
            // Lblcodemp
            // 
            this.Lblcodemp.AutoSize = true;
            this.Lblcodemp.Location = new System.Drawing.Point(163, 33);
            this.Lblcodemp.Name = "Lblcodemp";
            this.Lblcodemp.Size = new System.Drawing.Size(73, 14);
            this.Lblcodemp.TabIndex = 5;
            this.Lblcodemp.Text = "Lblcodemp";
            // 
            // Label5
            // 
            this.Label5.AutoSize = true;
            this.Label5.Location = new System.Drawing.Point(112, 146);
            this.Label5.Name = "Label5";
            this.Label5.Size = new System.Drawing.Size(45, 14);
            this.Label5.TabIndex = 4;
            this.Label5.Text = "Sexo :";
            // 
            // Label4
            // 
            this.Label4.AutoSize = true;
            this.Label4.Location = new System.Drawing.Point(18, 117);
            this.Label4.Name = "Label4";
            this.Label4.Size = new System.Drawing.Size(139, 14);
            this.Label4.TabIndex = 3;
            this.Label4.Text = "Fecha de Nacimiento :";
            // 
            // Label3
            // 
            this.Label3.AutoSize = true;
            this.Label3.Location = new System.Drawing.Point(118, 87);
            this.Label3.Name = "Label3";
            this.Label3.Size = new System.Drawing.Size(39, 14);
            this.Label3.TabIndex = 2;
            this.Label3.Text = "Pais :";
            // 
            // Label2
            // 
            this.Label2.AutoSize = true;
            this.Label2.Location = new System.Drawing.Point(19, 58);
            this.Label2.Name = "Label2";
            this.Label2.Size = new System.Drawing.Size(138, 14);
            this.Label2.TabIndex = 1;
            this.Label2.Text = "Nombres y Apellidos :";
            // 
            // Label1
            // 
            this.Label1.AutoSize = true;
            this.Label1.Location = new System.Drawing.Point(99, 33);
            this.Label1.Name = "Label1";
            this.Label1.Size = new System.Drawing.Size(58, 14);
            this.Label1.TabIndex = 0;
            this.Label1.Text = "Codigo :";
            // 
            // ToolStrip1
            // 
            this.ToolStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.Cmdnuevo,
            this.Cmdgrabar,
            this.CmdEditar,
            this.CmdEliminar,
            this.ToolStripSeparator1,
            this.CmdBusqueda,
            this.ToolStripLabel1,
            this.txtcodigo,
            this.ToolStripSeparator2,
            this.CmdCerrar});
            this.ToolStrip1.Location = new System.Drawing.Point(0, 0);
            this.ToolStrip1.Name = "ToolStrip1";
            this.ToolStrip1.Size = new System.Drawing.Size(557, 36);
            this.ToolStrip1.TabIndex = 6;
            this.ToolStrip1.Text = "ToolStrip1";
            // 
            // Cmdnuevo
            // 
            this.Cmdnuevo.Image = ((System.Drawing.Image)(resources.GetObject("Cmdnuevo.Image")));
            this.Cmdnuevo.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.Cmdnuevo.Name = "Cmdnuevo";
            this.Cmdnuevo.Size = new System.Drawing.Size(42, 33);
            this.Cmdnuevo.Text = "Nuevo";
            this.Cmdnuevo.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.Cmdnuevo.Click += new System.EventHandler(this.Cmdnuevo_Click);
            // 
            // Cmdgrabar
            // 
            this.Cmdgrabar.Image = ((System.Drawing.Image)(resources.GetObject("Cmdgrabar.Image")));
            this.Cmdgrabar.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.Cmdgrabar.Name = "Cmdgrabar";
            this.Cmdgrabar.Size = new System.Drawing.Size(44, 33);
            this.Cmdgrabar.Text = "Grabar";
            this.Cmdgrabar.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.Cmdgrabar.Click += new System.EventHandler(this.Cmdgrabar_Click);
            // 
            // CmdEditar
            // 
            this.CmdEditar.Image = ((System.Drawing.Image)(resources.GetObject("CmdEditar.Image")));
            this.CmdEditar.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.CmdEditar.Name = "CmdEditar";
            this.CmdEditar.Size = new System.Drawing.Size(39, 33);
            this.CmdEditar.Text = "Editar";
            this.CmdEditar.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.CmdEditar.Click += new System.EventHandler(this.CmdEditar_Click);
            // 
            // CmdEliminar
            // 
            this.CmdEliminar.Image = ((System.Drawing.Image)(resources.GetObject("CmdEliminar.Image")));
            this.CmdEliminar.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.CmdEliminar.Name = "CmdEliminar";
            this.CmdEliminar.Size = new System.Drawing.Size(47, 33);
            this.CmdEliminar.Text = "Eliminar";
            this.CmdEliminar.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.CmdEliminar.Click += new System.EventHandler(this.CmdEliminar_Click);
            // 
            // ToolStripSeparator1
            // 
            this.ToolStripSeparator1.Name = "ToolStripSeparator1";
            this.ToolStripSeparator1.Size = new System.Drawing.Size(6, 36);
            // 
            // CmdBusqueda
            // 
            this.CmdBusqueda.Image = ((System.Drawing.Image)(resources.GetObject("CmdBusqueda.Image")));
            this.CmdBusqueda.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.CmdBusqueda.Name = "CmdBusqueda";
            this.CmdBusqueda.Size = new System.Drawing.Size(58, 33);
            this.CmdBusqueda.Text = "Busqueda";
            this.CmdBusqueda.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.CmdBusqueda.Click += new System.EventHandler(this.CmdBusqueda_Click);
            // 
            // ToolStripLabel1
            // 
            this.ToolStripLabel1.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ToolStripLabel1.Name = "ToolStripLabel1";
            this.ToolStripLabel1.Size = new System.Drawing.Size(72, 33);
            this.ToolStripLabel1.Text = "CODIGO =>";
            // 
            // txtcodigo
            // 
            this.txtcodigo.Name = "txtcodigo";
            this.txtcodigo.Size = new System.Drawing.Size(100, 36);
            // 
            // ToolStripSeparator2
            // 
            this.ToolStripSeparator2.Name = "ToolStripSeparator2";
            this.ToolStripSeparator2.Size = new System.Drawing.Size(6, 36);
            // 
            // CmdCerrar
            // 
            this.CmdCerrar.Image = ((System.Drawing.Image)(resources.GetObject("CmdCerrar.Image")));
            this.CmdCerrar.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.CmdCerrar.Name = "CmdCerrar";
            this.CmdCerrar.Size = new System.Drawing.Size(42, 33);
            this.CmdCerrar.Text = "Cerrar";
            this.CmdCerrar.TextImageRelation = System.Windows.Forms.TextImageRelation.ImageAboveText;
            this.CmdCerrar.Click += new System.EventHandler(this.CmdCerrar_Click);
            // 
            // Form3_MantEmpl
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(557, 451);
            this.Controls.Add(this.Label8);
            this.Controls.Add(this.lblcantreg);
            this.Controls.Add(this.Label6);
            this.Controls.Add(this.DataGridView1);
            this.Controls.Add(this.GroupBox1);
            this.Controls.Add(this.ToolStrip1);
            this.Name = "Form3_MantEmpl";
            this.Text = "MANTENIMIENTO DE EMPLEADOS";
            this.Load += new System.EventHandler(this.Form3_MantEmpl_Load);
            ((System.ComponentModel.ISupportInitialize)(this.DataGridView1)).EndInit();
            this.GroupBox1.ResumeLayout(false);
            this.GroupBox1.PerformLayout();
            this.ToolStrip1.ResumeLayout(false);
            this.ToolStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        internal System.Windows.Forms.Label Label8;
        internal System.Windows.Forms.Label lblcantreg;
        internal System.Windows.Forms.Label Label6;
        internal System.Windows.Forms.DataGridView DataGridView1;
        internal System.Windows.Forms.GroupBox GroupBox1;
        internal System.Windows.Forms.Label Label7;
        internal System.Windows.Forms.ComboBox Cbosexo;
        internal System.Windows.Forms.MaskedTextBox MskfechaNaci;
        internal System.Windows.Forms.ComboBox Cbopais;
        internal System.Windows.Forms.TextBox TxtNombres;
        internal System.Windows.Forms.Label Lblcodemp;
        internal System.Windows.Forms.Label Label5;
        internal System.Windows.Forms.Label Label4;
        internal System.Windows.Forms.Label Label3;
        internal System.Windows.Forms.Label Label2;
        internal System.Windows.Forms.Label Label1;
        internal System.Windows.Forms.ToolStrip ToolStrip1;
        internal System.Windows.Forms.ToolStripButton Cmdnuevo;
        internal System.Windows.Forms.ToolStripButton Cmdgrabar;
        internal System.Windows.Forms.ToolStripButton CmdEditar;
        internal System.Windows.Forms.ToolStripButton CmdEliminar;
        internal System.Windows.Forms.ToolStripSeparator ToolStripSeparator1;
        internal System.Windows.Forms.ToolStripButton CmdBusqueda;
        internal System.Windows.Forms.ToolStripLabel ToolStripLabel1;
        internal System.Windows.Forms.ToolStripTextBox txtcodigo;
        internal System.Windows.Forms.ToolStripSeparator ToolStripSeparator2;
        internal System.Windows.Forms.ToolStripButton CmdCerrar;
    }
}