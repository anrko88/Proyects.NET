<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default2.aspx.cs" Inherits="Default2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body style="text-align: center">
    <form id="form1" runat="server">
    <div>
    
    </div>
        <br />
        <table border="1">
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 100px">
                    <asp:Label ID="Label1" runat="server" Font-Bold="True" Font-Size="14pt" ForeColor="#0099FF"
                        Text="DETALLE DE ORDENES POR EMPLEADOS" Width="468px"></asp:Label></td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 100px">
                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" Height="96px"
                        Width="472px">
                        <Columns>
                            <asp:BoundField HeaderText="OrderId" DataField="OrderID" />
                            <asp:BoundField HeaderText="ProductID" DataField="ProductID" />
                            <asp:BoundField HeaderText="ProductName" DataField="ProductName" />
                            <asp:BoundField HeaderText="Quantity" DataField="Quantity" />
                        </Columns>
                    </asp:GridView>
                </td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 100px">
                    <asp:HyperLink ID="HyperLink1" runat="server" Font-Bold="True" NavigateUrl="~/Default.aspx">Regresar</asp:HyperLink></td>
                <td style="width: 100px">
                </td>
            </tr>
        </table>
        &nbsp;
    </form>
</body>
</html>
