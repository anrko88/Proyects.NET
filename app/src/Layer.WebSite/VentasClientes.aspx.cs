using Layer.Entidad;
using Layer.Negocio;
using System;
public partial class VentasClientes : System.Web.UI.Page
{
    EN_Aplicacion1 objE = new EN_Aplicacion1();
   

    protected void Page_Load(object sender, EventArgs e)
    {
        GridView1.DataSource = Session["productos"];
        GridView1.DataBind();
        DropDownList1.DataSource = NE_Aplicacion1.ListarClientesNEG();
        DropDownList1.DataTextField = "cli_nom";
        DropDownList1.DataValueField  ="cli_cod";
        DropDownList1.DataBind();
        lblFactura.Text= NE_Aplicacion1.CodigoFacturaNEG();
        lblFecha.Text = DateTime.Now.ToString("dd/MM/yyyy");

        double total = 0;   
        for (int i = 0; i < GridView1.Rows.Count; i++)
        {
            total += Convert.ToDouble(GridView1.Rows[i].Cells[5].Text);
        }
        //lblTotalCompra.Text = Convert.ToString(total);
        lblTotalCompra.Text = String.Format(total.ToString("c"));               
    }  

    protected void Button2_Click(object sender, EventArgs e)
    {           
        double total = 0;
        for (int i = 0; i < GridView1.Rows.Count; i++)
        {
            total += 
                Convert.ToDouble(GridView1.Rows[i].Cells[5].Text);
        }
            
        double igv;
        string igv2;
        if (CheckBox1.Checked == true)
        {
            igv = Convert.ToDouble(total) * 019;
            lbligv.Text = Convert.ToString(igv);
            igv2 = "S";
        }
        else 
        { 
            lbligv.Text = Convert.ToString( 0);
                igv2 = "N";
        }

        objE.Fac_num = lblFactura.Text;
        objE.Fac_fec = Convert.ToDateTime(lblFecha.Text);
        objE.Cli_cod = DropDownList1.SelectedItem.Value;
        objE.Fac_igv = igv2;
        objE.Total = total;
        NE_Aplicacion1.GabrarCabeceraFacturaNEG(objE);
                
            string cod;
        int pre;
            int cant;
               
        for (int i = 0; i < GridView1.Rows.Count; i++)
        {
            cod = GridView1.Rows[i].Cells[1].Text;
            pre = Convert.ToInt16(GridView1.Rows[i].Cells[3].Text) ;
            cant = Convert.ToInt16(GridView1.Rows[i].Cells[4].Text);                 
            // ListBox1.Items.Add(cod + "\t" +pre +"\t" +cant );
            objE.Art_cod = cod;
            objE.Art_pre = Convert.ToDouble(pre);
            objE.Art_cant = Convert.ToInt16(cant);
            NE_Aplicacion1.GrabarDetalleNEG(objE);     
            }
        
               //   Session["productos"];
               // @fac_num,@fac_fec,@cli_cod,@fac_igv,@Total
     }  // @fac_num,@art_cod,@art_pre,@art_cant         
                    
          
    protected void Button1_Click(object sender, EventArgs e)
    {
        Response.Redirect("ListaArticulos.aspx");
    }  
    protected void Button3_Click(object sender, EventArgs e)
    {
        Response.Redirect("Reporte.aspx");
    }
  
}
/*
                string cod;
                string precio;
                string cant;
                objE.Art_cod = cod;
                objE.Art_pre = Convert.ToInt16(precio);
                objE.Art_cant = Convert.ToInt16(cant);*/