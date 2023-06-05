using Layer.Entidad;
using Layer.Negocio;
using System;
using System.Data;
using System.Web.UI;

public partial class Default2 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        EN_Web01 objE = new EN_Web01();
        if (!Page.IsPostBack)
        {
            if (Convert.ToString(Session["orderid"]) == "")
            {
                return;
            }
             objE.OrderID  = Convert.ToString( Session["orderid"]);
             DataTable tbl = NE_Web01.Lista_DetalledeOrdenesDAL(objE);
             Session["p"] = tbl;
            GridView1.DataSource = tbl;
            GridView1.DataBind();
        }
    }
}
