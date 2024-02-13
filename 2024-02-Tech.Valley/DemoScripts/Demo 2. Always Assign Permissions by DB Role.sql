/*
DEMO 2

	Always GRANT permissions to a database role, then add members to the role
	The role can have a descriptive name of what the permissions are for
	I usually prefix custom roles with 'xr'
*/

-- Remove HRPerson user from database and server to reset permissions
USE AdventureWorks2012;
DROP USER IF EXISTS HRPerson  -- drop from database
IF EXISTS (SELECT 1 FROM master.sys.server_principals WHERE name = 'HRPerson')
    DROP LOGIN HRPerson -- drop from server

CREATE LOGIN HRPerson WITH Password='demo$1234', DEFAULT_DATABASE = [AdventureWorks2012]
CREATE USER HRPerson for LOGIN HRPerson

-- Note: db roles can not belong to spedific schemasDROP ROLE IF EXiSTS xrHR_Address 
DROP ROLE IF EXISTS xrHR_Address
CREATE ROLE xrHR_Address AUTHORIZATION [dbo]
GO

------------------------

-- Grant permissions to the db role, rather than a user
GRANT 
	DELETE, INSERT, SELECT, UPDATE, VIEW DEFINITION
    ON Person.Address TO xrHR_Address
GO

-- HRPerson cannot select from Person.Address table 
-- since not a member of the db role
EXECUTE AS LOGIN = 'HRPerson';  
SELECT TOP 10 * FROM Person.Address
REVERT
GO

-- Now add HRPerson and USER1 as a member of the db role
ALTER ROLE xrHR_Address ADD MEMBER HRPerson
ALTER ROLE xrHR_Address ADD MEMBER USER1
GO

-- HRPerson now can select from Person.Address table
EXECUTE AS LOGIN = 'HRPerson'; 
SELECT TOP 10 * FROM Person.Address
REVERT
GO

-- show members of all the custom db roles 
SELECT DP1.name AS DatabaseRoleName, DP2.name AS DatabaseUserName   
 FROM sys.database_role_members AS DRM  
    RIGHT OUTER JOIN sys.database_principals AS DP1 ON DRM.role_principal_id = DP1.principal_id  
    LEFT OUTER JOIN sys.database_principals AS DP2 ON DRM.member_principal_id = DP2.principal_id  
WHERE DP1.type = 'R' and DP1.name like 'x%'
ORDER BY DP1.name;  

-- show permissions the stored procedure we created in Script 02
EXECUTE dbo.ListPermissions

-- NOTE:
--		Dropping the user from the databae removes all the permissions
