<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body style="font-size: 12pt">
    <form id="form1" runat="server">
    <div style="text-align: center">
        <table border="2">
            <tr>
                <td style="width: 100px">
                </td>
                <td colspan="2">
                    <strong><span style="font-size: 16pt; color: #0099ff">LISTADO DE EMPLEADOS </span></strong>
                </td>
                <td style="width: 94px">
                </td>
            </tr>
            <tr>
                <td colspan="4" style="height: 161px; text-align: center;">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White"
                        BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" Width="803px" ForeColor="Black" GridLines="Vertical">
                        <FooterStyle BackColor="#CCCC99" />
                        <Columns>
                            <asp:TemplateField HeaderText="Seleccionar">
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBox1" runat="server" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="EmployeeID" HeaderText="EmployeeID" />
                            <asp:BoundField DataField="LastName" HeaderText="LastName" />
                            <asp:BoundField DataField="cant_ordenes" HeaderText="Cant_Ordenes" />
                            <asp:BoundField HeaderText="Total_Vendido" DataField="total" />
                            <asp:BoundField HeaderText="% Venta" DataField="Porcentaje" />
                        </Columns>
                        <RowStyle BackColor="#F7F7DE" />
                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                        <AlternatingRowStyle BackColor="White" />
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td style="width: 100px; text-align: center">
                    </td>
                <td style="text-align: center;" colspan="2">
                    <asp:Button ID="btnMostrar" runat="server" OnClick="btnMostrar_Click" Text="Mostrar" /></td>
                <td style="width: 94px">
                </td>
            </tr>
            <tr>
                <td style="height: 23px" colspan="4">
                    <strong><span style="font-size: 16pt; color: #0099ff">
                        <asp:Label ID="Label1" runat="server" Text="LISTADO DE ORDENES POR EMPLEADOS"></asp:Label>&nbsp;</span></strong></td>
            </tr>
            <tr>
                <td colspan="4" style="text-align: center">
                    &nbsp;<asp:DataList ID="DataList1" runat="server" CellPadding="4" ForeColor="#333333"
                        RepeatColumns="5" Height="94px" Width="488px">
                        <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                        <SelectedItemStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
                        <ItemTemplate>
                            <table border="1" style="width: 181px; height: 132px">
                                <tr>
                                    <td style="width: 150px; height: 23px; text-align: right">
                                        <strong>OrderID :</strong></td>
                                    <td style="width: 120px; height: 23px">
                                        <asp:Label ID="Label3" runat="server" Text='<%# Eval("OrderID") %>' Width="66px" Font-Bold="True" ForeColor="#FF0066"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td style="width: 150px; text-align: right">
                                        <strong>EmployeeID</strong></td>
                                    <td style="width: 120px">
                                        <asp:Label ID="Label4" runat="server" Text='<%# Eval("EmployeeID") %>' Width="140px" Font-Bold="True" ForeColor="#FF0066"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td style="width: 150px; text-align: right">
                                        <strong>TotalOrden</strong></td>
                                    <td style="width: 120px">
                                        <asp:Label ID="Label5" runat="server" Text='<%# Eval("total") %>' Width="139px" Font-Bold="True" ForeColor="#FF0066"></asp:Label></td>
                                </tr>
                                <tr>
                                    <td colspan="2" rowspan="3" style="text-align: right">
                                    </td>
                                </tr>
                                <tr>
                                </tr>
                                <tr>
                                </tr>
                                <tr>
                                    <td style="width: 150px; text-align: right">
                                        <strong>Seleccionar :</strong></td>
                                    <td style="width: 120px">
                                        <asp:CheckBox ID="CheckBox1" runat="server" Font-Bold="True" ForeColor="#0099FF" /></td>
                                </tr>
                            </table>
                        </ItemTemplate>
                        <AlternatingItemStyle BackColor="White" />
                        <ItemStyle BackColor="#FFFBD6" ForeColor="#333333" />
                        <HeaderTemplate>
                            <span style="font-size: 14pt"></span>
                        </HeaderTemplate>
                        <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
                    </asp:DataList>
                    <asp:Label ID="Label2" runat="server" Font-Bold="True" Font-Size="14pt" ForeColor="#FF0066"
                        Text="NO SE AH SELECCIONADO NINGUNA ORDEN"></asp:Label></td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td style="text-align: center;" colspan="2">
                    <asp:Button ID="btnMostrarProductos" runat="server" Text="Mostrar Producto" OnClick="btnMostrarProductos_Click" /></td>
                <td style="width: 94px">
                </td>
            </tr>
        </table>
    
    </div>
    </form>
</body>
</html>
