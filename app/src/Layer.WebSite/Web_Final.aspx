<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Web_Final.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Página sin título</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table style="width: 574px; height: 497px" border="2">
            <tr>
                <td colspan="3" style="text-align: center">
                    <strong>LISTADO DE CATEGORIAS</strong></td>
            </tr>
            <tr>
                <td colspan="3">
                    <asp:GridView ID="GridView1" runat="server" CellPadding="4" ForeColor="#333333" GridLines="None"
                        Width="568px">
                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                        <Columns>
                            <asp:TemplateField HeaderText="Seleccionar">
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBox1" runat="server" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <RowStyle BackColor="#EFF3FB" />
                        <EditRowStyle BackColor="#2461BF" />
                        <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                        <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                        <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                        <AlternatingRowStyle BackColor="White" />
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td colspan="3" style="text-align: center">
                    <asp:Button ID="BtnMostrar" runat="server" OnClick="Button1_Click" Text="Mostrar" ForeColor="Black" Width="213px" /></td>
            </tr>
            <tr>
                <td style="text-align: center;" colspan="3">
                    <strong>PRODUCTOS POR CATEGORIAS SELECCIONADAS</strong></td>
            </tr>
            <tr>
                <td colspan="3">
                    <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" BackColor="White"
                        BorderColor="#CCCCCC" BorderWidth="1px" CellPadding="3" BorderStyle="None" Height="169px" Width="572px">
                        <FooterStyle BackColor="White" ForeColor="#000066" />
                        <Columns>
                            <asp:BoundField DataField="ProductID" HeaderText="ProductID" />
                            <asp:BoundField DataField="ProductName" HeaderText="ProductName" />
                            <asp:BoundField DataField="CategoryID" HeaderText="CategoryID" />
                            <asp:TemplateField HeaderText="UnitsInStock">
                                <ItemTemplate>
                                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Eval("UnitsInStock") %>' Width="84px"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Unitprice">
                                <ItemTemplate>
                                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Eval("UnitPrice") %>' Width="97px"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <SelectedRowStyle BackColor="#669999" ForeColor="White" Font-Bold="True" />
                        <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
                        <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
                        <RowStyle ForeColor="#000066" />
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 100px; text-align: center;">
                    <asp:Button ID="BtnActualizar" runat="server" OnClick="Button2_Click" Text="Actualizar Stock y Precios" /></td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 100px">
                    <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label></td>
                <td style="width: 100px">
                </td>
            </tr>
        </table>
    
    </div>
    </form>
</body>
</html>
