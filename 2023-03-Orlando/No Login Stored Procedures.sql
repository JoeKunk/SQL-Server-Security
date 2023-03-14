/*      AUTHOR: Joseph Kunk, Senior Software Architect as Dewpoint, Lansing MI USA. 
                Email info@dewpoint.com or call 1.616.310.4519 for availablity of consulting services
                LinkedIn: , Twitter, Mastodon, Email: joekunk gmail


        Stored procedures are executed under the security context of the calling user which could have a compromised login
        Better to execute them under a user that has no login
        In this way, minimum permissions are assigned to the stored procedure, not the caller
*/


-- No need for CREATE LOGIN statement
-- Directly create the user in the database
Use AdventureWorks2012;
DROP USER IF EXISTS ProcRunner;
CREATE USER ProcRunner WITHOUT LOGIN;

-- Create DB Role even if only one memeber
-- Don't be afraid to create longer descriptive names
DROP ROLE IF EXiSTS xrProduction_Schema_Updaters
CREATE ROLE xrProduction_Schema_Updaters

-- DB Role needs to SELECT, INSERT, UPDATE any data in Production schema
-- View Definition is not needed since only used to run stored procedures
-- DB Role does not need to alter the any schema definitions of tables, views, etc.
-- db_dataReader and db_dataWriter would be wrong since that is for the entire database.
GRANT SELECT, INSERT, DELETE, UPDATE ON SCHEMA::Production to xrProduction_Schema_Updaters

-- Add xrProduction_Schema_Updaters to the DB Role
ALTER ROLE xrProduction_Schema_Updaters ADD MEMBER ProcRunner;

-- Test to verify that ProcRunner can view data in the Production schema
-- Note that impersonating a user, not a login
EXECUTE AS USER = 'ProcRunner';
SELECT TOP 10 * FROM [AdventureWorks2012].[Production].[ProductReview];
REVERT;
GO

-- Create a simple stored procedure to run the same query, run by ProcRunner
-- Note CREATE or ALTER syntax
CREATE OR ALTER PROCEDURE xspGetProductReviews 
WITH EXECUTE AS 'ProcRunner'
AS
BEGIN
	SET NOCOUNT ON;
	SELECT TOP 10 * FROM [AdventureWorks2012].[Production].[ProductReview];
END
GO

-- HRPerson cannot select from the ProductReview table directly
EXECUTE AS LOGIN = 'HRPerson';
    Select top 10 * from [AdventureWorks2012].[Production].[ProductReview];
REVERT;

-- But can see Product Reviews if granted permission to execute the Stored Procedure
GRANT EXECUTE on xspGetProductReviews to xrHR_Address

EXECUTE AS LOGIN = 'HRPerson';
    Execute xspGetProductReviews;
REVERT;

-- But wait there is more!
-- What if we need to do one or steps as the caller identity within the stored procedure?
CREATE OR ALTER PROCEDURE xspGetProductReviews 
WITH EXECUTE AS 'ProcRunner'
AS
BEGIN
	SET NOCOUNT ON;
	SELECT TOP 10 USER_NAME(), * FROM [AdventureWorks2012].[Production].[ProductReview];
        EXECUTE AS CALLER;
            Select TOP 10 SYSTEM_USER, * FROM Person.Address
        REVERT;
END
GO

EXECUTE AS LOGIN = 'HRPerson';
    Execute xspGetProductReviews;
REVERT;

-- ProcRunner cannot select from Person.Address directly
-- The stored procedure could show the Person.Addres only because HRPerson was impersonated
-- Goes both way! :)
EXECUTE AS USER = 'ProcRunner';
    Select TOP 10 SYSTEM_USER, * FROM Person.Address;
REVERT;
GO







