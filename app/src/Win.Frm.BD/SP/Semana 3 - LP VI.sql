Create proc usp_Categorias
As
Select CategoryID,CategoryName From Categories
Go

Create proc usp_ProdporCategoria
@CategoryID int
As
Select ProductID,ProductName From Products Where
 CategoryID=@CategoryID 
Go

Exec usp_ProdporCategoria 1

--Mostrar las ordenes pares que se hayan vendido en los 
--meses impares de los año pares,de los productos seleccionados. 
Create procedure usp_OrdenesporProductos
@idProductos varchar(100)--- '1,2,3,4'
As
Exec('Select O.OrderID,OrderDate,year(OrderDate) as Año,
 Datename(Month,OrderDate) as Mes,Sum(UnitPrice*Quantity) as
 VentaporPedido From Orders O,[Order Details] od Where
 O.OrderID=od.OrderID and O.OrderID%2=0 and Month(OrderDate)%2=1
 and year(OrderDate)%2=0 and ProductID in('+@idProductos+')
 Group by O.OrderID,OrderDate Order by VentaporPedido desc')
Go

Exec usp_OrdenesporProductos '1,2,3'

Create proc usp_ProductosVendidos
@OrderID int
As
Select P.ProductID,ProductName,P.UnitPrice,Quantity,
P.UnitPrice*Quantity as Total From Products P,
[Order Details] od Where P.ProductID=od.ProductID and
OrderID=@OrderID 
Go

Exec usp_ProductosVendidos 10248

******************************************
CREATE PROC Usp_MostrarCLiente
as
SELECT CustomerID, CompanyName ,ContactName FROM Customers 
