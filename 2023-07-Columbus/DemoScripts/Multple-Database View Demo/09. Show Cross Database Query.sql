USE BikeStoresUSA
GO

-- Views works for me without any rights granted since I have sysadmin (sa) role
SELECT * FROM [BikeStoresUSA].[sales].[vCustomerCountByCity] ORDER BY CITY

-- But what if I am a standard user with GRANT SELECT to that table in each db?
DROP USER IF EXISTS MarketingPerson  -- drop from database
IF EXISTS (SELECT 1 FROM master.sys.server_principals WHERE name = 'MarketingPerson')
BEGIN
    DROP LOGIN MarketingPerson -- drop from server
END

-- Add MarketingRerson SQL Login to the server, add to BikeStoresUSA database
CREATE LOGIN MarketingPerson WITH Password='demo$1234', DEFAULT_DATABASE = [BikeStoresUSA]
CREATE USER MarketingPerson for LOGIN MarketingPerson

-- Follow the pattern - create db roles, assign permissions to them, add members
DROP ROLE IF EXISTS xrMarketing
CREATE ROLE xrMarketing
--GRANT SELECT ON Sales.Customers TO xrMarketing
GRANT SELECT ON [sales].[vCustomerCountByCity] to xrMarketing
ALTER ROLE xrMarketing ADD MEMBER MarketingPerson

Use BikeStoresCAN
GO
CREATE USER MarketingPerson for LOGIN MarketingPerson
DROP ROLE IF EXISTS xrMarketing
CREATE ROLE xrMarketing

--GRANT SELECT ON Sales.Customers TO xrMarketing
ALTER ROLE xrMarketing ADD MEMBER MarketingPerson

Use BikeStoresUSA
GO

-- The view works because MarketingPerson has select on the objects in both databases
-- even though the view was run from the BikeStoresUSA database.
EXECUTE AS LOGIN = 'MarketingPerson'; 
SELECT * FROM [sales].[vCustomerCountByCity] ORDER BY CITY
REVERT;
GO