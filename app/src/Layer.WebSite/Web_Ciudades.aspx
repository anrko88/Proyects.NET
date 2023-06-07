<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Web_Ciudades.aspx.cs" Inherits="Default2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Página sin título</title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="text-align: center">
        &nbsp;<br />
        <br />
        <table border="2" style="width: 364px; height: 188px">
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 100px">
                    <asp:Label ID="Label1" runat="server" Font-Bold="True" Text="CIUDADES :"></asp:Label></td>
                <td style="width: 99px">
                    <asp:DropDownList ID="DropDownList1" runat="server">
                    </asp:DropDownList></td>
                <td style="width: 99px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px; height: 23px">
                </td>
                <td style="width: 100px; height: 23px">
                </td>
                <td style="width: 99px; height: 23px">
                </td>
                <td style="width: 99px; height: 23px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                    <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="CIUDADES :"></asp:Label></td>
                <td style="width: 100px">
                    <asp:Label ID="lbl1" runat="server" Font-Bold="True" Text="EMPLEADOS :"></asp:Label></td>
                <td style="width: 99px">
                    <asp:Label ID="Label3" runat="server" Font-Bold="True" Text="CIUDADES :"></asp:Label></td>
                <td style="width: 99px">
                    <asp:Label ID="lbl2" runat="server" Font-Bold="True" Text="lbl2"></asp:Label></td>
            </tr>
            <tr>
                <td style="width: 100px; height: 28px">
                </td>
                <td style="width: 100px; height: 28px">
                </td>
                <td style="width: 99px; height: 28px">
                </td>
                <td style="width: 99px; height: 28px">
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:GridView ID="GridView1" runat="server">
                    </asp:GridView>
                </td>
                <td colspan="2">
                    <asp:GridView ID="GridView2" runat="server">
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 100px">
                </td>
                <td style="width: 99px">
                </td>
                <td style="width: 99px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px">
                </td>
                <td style="width: 100px">
                </td>
                <td style="width: 99px">
                </td>
                <td style="width: 99px">
                </td>
            </tr>
        </table>
    
    </div>
    </form>
</body>
</html>
