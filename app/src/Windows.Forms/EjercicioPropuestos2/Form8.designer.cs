namespace Win.Frm
{
    partial class Form8
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
            this.btnDeclaringVariables = new System.Windows.Forms.Button();
            this.btnConvertingTypes = new System.Windows.Forms.Button();
            this.btnAssigningVariables = new System.Windows.Forms.Button();
            this.btnEnumerations = new System.Windows.Forms.Button();
            this.btnStringVariables = new System.Windows.Forms.Button();
            this.btnConstantes = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // btnDeclaringVariables
            // 
            this.btnDeclaringVariables.Location = new System.Drawing.Point(21, 12);
            this.btnDeclaringVariables.Name = "btnDeclaringVariables";
            this.btnDeclaringVariables.Size = new System.Drawing.Size(130, 47);
            this.btnDeclaringVariables.TabIndex = 0;
            this.btnDeclaringVariables.Text = "Declaring Variables";
            this.btnDeclaringVariables.UseVisualStyleBackColor = true;
            this.btnDeclaringVariables.Click += new System.EventHandler(this.btnDeclaringVariables_Click);
            // 
            // btnConvertingTypes
            // 
            this.btnConvertingTypes.Location = new System.Drawing.Point(181, 12);
            this.btnConvertingTypes.Name = "btnConvertingTypes";
            this.btnConvertingTypes.Size = new System.Drawing.Size(130, 47);
            this.btnConvertingTypes.TabIndex = 1;
            this.btnConvertingTypes.Text = "Converting Types";
            this.btnConvertingTypes.UseVisualStyleBackColor = true;
            this.btnConvertingTypes.Click += new System.EventHandler(this.btnConvertingTypes_Click);
            // 
            // btnAssigningVariables
            // 
            this.btnAssigningVariables.Location = new System.Drawing.Point(21, 77);
            this.btnAssigningVariables.Name = "btnAssigningVariables";
            this.btnAssigningVariables.Size = new System.Drawing.Size(130, 47);
            this.btnAssigningVariables.TabIndex = 2;
            this.btnAssigningVariables.Text = "Assigning Variables";
            this.btnAssigningVariables.UseVisualStyleBackColor = true;
            this.btnAssigningVariables.Click += new System.EventHandler(this.btnAssigningVariables_Click);
            // 
            // btnEnumerations
            // 
            this.btnEnumerations.Location = new System.Drawing.Point(181, 77);
            this.btnEnumerations.Name = "btnEnumerations";
            this.btnEnumerations.Size = new System.Drawing.Size(130, 47);
            this.btnEnumerations.TabIndex = 3;
            this.btnEnumerations.Text = "Enumerations";
            this.btnEnumerations.UseVisualStyleBackColor = true;
            this.btnEnumerations.Click += new System.EventHandler(this.btnEnumerations_Click);
            // 
            // btnStringVariables
            // 
            this.btnStringVariables.Location = new System.Drawing.Point(21, 139);
            this.btnStringVariables.Name = "btnStringVariables";
            this.btnStringVariables.Size = new System.Drawing.Size(130, 47);
            this.btnStringVariables.TabIndex = 4;
            this.btnStringVariables.Text = "String Variables";
            this.btnStringVariables.UseVisualStyleBackColor = true;
            this.btnStringVariables.Click += new System.EventHandler(this.btnStringVariables_Click);
            // 
            // btnConstantes
            // 
            this.btnConstantes.Location = new System.Drawing.Point(181, 139);
            this.btnConstantes.Name = "btnConstantes";
            this.btnConstantes.Size = new System.Drawing.Size(130, 47);
            this.btnConstantes.TabIndex = 5;
            this.btnConstantes.Text = "Constantes";
            this.btnConstantes.UseVisualStyleBackColor = true;
            this.btnConstantes.Click += new System.EventHandler(this.btnConstantes_Click);
            // 
            // Form8
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(319, 201);
            this.Controls.Add(this.btnConstantes);
            this.Controls.Add(this.btnStringVariables);
            this.Controls.Add(this.btnEnumerations);
            this.Controls.Add(this.btnAssigningVariables);
            this.Controls.Add(this.btnConvertingTypes);
            this.Controls.Add(this.btnDeclaringVariables);
            this.MaximumSize = new System.Drawing.Size(327, 235);
            this.MinimumSize = new System.Drawing.Size(327, 235);
            this.Name = "Form8";
            this.Text = "Manejo De Variables";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button btnDeclaringVariables;
        private System.Windows.Forms.Button btnConvertingTypes;
        private System.Windows.Forms.Button btnAssigningVariables;
        private System.Windows.Forms.Button btnEnumerations;
        private System.Windows.Forms.Button btnStringVariables;
        private System.Windows.Forms.Button btnConstantes;
    }
}