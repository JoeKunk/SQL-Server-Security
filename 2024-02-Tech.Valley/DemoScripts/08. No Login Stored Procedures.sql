/*      AUTHOR: Joseph Kunk, Senior Software Architect at Dewpoint, Lansing MI USA. 
                LinkedIn:	joe-kunk-b926091
				Twitter:	@joekunk
				Mastodon:	@joekunk@techhub.social
				Email:		joekunk@gmail.com
*/

/*      Stored procedures are executed under the security context of the calling user 
		which could have a compromised login
        
		Better to execute them under a user that has no login
        
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

-- Let's quickly ensure HRPerson and xrHR_Address is set up properly
USE AdventureWorks2012;
DROP USER IF EXISTS HRPerson  -- drop from database
IF EXISTS (SELECT 1 FROM master.sys.server_principals WHERE name = 'HRPerson') BEGIN
    DROP LOGIN HRPerson -- drop from server
END
CREATE LOGIN HRPerson WITH Password='demo$1234', DEFAULT_DATABASE = [AdventureWorks2012]
CREATE USER HRPerson for LOGIN HRPerson
DROP ROLE IF EXiSTS xrHR_Address  -- db roles can not belong to schemas
CREATE ROLE xrHR_Address AUTHORIZATION [dbo]
ALTER ROLE xrHR_Address ADD MEMBER HRPerson
GRANT DELETE, INSERT, SELECT, UPDATE, VIEW DEFINITION ON Person.Address TO xrHR_Address

-- HRPerson cannot select from the ProductReview table directly in Production schema
-- The SELECT permission was denied
EXECUTE AS LOGIN = 'HRPerson';
    Select top 10 * from [AdventureWorks2012].[Production].[ProductReview];
REVERT;

-- But can see Product Reviews if granted permission to execute the Stored Procedure
-- Because stored procedure runs as ProcRunner user which can select any table in Production schema
GRANT EXECUTE on xspGetProductReviews to xrHR_Address
EXECUTE AS LOGIN = 'HRPerson';
    Execute xspGetProductReviews;
REVERT;

-- But wait there is more!
-- What if we need to do one or steps as the caller identity within the stored procedure?

-- ProcRunner cannot select from Person.Address but HRPerson can
-- HRPerson cannot select from [Production].[ProductReview] but ProcRunner can
-- Let's run parts of the stored procedure under each login to return both queries

-- Show that ProcRunner cannot select from Person.Address
EXECUTE AS USER = 'ProcRunner';
    Select TOP 10 SYSTEM_USER, * FROM Person.Address;
REVERT;
GO

-- Show that HRPerson cannot select from [Production].[ProductReview]
EXECUTE AS USER = 'HRPerson';
    Select TOP 10 SYSTEM_USER, * FROM [Production].[ProductReview];
REVERT;
GO

CREATE OR ALTER PROCEDURE xspGetProductReviews 
WITH EXECUTE AS 'ProcRunner'
AS
BEGIN
	SET NOCOUNT ON;
	SELECT TOP 10 USER_NAME(), * FROM [AdventureWorks2012].[Production].[ProductReview];
        EXECUTE AS CALLER;  -- HRPerson
            Select TOP 10 SYSTEM_USER, * FROM Person.Address
        REVERT;
END
GO

-- Can see results from both queries since called by HRPerson
EXECUTE AS LOGIN = 'HRPerson';
    Execute xspGetProductReviews;
REVERT;
GO

-- But can not see results from both queries when called by ProcRunner
EXECUTE AS USER = 'ProcRunner';
    Execute xspGetProductReviews;
REVERT;
GO

GRANT EXECUTE on xspGetProductReviews to ProcRunner;
EXECUTE AS USER = 'ProcRunner';
    Execute xspGetProductReviews;
REVERT;
GO
