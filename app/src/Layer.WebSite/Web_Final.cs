using Layer.Entidad;
using Layer.Negocio;
using System;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    EN_WebF objE = new EN_WebF();
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Page.IsPostBack)
        {
            GridView1.DataSource = NE_WebF.Lista_01NE();
            GridView1.DataBind();
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        try
        {
            string categoria = "";
            foreach (GridViewRow row in GridView1.Rows)
            {
                CheckBox chk = (row.Cells[0].Controls[1] as CheckBox);
                if (chk.Checked == true)
                {
                    categoria = categoria + "'" + row.Cells[1].Text + "',";
                }
            }
            categoria = categoria.Substring(0, categoria.Length - 1);
            objE.Categoria = categoria;
            GridView2.DataSource = NE_WebF.Lista_02NE(objE);
            GridView2.DataBind();
        }
        catch (Exception ex)
        {

        }              
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
           /* int    productID;
            int  unitsInStock;
            double unitPrice;*/
            for(int i=0;i<GridView2.Rows.Count;i++)
            {
                objE.ProductID  = Convert.ToInt16(GridView2.Rows[i].Cells[0].Text);
                objE.UnitsInStock = Convert.ToInt16(GridView2.Rows[i].Cells[3].Text);
                objE.UnitPrice  = Convert.ToDouble(GridView2.Rows[i].Cells[4].Text.ToString());
                NE_WebF.Lista_03NE (objE);
               // Label1.Text = Convert.ToString(unitsInStock);
            }
           

    }
}
/*
 productID = Convert.ToInt16 (GridView2.Rows[i].Cells[0].Text);
                unitsInStock = Convert.ToInt16 (GridView2.Rows[i].Cells[3].Text);
                unitPrice = Convert.ToDouble(GridView2.Rows[i].Cells[4].Text);
               objE.ProductID = Convert.ToInt16 (productID);
                objE.UnitsInStock =Convert.ToInt16 ( unitsInStock);
                objE.UnitPrice =Convert.ToDouble ( unitPrice);
               ne_web.Lista_03NE (objE);
                Label1.Text = Convert.ToString(unitsInStock)
 */