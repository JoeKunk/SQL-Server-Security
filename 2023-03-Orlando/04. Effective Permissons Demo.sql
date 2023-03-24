-- What objects can be assigned permissions?
SELECT DISTINCT class_desc FROM fn_builtin_permissions(default)  
    ORDER BY class_desc;  
GO  

-- What are my permissions on the server?
SELECT * FROM fn_my_permissions(NULL, 'SERVER');  

-- What are my permissions on a database?
SELECT * FROM fn_my_permissions (NULL, 'DATABASE');  

-- Example: What are my permissions on a view?
USE AdventureWorks2012;
SELECT * FROM fn_my_permissions('Sales.vIndividualCustomer', 'OBJECT')   
    ORDER BY subentity_name, permission_name;

--------------- List effective permissions of HRPerson ---------------
-- Note that there are 12 rows in the result
EXECUTE AS LOGIN = 'HRPerson';  
SELECT * FROM fn_my_permissions('AdventureWorks2012.Person.Address', 'OBJECT')   
    ORDER BY subentity_name, permission_name ;    
REVERT;  
GO