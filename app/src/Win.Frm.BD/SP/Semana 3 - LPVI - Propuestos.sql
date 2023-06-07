SELECT * FROM Orders  SELECT * FROM [Order Details]  SELECT * FROM Products 
---------------------------------------
CREATE  PROC USp_PaisesPorOrdenes
as
--SELECT distinct ShipCountry FROM Orders --WHERE ShipCountry=@ShipCountry 
select distinct country,CustomerID from customers
GO
EXEC USp_PaisesPorOrdenes 
go
------------------------------------------
create PROC Usp_OrdenesEmitidasPorPais
@ShipCountry VARCHAR(15)
as 
SELECT orderId,OrderDate,ShippedDate ,Freight  FROM Orders  
WHERE  ShipCountry=@ShipCountry 
GO
EXEC Usp_OrdenesEmitidasPorPais 'france' 
go
-------------------------------------------------------------------
CREATE  PROC Usp_DetalleOrden
@OrderId CHAR(5)
--@ShipCountry VARCHAR(15)
as
SELECT --od.orderid,
p.ProductId,p.ProductName ,od.UnitPrice ,od.Quantity ,
(od.UnitPrice * od.Quantity)AS Total FROM Products p,
[ORDER details] od ,Orders o
WHERE o.OrderID =od.OrderID AND p.ProductID =od.ProductID 
AND o.OrderID =@OrderId --AND ShipCountry=@ShipCountry
GO
EXEC Usp_DetalleOrden '10248' --,'france'
go
*************************************************************
*************************************************************
SELECT * FROM Customers SELECT * FROM Orders  ORDER BY CustomerID 
SELECT * FROM [Order Details]  SELECT * FROM Products 
 SELECT * FROM EMPLOYEES 
--------------------------------------------------
CREATE  PROC Usp_CustomersBusqueda
@Customers VARCHAR(30)
as
SELECT c.CustomerID, c.companyName ,count(o.orderid)AS Nro_Ordenes,
[Tipo_Cliente]=(CASE WHEN count(o.orderid)>10 THEN 'Cliente_Vip'
 ELSE 'Normal' End) FROM Customers c ,Orders o
WHERE c.CustomerID=o.CustomerID AND 
c.CompanyName  LIKE @Customers+'%'  --'['+@Letras+']%' 
GROUP BY c.CustomerID,c.CompanyName 
GO
EXEC Usp_CustomersBusqueda 'a' --'Antonio Moreno Taquería'
GO
-----------------------------------------------------------
CREATE PROC Usp_CustomersEncontrados
@CustomerId VARCHAR(5)
AS
SELECT  o.OrderID,convert(VARCHAR(10),o.OrderDate,101),o.Freight 
FROM Orders o, [Order Details] od
WHERE o.OrderID=od.OrderID AND o.CustomerID=@CustomerId
GROUP BY o.OrderID,o.OrderDate,o.Freight 
GO
EXEC Usp_CustomersEncontrados 'anton' 
GO
********************************************************************
********************************************************************
-------------- PUBS---------------------
create proc Usp_BUBSPaises
as
select distinct country  from publishers
go
-----------------------------------------------
create proc Usp_PUBSEditoriales
@Pais varchar(30)
as
select pub_Id,pub_Name from publishers
where country=@pais
go
exec Usp_PUBSEditoriales 'USA'
----------------------------------
create proc Usp_PUBSLibros		--select * from titles  select * from publishers
@pub_id varchar(5)
as
select * from titles --t,publishers p
where pub_id='0877' --and country=@country  and pub_name=@pub_name
go
exec Usp_PUBSLibros '0877' --'USA','Binnet & Hardley'
********************************************************************
********************************************************************
CREATE PROC Usp_ConsDePedidosDeFechas 
@fecha1 VARCHAR (10),
@fecha2 VARCHAR (10)
as
SELECT o.OrderID AS IdPedido, convert(VARCHAR(10) ,
ShippedDate,101)AS Fecha_Entrega,shipName AS Destinatario ,
SUM(Quantity)AS Cant_Productos
FROM  Orders o , [Order Details] od WHERE o.OrderID =od.OrderID 
AND ShippedDate BETWEEN  @fecha1 AND @fecha2  
GROUP BY o.OrderID,ShippedDate,ShipName
GO
EXEC Usp_ConsDePedidosDeFechas '02/02/1996','07/02/1998'  
**********************************************************************
CREATE PROC Usp_Porcentaje
as       
SELECT  c.CategoryId,c.CategoryName ,Porcentaje=
convert(CHAR(5),convert(DECIMAL(5,2),round((sum(p.UnitsInStock)*100.0) /
(SELECT sum(UnitsInStock) FROM  Products),2))) + '% ' 
FROM Products p,Categories  c WHERE p.CategoryID=c.CategoryID 
GROUP BY c.CategoryID,c.CategoryName 
GO
EXEC usp_porcentaje















