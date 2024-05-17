/*
DEMO 1

	What the permissions of a particular user?
*/

USE AdventureWorks2012;
GO

-- What are my permissions on the server?

SELECT * FROM fn_my_permissions(NULL, 'SERVER');  
SELECT * FROM fn_my_permissions (NULL, 'DATABASE');  
SELECT * FROM fn_my_permissions('Sales.vIndividualCustomer', 'OBJECT')   
    ORDER BY subentity_name, permission_name;

-- How does that compare to USER 1

-- Limit USER1 to seeing only the first three columns
REVOKE SELECT ON [Production].[Product] TO USER1
GRANT SELECT ON [Production].[Product] ([ProductID], [Name], [ProductNumber]) TO USER1

-- Note EXECUTE AS / REVERT to run sql as another user
EXECUTE AS LOGIN = 'USER1';  
		SELECT 'SERVER', * FROM fn_my_permissions(NULL, 'SERVER');  

		SELECT 'DATABASE', * FROM fn_my_permissions (NULL, 'DATABASE');  

		SELECT 'VIEW', * FROM fn_my_permissions('Sales.vIndividualCustomer', 'OBJECT')   
			ORDER BY subentity_name, permission_name;

		SELECT 'TABLE', * FROM fn_my_permissions('[Production].[Product]', 'OBJECT')   
			ORDER BY subentity_name, permission_name;
REVERT;  

GO