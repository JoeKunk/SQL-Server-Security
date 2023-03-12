-- What permission categories can I have?
SELECT DISTINCT class_desc FROM fn_builtin_permissions(default)  
    ORDER BY class_desc;  
GO  

-- What are my permissions on the server?
SELECT * FROM fn_my_permissions(NULL, 'SERVER');  

-- What are my permissions on a database?
SELECT * FROM fn_my_permissions (NULL, 'DATABASE');  

-- What are my permissions on a view?
USE AdventureWorks2012;
SELECT * FROM fn_my_permissions('Sales.vIndividualCustomer', 'OBJECT')   
    ORDER BY subentity_name, permission_name;


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

-- Don't do this, should grant to a role instead
GRANT SELECT, INSERT, DELETE ON AdventureWorks2012.Person.Address TO HRPerson;

--------------- List effective permissions of HRPerson ---------------
EXECUTE AS LOGIN = 'HRPerson';  
SELECT * FROM fn_my_permissions('AdventureWorks2012.Person.Address', 'OBJECT')   
    ORDER BY subentity_name, permission_name ;    
REVERT;  
GO

-- Prevent the user from seeing the rowguid and SpatialLocation columns
REVOKE SELECT ON AdventureWorks2012.Person.Address to HRPerson;
GRANT SELECT 
    ON AdventureWorks2012.Person.Address 
        ([AddressID], [AddressLine1], [AddressLine2], [City]
        , [StateProvinceID], [PostalCode],[ModifiedDate])
    TO HRPerson;

-- Show permissions again - note those columns are gone
EXECUTE AS LOGIN = 'HRPerson';  
SELECT * FROM fn_my_permissions('AdventureWorks2012.Person.Address', 'OBJECT')   
    ORDER BY subentity_name, permission_name ;    
REVERT;  
GO

-- Remove the permissions granted to HRPerson
REVOKE SELECT, INSERT, DELETE ON AdventureWorks2012.Person.Address TO HRPerson;
-- Show permissions again with code above - note those all permissions are gone

-- List my permisisons as sysadmin on the user HRPerson
SELECT * FROM fn_my_permissions('HRPerson', 'USER');
GO

-- Grant permissions to two tables and a view, 
-- then list all SELECT, INSERT, DELETE permissions 
GRANT DELETE ON AdventureWorks2012.Person.Address to HRPerson;
GRANT INSERT ON AdventureWorks2012.Person.Address to HRPerson;
GRANT SELECT ON AdventureWorks2012.Person.AddressType to HRPerson;
GRANT SELECT ON AdventureWorks2012.Sales.vSalesPersonSalesByFiscalYears to HRPerson;

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
    ORDER BY SCHEMA_NAME(schema_id) + '.' + name 
REVERT;  
GO  


