/*      AUTHOR: Joseph Kunk, Senior Software Architect at Dewpoint, Lansing MI USA. 
                LinkedIn:	joe-kunk-b926091
				Twitter:	@joekunk
				Mastodon:	@joekunk@techhub.social
				Email:		joekunk@gmail.com
*/


USE AdventureWorks2012;
GO

-- What are my permissions on the server?
SELECT * FROM fn_my_permissions(NULL, 'SERVER');  

-- What are my permissions on a database?
SELECT * FROM fn_my_permissions (NULL, 'DATABASE');  

-- Example: What are my permissions on a view?

SELECT * FROM fn_my_permissions('Sales.vIndividualCustomer', 'OBJECT')   
    ORDER BY subentity_name, permission_name;

-- For subsequent script
--------------- List effective permissions of HRPerson ---------------

-- Note that there are 12 rows in the result
EXECUTE AS LOGIN = 'HRPerson';  
SELECT * FROM fn_my_permissions('AdventureWorks2012.Person.Address', 'OBJECT')   
    ORDER BY subentity_name, permission_name ;    
REVERT;  
GO