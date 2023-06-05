using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Layer.Entidad;
using Layer.Negocio;

public partial class _Default : System.Web.UI.Page 
{
    Layer.Entidad.EN_Web02 objE = new Layer.Entidad.EN_Web02();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            GridView1.DataSource = null;
            DropDownList1.DataSource = NE_web02.Cons_AñoNEG();
            DropDownList1.DataTextField = "orderdate";
            DropDownList1.DataBind();
            ListBox1.DataSource = NE_web02.Cons_CategoriasNEG();
            ListBox1.DataTextField = "CategoryName";
            ListBox1.DataBind();
            this.TextBox1.Enabled = false;
            this.TextBox2.Enabled = false;
            this.ListBox1.Enabled = false;
            this.ListBox2.Enabled = false;
            this.DropDownList1.Enabled = false;
        }
       
    }
    protected void RadioButtonList1_SelectedIndexChanged(object sender, EventArgs e)
    {

        int num = Convert.ToInt16( RadioButtonList1.SelectedValue .ToString());
        if (num == 1)
        {
            this.TextBox1.Enabled = true;
            this.TextBox2.Enabled = true;
            this.ListBox1.Enabled = false;
            this.ListBox2.Enabled = false;
            this.DropDownList1.Enabled = false;
        }
        if (num == 2)
        {
            this.TextBox1.Enabled = false ;
            this.TextBox2.Enabled = false;
            this.DropDownList1.Enabled = false;
             this.ListBox1.Enabled = true;
             this.ListBox2.Enabled = true;
         }
        if (num == 3)
         {
             this.TextBox1.Enabled = false;
             this.TextBox2.Enabled = false;
             this.ListBox1.Enabled = false;
             this.ListBox2.Enabled = false;
          this.DropDownList1.Enabled = true;
         }
    
    }

    protected void ListBox1_SelectedIndexChanged(object sender, EventArgs e)
    {
        ListBox2.Items.Clear();
        string categoria = ListBox1.SelectedItem.Text;
        objE.CategoryName = categoria;
       DataTable tbl= NE_web02.Consulta02ANEG ( objE);
       for (int i = 0; i < tbl.Rows.Count; i++)
       {
           ListBox2.Items.Add(tbl.Rows[i][0].ToString() + " -- " +
                              tbl.Rows[i][1].ToString());
           ListBox2.DataBind();           
       }
       
    }
    protected void ListBox2_SelectedIndexChanged(object sender, EventArgs e)
    {
        string valorSelec = ListBox2.SelectedValue;
        string producto = valorSelec.Substring( valorSelec.IndexOf(" -- ")+4);
        objE.ProductName = producto;
        GridView1.DataSource = NE_web02.Consulta02BNEG(objE);
        GridView1.DataBind();
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        string fec1=TextBox1.Text ;
        string fec2=TextBox2.Text ;
        objE.Fecha1 = fec1;
        objE.Fecha2  = fec2;
        GridView1.DataSource = NE_web02.Consulta01NEG (objE);
        GridView1.DataBind();
    }
   
    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        GridView1.DataSource = "";
     
        int año = Convert.ToInt16( DropDownList1.Text);
        objE.Año = año;
        GridView1.DataSource = NE_web02.Consulta03NEG (objE);
        GridView1.DataBind();

    }
}
