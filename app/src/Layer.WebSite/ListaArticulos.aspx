<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="ListaArticulos.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="text-align: center">
        <asp:Label ID="Label1" runat="server" Font-Bold="True" Font-Size="14pt" Text="TIENDA VIRTUAL DE VENTA DE EQUIPOS"></asp:Label><br />
        <br />
        <table border="5">
            <tr>
                <td style="width: 100px">
                </td>
                <td colspan="2" style="text-align: right">
                    <strong>Busqueda de Productos :</strong></td>
                <td colspan="2">
                    <asp:TextBox ID="TextBox1" runat="server" OnTextChanged="TextBox1_TextChanged" Width="293px"></asp:TextBox></td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <strong>Resultad de Busqueda :</strong></td>
                <td style="width: 100px">
                </td>
                <td style="width: 100px">
                </td>
                <td colspan="2">
                    <asp:Button ID="Button1" runat="server" Font-Bold="True" OnClick="Button1_Click"
                        Text="Ver Canasta" Width="160px" /></td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td colspan="4" rowspan="4">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White"
                        BorderColor="#CC9966" BorderStyle="None" BorderWidth="1px" CellPadding="4" Width="481px">
                        <FooterStyle BackColor="#FFFFCC" ForeColor="#330099" />
                        <Columns>
                            <asp:BoundField DataField="Art_cod" HeaderText="Codigo" />
                            <asp:BoundField DataField="Art_nom" HeaderText="Articulos" />
                            <asp:BoundField DataField="Art_pre" HeaderText="Precio" />
                            <asp:BoundField DataField="Art_stk" HeaderText="Stock" />
                            <asp:TemplateField HeaderText="Comprar">
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBox1" runat="server" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Imagen">
                                <ItemTemplate>
                                    <asp:Image ID="Image1" runat="server" Height="47px" ImageUrl='<%# Eval("art_cod","imagenes/{0}.jpg") %>'
                                        Width="51px" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <RowStyle BackColor="White" ForeColor="#330099" />
                        <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="#663399" />
                        <PagerStyle BackColor="#FFFFCC" ForeColor="#330099" HorizontalAlign="Center" />
                        <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="#FFFFCC" />
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
                <td style="width: 100px; height: 62px;">
                </td>
                <td style="width: 100px; height: 62px;">
                </td>
            </tr>
            <tr>
                <td style="width: 100px; height: 51px">
                </td>
                <td style="width: 100px; height: 51px">
                </td>
            </tr>
        </table>
    
    </div>
    </form>
</body>
</html>
