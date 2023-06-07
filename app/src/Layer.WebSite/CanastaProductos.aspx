<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CanastaProductos.aspx.cs" Inherits="CanastaProductos" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="text-align: center">
        &nbsp;<asp:Label ID="Label1" runat="server" Font-Bold="True" Font-Size="16pt" Text="PRODUCTOS SELECCIONADOS"></asp:Label><br />
        <br />
        <table>
            <tr>
                <td style="width: 100px">
                    <asp:HyperLink ID="HyperLink1" runat="server" Font-Bold="True" NavigateUrl="~/ListaArticulos.aspx"
                        Width="141px">Seguir comprando</asp:HyperLink></td>
            </tr>
            <tr>
                <td style="width: 100px">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White"
                        BorderColor="#3366CC" BorderStyle="None" BorderWidth="1px" CellPadding="4" Width="638px">
                        <FooterStyle BackColor="#99CCCC" ForeColor="#003399" />
                        <Columns>
                            <asp:BoundField DataField="Codigo" HeaderText="Codigo" />
                            <asp:BoundField DataField="Descripcion" HeaderText="Descripcion" />
                            <asp:BoundField DataField="Precio" HeaderText="Precio" />
                            <asp:TemplateField HeaderText="Cantidad">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtcantidad" runat="server" Text='<%# Eval("Cantidad") %>' Width="51px"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtcantidad"
                                        Display="Dynamic" ErrorMessage="Ingrese una cantidad">*</asp:RequiredFieldValidator>
                                    <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="txtcantidad"
                                        Display="Dynamic" ErrorMessage="Ingrese solo numeros" Operator="DataTypeCheck"
                                        Type="Integer">*</asp:CompareValidator>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Total" HeaderText="Total" />
                            <asp:TemplateField HeaderText="Eliminar">
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBox1" runat="server" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Imagen">
                                <ItemTemplate>
                                    <asp:Image ID="Image1" runat="server" Height="55px" ImageUrl='<%# Eval("codigo","imagenes/{0}.jpg") %>'
                                        Width="63px" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <RowStyle BackColor="White" ForeColor="#003399" />
                        <SelectedRowStyle BackColor="#009999" Font-Bold="True" ForeColor="#CCFF99" />
                        <PagerStyle BackColor="#99CCCC" ForeColor="#003399" HorizontalAlign="Left" />
                        <HeaderStyle BackColor="#003399" Font-Bold="True" ForeColor="#CCCCFF" />
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                    <table border="3">
                        <tr>
                            <td style="width: 100px">
                                <asp:Button ID="CmdCompra" runat="server" Font-Bold="True" OnClick="CmdCompra_Click"
                                    Text="Aceptar Compra" /></td>
                            <td style="width: 100px">
                                <asp:Button ID="CmdEliminar" runat="server" Font-Bold="True" OnClick="CmdEliminar_Click"
                                    Text="Eliminar Productos" /></td>
                            <td style="width: 100px">
                                <asp:Button ID="CmdTotalizar" runat="server" Font-Bold="True" OnClick="CmdTotalizar_Click"
                                    Text="Totalizar Productos" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="width: 100px; height: 19px">
                    <asp:Label ID="lblTotales" runat="server" Font-Bold="True" Font-Size="11pt" Width="475px"></asp:Label></td>
            </tr>
        </table>
    </div>
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" Font-Bold="True" Width="424px" />
    </form>
</body>
</html>
