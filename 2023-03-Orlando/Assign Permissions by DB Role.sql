-- Remove HRPerson user from database and server to demo new permissions
USE AdventureWorks2012;
DROP USER IF EXISTS HRPerson  -- drop from database
IF EXISTS (SELECT 1 FROM master.sys.server_principals WHERE name = 'HRPerson')
BEGIN
    DROP LOGIN HRPerson -- drop from server
END

-- Add HPRerson SQL Login to the server, add to AdventureWorks2012 database
CREATE LOGIN HRPerson WITH Password='demo', DEFAULT_DATABASE = [AdventureWorks2012]
CREATE USER HRPerson for LOGIN HRPerson

-- Create the database role
DROP ROLE IF EXiSTS xrHR_Address  -- db roles can not belong to schemas
CREATE ROLE xrHR_Address AUTHORIZATION [dbo]
GO

-- Grant permissions to the db role, rather than a user
GRANT 
	DELETE, INSERT, SELECT, UPDATE, VIEW DEFINITION
    ON Person.Address TO xrHR_Address
GO

-- Show that HRPerson cannot select from Person.Address table
EXECUTE AS LOGIN = 'HRPerson';  
SELECT * FROM Person.Address
REVERT
GO

ALTER ROLE xrHR_Address ADD MEMBER HRPerson
GO

-- Show that HRPerson NOW can select from Person.Address table
EXECUTE AS LOGIN = 'HRPerson'; 
SELECT * FROM Person.Address
REVERT
GO

-- show members of all the db roles 
SELECT DP1.name AS DatabaseRoleName, DP2.name AS DatabaseUserName   
 FROM sys.database_role_members AS DRM  
    RIGHT OUTER JOIN sys.database_principals AS DP1 ON DRM.role_principal_id = DP1.principal_id  
    LEFT OUTER JOIN sys.database_principals AS DP2 ON DRM.member_principal_id = DP2.principal_id  
WHERE DP1.type = 'R'
ORDER BY DP1.name;  

-- show permissions using 'View DB Permissions Advanced' script in SSMS

-- Assign permissions to both the user and to the roles to see the difference
REVOKE SELECT ON AdventureWorks2012.Person.Address to HRPerson;
GRANT SELECT 
    ON AdventureWorks2012.Person.Address 
        ([AddressID], [AddressLine1], [AddressLine2], [City]
        , [StateProvinceID], [PostalCode],[ModifiedDate])
    TO HRPerson;

REVOKE SELECT ON AdventureWorks2012.Person.Address to xrHR_Address;
GRANT SELECT 
    ON AdventureWorks2012.Person.Address 
        ([AddressID], [AddressLine1], [AddressLine2], [City]
        , [StateProvinceID], [PostalCode],[ModifiedDate])
    TO xrHR_Address;

-- show permissions using 'View DB Permissions Advanced' script in SSMS

-- Remove the user from the database, show removed from db Role also
USE AdventureWorks2012;
DROP USER IF EXISTS HRPerson  -- drop from database
IF EXISTS (SELECT 1 FROM master.sys.server_principals WHERE name = 'HRPerson')
BEGIN
    DROP LOGIN HRPerson -- drop from server
END

-- show permissions using 'View DB Permissions Advanced' script in SSMS
-- Database role still exists but no permissions so not included in the list
