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
    EN_Aplicacion1 objEN = new EN_Aplicacion1();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            GridView1.DataSource = NE_Aplicacion1.ListarArticuloNEG();
            GridView1.DataBind();
            //Preguntando si la variable de sesion es nula
            //para crear de nuevo la tabla temporal
            if (Session["productos"] == null)
            {
                TablaProductosSeleccionados();
            }
        }
    }
    void TablaProductosSeleccionados()
    {
        DataTable tblproductos = new DataTable();
        //definiendo sus campos del datatable
        tblproductos.Columns.Add(new DataColumn("codigo", typeof(string)));
        tblproductos.Columns.Add(new DataColumn("Descripcion", typeof(string)));
        tblproductos.Columns.Add(new DataColumn("Precio",  typeof(double)));
        tblproductos.Columns.Add(new DataColumn("Cantidad",typeof(int)));
        tblproductos.Columns.Add(new DataColumn("Total",typeof(double),"Precio*Cantidad"));
        //guardando la tabla en la session
        Session["productos"] = tblproductos;
    }
    protected void Button1_Click(object sender, EventArgs e)
    {//recuperando los productos seleccionados
        DataTable tblproductos = (DataTable)Session["productos"];
        DataRow dr; //fila de datos
        //recorriendo las filas del Gridview
        for (int i = 0; i < GridView1.Rows.Count; i++)
        {  //recuperando el estado del CheckBox
            CheckBox chk =
               (CheckBox)GridView1.Rows[i].FindControl("CheckBox1");
            if (chk.Checked == true)
            {  //agregando una fila al DataTable
                dr = tblproductos.NewRow();
                //validando con una funcion si el articulo existe
                if (BuscarArticuloExistente(
                  GridView1.Rows[i].Cells[0].Text) == -1)
                {
                    dr[0] = GridView1.Rows[i].Cells[0].Text; //codigo
                    dr[1] = GridView1.Rows[i].Cells[1].Text;//descrip..
                    dr[2] = Convert.ToDouble(
                        GridView1.Rows[i].Cells[2].Text);//precio
                    dr[3] = 1; //cantidad
                    tblproductos.Rows.Add(dr);
                }
            }
        }
        Session["productos"] = tblproductos;
        Response.Redirect("CanastaProductos.aspx");
    }
    private int BuscarArticuloExistente(string codigo)
    {
        DataView dv = new DataView();
        DataTable tbl = (DataTable)Session["productos"];
        dv = tbl.DefaultView;
        dv.Sort = "codigo";
        int existe = dv.Find(codigo);
        //existe=1 si el producto encuentra en la tabla
        //existe=-1 el producto no se encuentra en la tabla
        return existe; 
    }

    protected void TextBox1_TextChanged(object sender, EventArgs e)
    {
        objEN.Articulo = TextBox1.Text;
        GridView1.DataSource = NE_Aplicacion1.BusquedaArticulosNEG(objEN);
        GridView1.DataBind();
    }
}
