<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Semana08.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="text-align: left">
        <br />
        <strong>Busqueda De Ordenes Por Cliente</strong><br />
        <br />
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="#CCCCCC"
            BorderColor="#999999" BorderStyle="Solid" BorderWidth="3px" CellPadding="4" CellSpacing="2"
            DataKeyNames="customerid" ForeColor="Black" Height="243px" Width="637px" OnRowCommand="GridView1_RowCommand" OnRowDataBound="GridView1_RowDataBound">
            <FooterStyle BackColor="#CCCCCC" />
            <Columns>
                <asp:TemplateField HeaderText="Customerid" SortExpression="customerid">
                    <ItemTemplate>
                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("customerid") %>'></asp:Label>&nbsp;
                        <asp:Label ID="Label3" runat="server" Text='<%# Eval("companyname") %>' Width="83px"></asp:Label><br />
                        <br />
                        <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" CellPadding="4"
                            ForeColor="#333333" GridLines="None" Width="593px">
                            <FooterStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <Columns>
                                <asp:BoundField DataField="customerid" HeaderText="customerid" />
                                <asp:BoundField DataField="orderid" HeaderText="order id" />
                                <asp:BoundField DataField="orderdate" HeaderText="orderdate" HtmlEncode="False" />
                                <asp:BoundField DataField="total" DataFormatString="{0:d}" HeaderText="total de ventas" />
                            </Columns>
                            <RowStyle BackColor="#EFF3FB" />
                            <EditRowStyle BackColor="#2461BF" />
                            <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
                            <HeaderStyle BackColor="#507CD1" Font-Bold="True" ForeColor="White" />
                            <AlternatingRowStyle BackColor="White" />
                        </asp:GridView>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemStyle VerticalAlign="Top" Width="10%" />
                    <ItemTemplate>
                 <asp:Button ID="btnmostrar" runat="server" CommandName="Mostrar" Text="Mostrar" />
           
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <RowStyle BackColor="White" />
            <SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#CCCCCC" ForeColor="Black" HorizontalAlign="Left" />
            <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
        </asp:GridView>
    
    </div>
    </form>
</body>
</html>
