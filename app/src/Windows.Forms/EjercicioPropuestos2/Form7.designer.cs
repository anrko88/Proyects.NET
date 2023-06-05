namespace Win.Frm
{
    partial class Form7
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
            this.BtnUnhandledException = new System.Windows.Forms.Button();
            this.btnTryCatch = new System.Windows.Forms.Button();
            this.btnTryCatchFinally = new System.Windows.Forms.Button();
            this.btnIf = new System.Windows.Forms.Button();
            this.btnIfElse = new System.Windows.Forms.Button();
            this.btnSwitchCase = new System.Windows.Forms.Button();
            this.btnSwitchCaseDefault = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.textBox2 = new System.Windows.Forms.TextBox();
            this.btnDoAndWhile = new System.Windows.Forms.Button();
            this.btnForEach = new System.Windows.Forms.Button();
            this.btnFor = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // BtnUnhandledException
            // 
            this.BtnUnhandledException.Location = new System.Drawing.Point(25, 257);
            this.BtnUnhandledException.Name = "BtnUnhandledException";
            this.BtnUnhandledException.Size = new System.Drawing.Size(123, 23);
            this.BtnUnhandledException.TabIndex = 1;
            this.BtnUnhandledException.Text = "Unhandled Exception";
            this.BtnUnhandledException.UseVisualStyleBackColor = true;
            this.BtnUnhandledException.Click += new System.EventHandler(this.BtnUnhandledException_Click);
            // 
            // btnTryCatch
            // 
            this.btnTryCatch.Location = new System.Drawing.Point(25, 286);
            this.btnTryCatch.Name = "btnTryCatch";
            this.btnTryCatch.Size = new System.Drawing.Size(123, 23);
            this.btnTryCatch.TabIndex = 2;
            this.btnTryCatch.Text = "try .. catch";
            this.btnTryCatch.UseVisualStyleBackColor = true;
            this.btnTryCatch.Click += new System.EventHandler(this.btnTryCatch_Click);
            // 
            // btnTryCatchFinally
            // 
            this.btnTryCatchFinally.Location = new System.Drawing.Point(25, 315);
            this.btnTryCatchFinally.Name = "btnTryCatchFinally";
            this.btnTryCatchFinally.Size = new System.Drawing.Size(123, 23);
            this.btnTryCatchFinally.TabIndex = 3;
            this.btnTryCatchFinally.Text = "try .. catch... finally";
            this.btnTryCatchFinally.UseVisualStyleBackColor = true;
            this.btnTryCatchFinally.Click += new System.EventHandler(this.btnTryCatchFinally_Click);
            // 
            // btnIf
            // 
            this.btnIf.Location = new System.Drawing.Point(25, 12);
            this.btnIf.Name = "btnIf";
            this.btnIf.Size = new System.Drawing.Size(123, 23);
            this.btnIf.TabIndex = 4;
            this.btnIf.Text = "If";
            this.btnIf.UseVisualStyleBackColor = true;
            this.btnIf.Click += new System.EventHandler(this.btnIf_Click);
            // 
            // btnIfElse
            // 
            this.btnIfElse.Location = new System.Drawing.Point(25, 41);
            this.btnIfElse.Name = "btnIfElse";
            this.btnIfElse.Size = new System.Drawing.Size(123, 23);
            this.btnIfElse.TabIndex = 5;
            this.btnIfElse.Text = "If...Else";
            this.btnIfElse.UseVisualStyleBackColor = true;
            this.btnIfElse.Click += new System.EventHandler(this.btnIfElse_Click);
            // 
            // btnSwitchCase
            // 
            this.btnSwitchCase.Location = new System.Drawing.Point(25, 70);
            this.btnSwitchCase.Name = "btnSwitchCase";
            this.btnSwitchCase.Size = new System.Drawing.Size(123, 23);
            this.btnSwitchCase.TabIndex = 6;
            this.btnSwitchCase.Text = "switch....case";
            this.btnSwitchCase.UseVisualStyleBackColor = true;
            this.btnSwitchCase.Click += new System.EventHandler(this.btnSwitchCase_Click);
            // 
            // btnSwitchCaseDefault
            // 
            this.btnSwitchCaseDefault.Location = new System.Drawing.Point(25, 99);
            this.btnSwitchCaseDefault.Name = "btnSwitchCaseDefault";
            this.btnSwitchCaseDefault.Size = new System.Drawing.Size(123, 23);
            this.btnSwitchCaseDefault.TabIndex = 7;
            this.btnSwitchCaseDefault.Text = "switch....case...default";
            this.btnSwitchCaseDefault.UseVisualStyleBackColor = true;
            this.btnSwitchCaseDefault.Click += new System.EventHandler(this.btnSwitchCaseDefault_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Comic Sans MS", 11.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(170, 8);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(118, 21);
            this.label1.TabIndex = 8;
            this.label1.Text = "First Text Box";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Comic Sans MS", 11.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(170, 208);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(135, 21);
            this.label2.TabIndex = 9;
            this.label2.Text = "Second Text Box";
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(173, 38);
            this.textBox1.Multiline = true;
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(258, 154);
            this.textBox1.TabIndex = 10;
            // 
            // textBox2
            // 
            this.textBox2.Location = new System.Drawing.Point(173, 232);
            this.textBox2.Multiline = true;
            this.textBox2.Name = "textBox2";
            this.textBox2.Size = new System.Drawing.Size(258, 154);
            this.textBox2.TabIndex = 11;
            // 
            // btnDoAndWhile
            // 
            this.btnDoAndWhile.Location = new System.Drawing.Point(25, 202);
            this.btnDoAndWhile.Name = "btnDoAndWhile";
            this.btnDoAndWhile.Size = new System.Drawing.Size(123, 23);
            this.btnDoAndWhile.TabIndex = 14;
            this.btnDoAndWhile.Text = "do..and...while";
            this.btnDoAndWhile.UseVisualStyleBackColor = true;
            this.btnDoAndWhile.Click += new System.EventHandler(this.btnDoAndWhile_Click);
            // 
            // btnForEach
            // 
            this.btnForEach.Location = new System.Drawing.Point(25, 173);
            this.btnForEach.Name = "btnForEach";
            this.btnForEach.Size = new System.Drawing.Size(123, 23);
            this.btnForEach.TabIndex = 13;
            this.btnForEach.Text = "foreach";
            this.btnForEach.UseVisualStyleBackColor = true;
            this.btnForEach.Click += new System.EventHandler(this.btnForEach_Click);
            // 
            // btnFor
            // 
            this.btnFor.Location = new System.Drawing.Point(25, 144);
            this.btnFor.Name = "btnFor";
            this.btnFor.Size = new System.Drawing.Size(123, 23);
            this.btnFor.TabIndex = 12;
            this.btnFor.Text = "for";
            this.btnFor.UseVisualStyleBackColor = true;
            this.btnFor.Click += new System.EventHandler(this.btnFor_Click);
            // 
            // Form7
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(454, 394);
            this.Controls.Add(this.btnDoAndWhile);
            this.Controls.Add(this.btnForEach);
            this.Controls.Add(this.btnFor);
            this.Controls.Add(this.textBox2);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.btnSwitchCaseDefault);
            this.Controls.Add(this.btnSwitchCase);
            this.Controls.Add(this.btnIfElse);
            this.Controls.Add(this.btnIf);
            this.Controls.Add(this.btnTryCatchFinally);
            this.Controls.Add(this.btnTryCatch);
            this.Controls.Add(this.BtnUnhandledException);
            this.MaximumSize = new System.Drawing.Size(462, 428);
            this.MinimumSize = new System.Drawing.Size(462, 428);
            this.Name = "Form7";
            this.Text = "Manejo De Instrcciones";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button BtnUnhandledException;
        private System.Windows.Forms.Button btnTryCatch;
        private System.Windows.Forms.Button btnTryCatchFinally;
        private System.Windows.Forms.Button btnIf;
        private System.Windows.Forms.Button btnIfElse;
        private System.Windows.Forms.Button btnSwitchCase;
        private System.Windows.Forms.Button btnSwitchCaseDefault;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.TextBox textBox2;
        private System.Windows.Forms.Button btnDoAndWhile;
        private System.Windows.Forms.Button btnForEach;
        private System.Windows.Forms.Button btnFor;

    }
}