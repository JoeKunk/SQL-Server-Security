/*
DEMO 4

       Stored procedures are executed under the security context 
	   of the calling user which could have a compromised login
        
		Better to execute them under a user that has no login
		You can breach as login that does not exist
        
		In this way, minimum permissions are assigned to the stored procedure, not the caller
		No need to grant permissions to the caller just so he/she can run the stored procedure
*/


-- No need for CREATE LOGIN statement
-- Directly create the user in the database
Use AdventureWorks2012;
DROP USER IF EXISTS ProcRunner;
CREATE USER ProcRunner WITHOUT LOGIN;

-- Create DB Role even if only one member
-- Don't be afraid to create longer descriptive names
DROP ROLE IF EXISTS xrProduction_Schema_Updaters
CREATE ROLE xrProduction_Schema_Updaters

-- DB Role needs to have SELECT, INSERT, UPDATE any data in Production schema
-- View Definition is not needed since it only used to run stored procedures
-- DB Role does not need to alter the any schema definitions of tables, views, etc.

-- db_dataReader and db_dataWriter would be wrong since that is for the entire database.
GRANT SELECT, INSERT, DELETE, UPDATE ON SCHEMA::Production to xrProduction_Schema_Updaters

-- Add user ProcRunner to the DB Role xrProduction_Schema_Updaters
ALTER ROLE xrProduction_Schema_Updaters ADD MEMBER ProcRunner;

-- Test to verify that ProcRunner can view data in the Production schema
-- Note that impersonating a user, not a login
EXECUTE AS USER = 'ProcRunner';
SELECT TOP 10 * FROM [Production].[ProductReview];
REVERT;
GO

-- Create a simple stored procedure to run the same query, run by ProcRunner
-- Note CREATE or ALTER syntax
CREATE OR ALTER PROCEDURE xspGetProductReviews
WITH EXECUTE AS 'ProcRunner'
AS
BEGIN
	SET NOCOUNT ON;
	SELECT TOP 10 * FROM [Production].[ProductReview];
END
GO

-- Let's quickly ensure PlantManager and xrPlantMgmt is set up properly
DROP USER IF EXISTS PlantManager  -- drop from database
IF EXISTS (SELECT 1 FROM master.sys.server_principals WHERE name = 'PlantManager') BEGIN
    DROP LOGIN PlantManager -- drop from server
END
CREATE LOGIN PlantManager WITH Password='demo$1234', DEFAULT_DATABASE = [AdventureWorks2012]
CREATE USER PlantManager for LOGIN PlantManager

DROP ROLE IF EXiSTS xrPlantMgmt  -- db roles can not belong to schemas
CREATE ROLE xrPlantMgmt AUTHORIZATION [dbo]
GRANT DELETE, INSERT, SELECT, UPDATE, VIEW DEFINITION ON Person.Address TO xrPlantMgmt
ALTER ROLE xrPlantMgmt ADD MEMBER PlantManager

-- PlantManager cannot select from the ProductReview table directly in Production schema
-- The SELECT permission was denied
EXECUTE AS LOGIN = 'PlantManager';
    Select top 10 * from [Production].[ProductReview];
REVERT;

-- But can see Product Reviews if granted permission to execute the Stored Procedure
-- Because stored procedure runs as ProcRunner user which can select any table in Production schema
GRANT EXECUTE on xspGetProductReviews to xrPlantMgmt
EXECUTE AS LOGIN = 'PlantManager';
    Execute xspGetProductReviews;
REVERT;

-- But wait there is more!
-- What if we need to do one or steps as the caller identity within the stored procedure?

-- ProcRunner cannot select from Person.Address but PlantManager can
-- PlantManager cannot select from [Production].[ProductReview] but ProcRunner can
-- Let's run parts of the stored procedure under each login to return both queries

-- ProcRunner cannot select from Person.Address
EXECUTE AS USER = 'ProcRunner';
    Select TOP 10 SYSTEM_USER, * FROM Person.Address;
REVERT;
GO

-- PlantManager cannot select from [Production].[ProductReview]
EXECUTE AS USER = 'PlantManager';
    Select TOP 10 SYSTEM_USER, * FROM [Production].[ProductReview];
REVERT;
GO

CREATE OR ALTER PROCEDURE xspGetProductReviews 
WITH EXECUTE AS 'ProcRunner'
AS
BEGIN
	SET NOCOUNT ON;
	SELECT TOP 10 USER_NAME(), * FROM [Production].[ProductReview];
        EXECUTE AS CALLER;  -- PlantManager
            Select TOP 10 SYSTEM_USER, * FROM Person.Address
        REVERT;
END
GO

-- Can see results from both queries since called by PlantManager
EXECUTE AS LOGIN = 'PlantManager';
    Execute xspGetProductReviews;
REVERT;
GO

--	Interesting Fact:
--	Even though sproc can run under ProcRunner permissions, 
--	ProcRunner cannot run sproc directly
EXECUTE AS USER = 'ProcRunner';
    Execute xspGetProductReviews;
REVERT;
GO

-- ProcRunner must be granted permission to call the sproc
GRANT EXECUTE on xspGetProductReviews to ProcRunner;
EXECUTE AS USER = 'ProcRunner';
    Execute xspGetProductReviews;
REVERT;
GO
