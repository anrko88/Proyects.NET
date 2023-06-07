--Semana12 LPII
--1.MOSTRAR TODOS LOS PAISES	
create procedure MostrarPaises  
as
select distinct country from customers
go

--2. MOSTRAR LOS CLIENTES POR PAIS
create procedure ClientesPorPais 
@country varchar(30)
as
select customerid, companyname from customers
where country=@country
go

--3. MOSTRAR 5 ORDENES CON MAYOR VENTA DE UN CLIENTE
create procedure OrdenesPorCliente
@customerid char(5)
as
select top 5 o.orderid,orderdate,shippeddate,
venta=sum(unitprice * quantity) from orders o,
[order details] od where o.orderid=od.orderid
and customerid=@customerid group by
o.orderid,orderdate,shippeddate order by
sum(unitprice * quantity) desc
go

EXECUTE OrdenesPorCliente 'ALFKI'