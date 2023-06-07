<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VentasClientes.aspx.cs" Inherits="VentasClientes" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="text-align: center">
        <table border="4">
            <tr>
                <td style="width: 100px">
                </td>
                <td colspan="2" style="text-align: center">
                    <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="INGRESAR DATOS PARA LA VENTA"></asp:Label></td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 161px; text-align: right">
                    <strong>Nro.Factura :</strong></td>
                <td style="width: 100px">
                    <asp:Label ID="lblFactura" runat="server" Font-Bold="True"></asp:Label></td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 161px; text-align: right">
                    <strong>Cliente :</strong></td>
                <td style="width: 100px">
                    <asp:DropDownList ID="DropDownList1" runat="server" Width="240px">
                    </asp:DropDownList></td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 161px; text-align: right">
                    <strong>Aplica Igv :</strong></td>
                <td style="width: 100px">
                    <asp:CheckBox ID="CheckBox1" runat="server" Width="152px" />
                 </td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 161px; text-align: right">
                    <strong>Fecha de Compra :</strong></td>
                <td style="width: 100px">
                    <asp:Label ID="lblFecha" runat="server" Font-Bold="True"></asp:Label></td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 161px; text-align: right">
                    <strong>Total de Compra :</strong></td>
                <td style="width: 100px">
                    <asp:Label ID="lblTotalCompra" runat="server" Font-Bold="True"></asp:Label></td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px; height: 23px">
                </td>
                <td style="width: 161px; height: 23px; text-align: right">
                    <strong>Igv (19%) :</strong></td>
                <td style="width: 100px; height: 23px">
                    <asp:Label ID="lbligv" runat="server" Font-Bold="True"></asp:Label></td>
                <td style="width: 100px; height: 23px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 161px">
                </td>
                <td style="width: 100px">
                </td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td colspan="2" rowspan="6">
                    <asp:GridView ID="GridView1" runat="server" BackColor="White" BorderColor="#CCCCCC"
                        BorderStyle="None" BorderWidth="1px" CellPadding="3" Width="479px">
                        <FooterStyle BackColor="White" ForeColor="#000066" />
                        <Columns>
                            <asp:TemplateField HeaderText="Imagen">
                                <ItemTemplate>
                                    <asp:Image ID="Image1" runat="server" Height="44px" ImageUrl='<%# Eval("codigo","imagenes/{0}.jpg") %>'
                                        Width="44px" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <RowStyle ForeColor="#000066" />
                        <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                        <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
                    </asp:GridView>
                </td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 161px">
                    <asp:Button ID="Button1" runat="server" Text="Cancelar Compra" OnClick="Button1_Click" /></td>
                <td style="width: 100px">
                    <asp:Button ID="Button2" runat="server" Text="Realizar Compra" OnClick="Button2_Click" /></td>
                <td style="width: 100px">
                    <asp:Button ID="Button3" runat="server" Font-Bold="True" Text="Reporte" Width="95px" OnClick="Button3_Click" /></td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:HyperLink ID="HyperLink1" runat="server" Font-Bold="True" NavigateUrl="~/ListaArticulos.aspx"><< Pagina Principal</asp:HyperLink></td>
                <td style="width: 100px">
                </td>
                <td style="width: 100px">
                </td>
            </tr>
        </table>
        <br />
        <asp:ListBox ID="ListBox1" runat="server" Height="85px" Width="274px"></asp:ListBox></div>
    </form>
</body>
</html>
