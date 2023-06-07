using Layer.Entidad;
using Layer.Negocio;
using System;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page 
{
    EN_Web01 objE = new EN_Web01();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            Label1.Visible = false; Label2.Visible = false;
            GridView1.DataSource = NE_Web01.Lista_01NEG ();
            GridView1.DataBind();            
        }
    }
    protected void btnMostrar_Click(object sender, EventArgs e)
    {
       try
        {
            Label1.Visible = true ;
            string employeeID = "";
            foreach (GridViewRow row in GridView1.Rows)
            {             
              CheckBox chk=(row.Cells [0].Controls [1] as CheckBox );
              if (chk.Checked==true)
                {employeeID = employeeID + "'" + row.Cells[1].Text + "',"; }            
            }
            employeeID = employeeID.Substring(0, employeeID.Length - 1);
            objE.Employeeid = employeeID;
            DataList1.DataSource = NE_Web01.Lista_02NEG(objE );
            DataList1.DataBind();
        }
        catch (Exception ex)
        {
            ex.ToString();
        }              
    }

    protected void btnMostrarProductos_Click(object sender, EventArgs e)
    {
        string  orderID = "";
        for (int i = 0; i < DataList1.Items.Count - 1; i++)
        {
            CheckBox chk = (CheckBox)DataList1.Items[i].FindControl("CheckBox1");
            if (chk.Checked == true)
            {
                Label EmployeeID = (Label)DataList1.Items[i].FindControl("Label3");
                orderID += EmployeeID.Text + ",";
            }
        }
        if (orderID.Length == 0)
        {
            Label2.Visible = true;
            return;
        }
     /*   else
        {  Label2.Visible = false ;     return;      }*/
        orderID = orderID.Substring(0, orderID.Length - 1);
        Session["orderid"]=orderID ;
        Response.Redirect("Default2.aspx");
    }
 
   
 
}
