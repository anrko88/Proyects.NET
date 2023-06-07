using Layer.Entidad;
using Layer.Negocio;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page 
{
  
    EN_Aplicacion2 objEN = new EN_Aplicacion2();
    //int index = 0;
    protected void Page_Load(object sender, EventArgs e)
    {  
        if (!Page.IsPostBack)
        {
            DataTable tbl = NE_Aplicacion2.CustomersNEG();
            GridView1.DataSource = tbl;
            GridView1.DataBind();
        }
    }
    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
      /*  if (GridView1.SelectedRow = DataControlRowType.DataRow)
        {
            Button b = GridView1.SelectedRow.Cells(1);
     
        }*/

    }
    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
      
    }
    /*
    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {  //recuperando el año de venta y enviar a la entidad
        objEN.Años = Convert.ToInt16(DropDownList1.Text);
        DataList1.DataSource = NE_PAG01.EmpleadosporAñosBL(objEN);
        DataList1.DataBind();
    }
    protected void Button1_Click(object sender, EventArgs e)
    { //recuperando los items seleccionados del DataList1
        string codigos = ""; //recuperar los codigos de los empleados
        //recorrer el DataList1
        for (int i = 0; i < DataList1.Items.Count - 1; i++)
        { //recuperando el estado del CheckBox seleccionado
          CheckBox chk = (CheckBox)DataList1.Items[i].FindControl("CheckBox1");
          if (chk.Checked == true)
          { //recuperando el codigo del Label de EmployeeID
          Label EmployeeID = (Label)DataList1.Items[i].FindControl("Label3");
             //concatenando los codigos recuperados
            codigos += EmployeeID.Text + ",";
          }
        }
        if (codigos.Length == 0)
        {
            LBLMENSAJE.Text = "No ha Seleccionado ningun Empleados";
            return;
        }
        //quitando la coma sobrante de la cadena '1,2,3,'
        codigos = codigos.Substring(0, codigos.Length - 1);
        //guardando los codigos en una variable de session
        Session["codigos"] = codigos;
        Response.Redirect("Default2.aspx");
    }*/

   
}
