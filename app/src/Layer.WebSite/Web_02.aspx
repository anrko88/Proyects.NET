<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Web_02.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Página sin título</title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="text-align: center">
        <table border="2" style="width: 896px; height: 206px; text-align: center">
            <tr>
                <td rowspan="8" style="width: 100px">
                    &nbsp;<asp:RadioButtonList ID="RadioButtonList1" runat="server" AutoPostBack="True"
                        Height="243px" OnSelectedIndexChanged="RadioButtonList1_SelectedIndexChanged" Font-Bold="True" Font-Size="Larger" ForeColor="Black" Width="150px">
                        <asp:ListItem Value="1">Consulta 1</asp:ListItem>
                        <asp:ListItem Value="2">Consulta 2</asp:ListItem>
                        <asp:ListItem Value="3">Consulta 3</asp:ListItem>
                    </asp:RadioButtonList>&nbsp;</td>
                <td style="width: 100px">
                    <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="FECHA INICIAL" Width="216px"></asp:Label></td>
                <td style="width: 100px">
                </td>
                <td style="width: 100px">
                    <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="FECHA INICIAL" Width="198px"></asp:Label></td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                    <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox></td>
                <td style="width: 100px">
                    Y</td>
                <td style="width: 100px">
                    <asp:TextBox ID="TextBox2" runat="server"></asp:TextBox></td>
                <td style="width: 100px">
                    <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="CONSULTA" Font-Bold="True" /></td>
            </tr>
            <tr>
                <td colspan="4">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                    <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="CATEGORIAS"></asp:Label></td>
                <td style="width: 100px" rowspan="2">
                </td>
                <td style="width: 100px">
                    <asp:Label ID="Label4" runat="server" Font-Bold="True" Text="PRODUCTOS X CATEGORIAS"
                        Width="223px"></asp:Label></td>
                <td style="width: 100px" rowspan="2">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                    <asp:ListBox ID="ListBox1" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ListBox1_SelectedIndexChanged"
                        Width="256px" Font-Bold="True"></asp:ListBox></td>
                <td style="width: 100px">
                    <asp:ListBox ID="ListBox2" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ListBox2_SelectedIndexChanged"
                        Width="244px"></asp:ListBox></td>
            </tr>
            <tr>
                <td colspan="4">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                    <asp:Label ID="Label5" runat="server" Font-Bold="True" Text="AÑOS DE ORDENES EMITIDAS"
                        Width="245px"></asp:Label></td>
                <td style="width: 100px" rowspan="2">
                </td>
                <td style="width: 100px" rowspan="2">
                    <br />
                    &nbsp;</td>
                <td style="width: 100px" rowspan="2">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                    <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged"
                        Width="192px">
                    </asp:DropDownList></td>
            </tr>
            <tr>
                <td colspan="5" rowspan="1">
                </td>
            </tr>
            <tr>
                <td rowspan="3" style="width: 100px">
                </td>
                <td colspan="2">
                    <asp:Label ID="Label6" runat="server" Font-Bold="True" Text="SUMA TOTAL POR CONSULTA :"
                        Width="245px"></asp:Label>
                </td>
                <td style="width: 100px">
                    <asp:Label ID="lblsumaTotal" runat="server" Font-Bold="True" Text="lblsumaTotal"
                        Width="245px"></asp:Label></td>
                <td style="width: 100px" rowspan="3">
                </td>
            </tr>
            <tr>
                <td colspan="3" rowspan="2">
                    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" PageSize="5" ShowFooter="True"
                        Width="561px" CellPadding="4" ForeColor="#333333" GridLines="None">
                        <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
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
            </tr>
        </table>
    
    </div>
    </form>
</body>
</html>
