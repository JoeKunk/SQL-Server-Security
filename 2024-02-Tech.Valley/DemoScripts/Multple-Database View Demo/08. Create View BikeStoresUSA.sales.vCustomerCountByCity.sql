USE BikeStoresUSA
GO

IF object_id('sales.vCustomerCountByCity', 'V') IS NOT NULL
	DROP VIEW sales.vCustomerCountByCity
GO

CREATE VIEW sales.vCustomerCountByCity AS
	Select 'USA' as Country, City, count(customer_id) as [Customer Count] 
	FROM BikeStoresUSA.Sales.Customers 
	GROUP BY City
	
	UNION
	
	Select 'CAN' as Country, City, count(customer_id) as [Customer Count] 
	FROM BikeStoresCAN.Sales.Customers 
	GROUP BY City
	
