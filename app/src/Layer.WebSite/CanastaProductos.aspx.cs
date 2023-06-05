using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class CanastaProductos : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            GridView1.DataSource = Session["productos"];
            GridView1.DataBind();
        }
    }
    protected void CmdEliminar_Click(object sender, EventArgs e)
    { //para eliminar los productos creamos una tabla en memoria
        DataTable tblproductos = new DataTable();
        tblproductos.Columns.Add(new DataColumn("codigo",typeof(string)));
        tblproductos.Columns.Add(new DataColumn("Descripcion",typeof(string)));
        tblproductos.Columns.Add(new DataColumn("Precio",typeof(double)));
        tblproductos.Columns.Add(new DataColumn("Cantidad",typeof(int)));
        tblproductos.Columns.Add(new DataColumn("Total",typeof(double), "Precio*Cantidad"));
        DataRow dr;
        //cargar los datos de la variable de session a un DataTable
        DataTable tblarticulos = (DataTable)Session["productos"];
        //recorriendo todos las filas del DataTable tblarticulos
        for (int i = 0; i < tblarticulos.Rows.Count; i++)
        {   //recuperando el estado del CheckBox 
            CheckBox chk =
                (CheckBox)GridView1.Rows[i].FindControl("CheckBox1");
       //preguntando solo los elementos que no han sido seleccionados
            if (chk.Checked == false)
            {  //agregando una nueva fila en tblproductos
                dr = tblproductos.NewRow();
                //guardando los articulos que no han sido seleccionados
                dr[0] = tblarticulos.Rows[i][0].ToString(); //codigo
                dr[1] = tblarticulos.Rows[i][1].ToString();//descripcion
             dr[2] = Convert.ToDouble(tblarticulos.Rows[i][2]);//precio
             dr[3] = Convert.ToInt16(tblarticulos.Rows[i][3]);//cantidad
             //guardando el producto que no fue eliminado
             tblproductos.Rows.Add(dr);
            }
        }
        //actualizando la variable de session
        Session["productos"] = tblproductos;
        GridView1.DataSource = Session["productos"];
        GridView1.DataBind();
        //sumando la columna Total de tblproductos con Compute
        double totalventa =
     tblproductos.Compute("sum(Total)", "").Equals(DBNull.Value) ?
     0 : Convert.ToDouble(tblproductos.Compute("sum(Total)", ""));
        lblTotales.Text=String.Format("El total de Venta es:{0}",
                    totalventa.ToString("c"));
    }
    protected void CmdTotalizar_Click(object sender, EventArgs e)
    {
        double totalventa = 0;
        //recorrer el Gridview, recuperando la cantidad de la caja
        //de texto
        for (int i = 0; i < GridView1.Rows.Count; i++)
        {
            TextBox txtcantidad =
             (TextBox)GridView1.Rows[i].FindControl("txtcantidad");
            if (txtcantidad.Text != "")
            {
                double Nuevototal =
                Convert.ToDouble(GridView1.Rows[i].Cells[2].Text) *
                  Convert.ToInt16(txtcantidad.Text);
                //agregando el nuevo total en columna total celda 4
                GridView1.Rows[i].Cells[4].Text = Nuevototal.ToString();
                //sumando la columna total
                totalventa += Convert.ToDouble(
                     GridView1.Rows[i].Cells[4].Text);
            }
        }
        //guardando el total de venta en un variable de sesion
        Session["venta"] = totalventa;
        lblTotales.Text = String.Format("El total de venta es:{0}",
            totalventa.ToString("c"));
        ActualizarSession();
    }
    void ActualizarSession()
    {
        //cargando los datos de la variable de session,con la 
        //cantidad anterior
        DataTable tbl = (DataTable)Session["productos"];
        for (int i = 0; i < GridView1.Rows.Count; i++)
        { //recuperar la cantidad ingresada en la caja de texto del
            //Gridview1
            TextBox txtcantidad =
                (TextBox)GridView1.Rows[i].FindControl("txtcantidad");
            //actualizando la nueva cantidad al datatable
            tbl.Rows[i][3] = Convert.ToInt16(txtcantidad.Text);          
        }
        //Actualizando la variable de session con la nueva cantidad
        Session["productos"] = tbl;
    }
    protected void CmdCompra_Click(object sender, EventArgs e)
    {
        Response.Redirect("ventasclientes.aspx");
    }
}
