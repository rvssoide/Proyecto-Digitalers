--PUNTO 2 GENERAR VISTAS

--Vista_Compras
SELECT * FROM Purchasing.PurchaseOrderDetail
SELECT * FROM Purchasing.PurchaseOrderHeader
SELECT * FROM Purchasing.ProductVendor
SELECT * FROM Production.Product
SELECT * FROM Purchasing.Vendor

CREATE VIEW dbo.vista_compras
AS
SELECT
	pod.PurchaseOrderID AS OrdenID,
	pod.DueDate AS FechaVencimiento,
	pod.ProductID,
	pod.OrderQty AS CantidadPedida,
	pod.ReceivedQty AS CantidadRecibida,
	pod.RejectedQty AS CantidadDevuelta,
	pod.UnitPrice AS PrecioUnitario,
	pod.LineTotal AS MontoTotal,
	poh.OrderDate AS FechaOrden,
	poh.ShipDate AS FechaEnvio,
	poh.VendorID AS ProveedorID,
	pv.AverageLeadTime,
	pp.Name AS Descripcion,
	v.Name AS Proveedor
FROM Purchasing.PurchaseOrderDetail pod
JOIN Purchasing.PurchaseOrderHeader poh
ON pod.PurchaseOrderID=poh.PurchaseOrderID
JOIN Purchasing.ProductVendor pv
ON pod.ProductID=pv.ProductID
JOIN Production.Product pp
ON pod.ProductID=pp.ProductID
JOIN Purchasing.Vendor v
ON poh.VendorID=v.BusinessEntityID;

SELECT * FROM dbo.vista_compras;

--Vista_Produccion
SELECT * FROM Production.WorkOrder
SELECT * FROM Production.Product
SELECT * FROM Production.Location
SELECT * FROM Production.ProductModel

CREATE VIEW dbo.vista_produccion
AS
SELECT
	pwo.WorkOrderID,
	pwo.StartDate AS FechaInicio,
	pwo.EndDate AS FechaFin,
	pwo.DueDate AS FechaVencimiento,
	pwo.ProductID,
	pwo.OrderQty AS Cantidad,
	pwo.StockedQty AS Almacenado,
	pp.Name AS Producto,
	pp.StandardCost AS CostoStandard,
	pp.ListPrice AS PrecioLista,
	pl.Name AS Location,
	pl.LocationID,
	ppm.ProductModelID,
	ppm.Name AS ProductModel
FROM Production.WorkOrder pwo
JOIN Production.Product pp
ON pwo.ProductID=pp.ProductID
JOIN Production.Location pl
ON pl.LocationID=pl.LocationID --Acá no estoy seguro con qué unirlo, puede ser que no debamos contemplar esta tabla al final? Otra opción es incluir una tabla intermedia como Production.ProductInventory, que sí tiene una relación lógica con esta tabla
JOIN Production.ProductModel ppm
ON ppm.ProductModelID=pp.ProductModelID;

SELECT * FROM dbo.vista_produccion;

--Vista_Inventarios
SELECT * FROM Production.ProductInventory
SELECT * FROM Production.Product
SELECT * FROM Production.Location
SELECT * FROM Production.ProductModel

CREATE VIEW dbo.vista_inventarios
AS
SELECT
	ppi.ModifiedDate AS FechaEntrada,
	ppi.ProductID,
	ppi.Quantity,
	pp.Name AS Producto,
	pl.LocationID,
	pl.Name AS Location,
	ppm.ProductModelID,
	ppm.Name AS ProductLine
FROM Production.ProductInventory ppi
JOIN Production.Product pp
ON ppi.ProductID=pp.ProductID
JOIN Production.Location pl
ON ppi.LocationID=pl.LocationID
JOIN Production.ProductModel ppm
ON pp.ProductModelID=ppm.ProductModelID;

SELECT * FROM dbo.vista_inventarios;

--Vista_Recursos
SELECT * FROM HumanResources.EmployeeDepartmentHistory
SELECT * FROM HumanResources.Department
SELECT * FROM HumanResources.Employee
SELECT * FROM Person.Person

CREATE VIEW dbo.vista_recursos
AS
SELECT
	edh.BusinessEntityID,
	edh.StartDate AS FechaContrato,
	edh.EndDate AS FinContrato,
	d.GroupName AS Gerencia,
	d.Name AS Departamento,
	concat_ws(' ', p.FirstName, p.LastName) AS NombreEmpleado,
	e.JobTitle,
	e.Gender,
	e.MaritalStatus,
	e.BirthDate
FROM HumanResources.EmployeeDepartmentHistory edh
JOIN HumanResources.Department d
ON edh.DepartmentID=d.DepartmentID
JOIN HumanResources.Employee e
ON edh.BusinessEntityID=e.BusinessEntityID
JOIN Person.Person p
ON p.BusinessEntityID=e.BusinessEntityID;

SELECT * FROM dbo.vista_recursos;

--Vista_Ventas
SELECT * FROM Sales.SalesOrderDetail
SELECT * FROM Production.Product
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Person.Person
SELECT * FROM Sales.SalesTerritory

CREATE VIEW dbo.vista_ventas
AS
SELECT
	sod.SalesOrderID AS OrderID,
	sod.OrderQty AS Cantidad,
	sod.ProductID,
	sod.UnitPrice AS PrecioUnitario,
	sod.UnitPriceDiscount AS Descuento,
	sod.LineTotal AS Total,
	pp.Name AS Producto,
	soh.Status,
	soh.OrderDate AS Fecha,
	soh.CustomerID,
	soh.SalesPersonID,
	concat_ws(' ', p.FirstName, p.LastName) AS Vendedor,
	st.Name AS Region,
	st.TerritoryID
FROM Sales.SalesOrderDetail sod
JOIN Production.Product pp
ON sod.ProductID=pp.ProductID
JOIN Sales.SalesOrderHeader soh
ON sod.SalesOrderID=soh.SalesOrderID
JOIN Person.Person p
ON soh.SalesPersonID=p.BusinessEntityID
JOIN Sales.SalesTerritory st
ON soh.TerritoryID=st.TerritoryID;

SELECT * FROM dbo.vista_ventas;
