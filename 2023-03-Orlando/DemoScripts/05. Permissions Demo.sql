/*      AUTHOR: Joseph Kunk, Senior Software Architect at Dewpoint, Lansing MI USA. 
                LinkedIn:	joe-kunk-b926091
				Twitter:	@joekunk
				Mastodon:	@joekunk@techhub.social
				Email:		joekunk@gmail.com
*/

-- Remove HRPerson user from database and server to demo new permissions
USE AdventureWorks2012;
DROP USER IF EXISTS HRPerson  -- drop from database
IF EXISTS (SELECT 1 FROM master.sys.server_principals WHERE name = 'HRPerson')
BEGIN
    DROP LOGIN HRPerson -- drop from server
END

-- Add HPRerson SQL Login to the server, add to AdventureWorks2012 database
CREATE LOGIN HRPerson WITH Password='demo$1234', DEFAULT_DATABASE = [AdventureWorks2012]
CREATE USER HRPerson for LOGIN HRPerson

-- For demo only, should grant to a db role instead
GRANT SELECT, INSERT, DELETE ON AdventureWorks2012.Person.Address TO HRPerson;

--------------- List effective permissions of HRPerson in script 04 ---------------
-- Note that there are 12 rows in the result


-- Prevent the user from seeing the rowguid and SpatialLocation columns
REVOKE SELECT ON AdventureWorks2012.Person.Address to HRPerson;
GRANT SELECT 
    ON AdventureWorks2012.Person.Address 
        ([AddressID], [AddressLine1], [AddressLine2], [City]
        , [StateProvinceID], [PostalCode],[ModifiedDate])
    TO HRPerson;

--------------- List effective permissions of HRPerson in script 04 ---------------
-- Note that there are 9 rows in the result

-- See the impact on the common query: SELECT * FROM table
EXECUTE AS user = 'HRPerson'
	SELECT * FROM AdventureWorks2012.Person.Address
REVERT;
GO

-- Remove the permissions granted to HRPerson
REVOKE SELECT, INSERT, DELETE ON AdventureWorks2012.Person.Address TO HRPerson;

--------------- List effective permissions of HRPerson in script 04 ---------------
-- Note that all permissions are gone

-- List my permissions as sysadmin on the user HRPerson
SELECT * FROM fn_my_permissions('HRPerson', 'USER');
GO

-- Grant permissions to two tables and a view, 
-- then list all SELECT, INSERT, DELETE permissions 
GRANT DELETE ON AdventureWorks2012.Person.Address to HRPerson;
GRANT INSERT ON AdventureWorks2012.Person.Address to HRPerson;
GRANT SELECT ON AdventureWorks2012.Person.AddressType to HRPerson;
GRANT SELECT ON AdventureWorks2012.Sales.vSalesPersonSalesByFiscalYears to HRPerson;

-- This query shows all SELECT, DELETE, INSERT, and UPDATE permissions on any table
EXECUTE AS user = 'HRPerson';
    SELECT 'SELECT', SCHEMA_NAME(schema_id) + '.' + name as Table_Name
    FROM Sys.Tables
    WHERE   type_desc = 'USER_TABLE'
            AND (HAS_PERMS_BY_NAME(SCHEMA_NAME(schema_id) + '.' + name, 'OBJECT', 'SELECT')= 1)
    UNION
    SELECT 'DELETE', SCHEMA_NAME(schema_id) + '.' + name as Table_Name
    FROM Sys.Tables
    WHERE   type_desc = 'USER_TABLE'
            AND (HAS_PERMS_BY_NAME(SCHEMA_NAME(schema_id) + '.' + name, 'OBJECT', 'DELETE')= 1)
    UNION
    SELECT 'INSERT', SCHEMA_NAME(schema_id) + '.' + name as Table_Name
    FROM Sys.Tables
    WHERE   type_desc = 'USER_TABLE'
            AND (HAS_PERMS_BY_NAME(SCHEMA_NAME(schema_id) + '.' + name, 'OBJECT', 'INSERT')= 1)
	UNION
    SELECT 'INSERT', SCHEMA_NAME(schema_id) + '.' + name as Table_Name
    FROM Sys.Tables
    WHERE   type_desc = 'USER_TABLE'
            AND (HAS_PERMS_BY_NAME(SCHEMA_NAME(schema_id) + '.' + name, 'OBJECT', 'INSERT')= 1)
    ORDER BY SCHEMA_NAME(schema_id) + '.' + name 
REVERT;  
GO
