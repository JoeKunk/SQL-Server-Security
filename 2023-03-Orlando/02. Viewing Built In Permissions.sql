-- So what permisisons are available to assign?

-- See Server Level Built-in Permissions available
SELECT * FROM sys.fn_builtin_permissions('SERVER') ORDER BY permission_name;

-- Database Level Built-in Permissions available
SELECT * FROM sys.fn_builtin_permissions('DATABASE') ORDER BY permission_name;

-- Schema Level Built-in Permissions available
SELECT * FROM sys.fn_builtin_permissions('SCHEMA') ORDER BY permission_name;

-- Object Level Built-in Permissions available
SELECT * FROM sys.fn_builtin_permissions('OBJECT') ORDER BY permission_name;

-- All Built-in Permissions available
SELECT * FROM sys.fn_builtin_permissions(DEFAULT) ORDER BY permission_name;

-- https://learn.microsoft.com/en-us/sql/relational-databases/system-functions/sys-fn-builtin-permissions-transact-sql?view=sql-server-ver16

/* What can be assigned permissons?

	<securable_class> ::=
      APPLICATION ROLE | ASSEMBLY | ASYMMETRIC KEY | AVAILABILITY GROUP
    | CERTIFICATE | CONTRACT | DATABASE | DATABASE SCOPED CREDENTIAL
    | ENDPOINT | FULLTEXT CATALOG | FULLTEXT STOPLIST | LOGIN
    | MESSAGE TYPE | OBJECT | REMOTE SERVICE BINDING | ROLE | ROUTE
    | SCHEMA | SEARCH PROPERTY LIST | SERVER | SERVER ROLE | SERVICE
    | SYMMETRIC KEY | TYPE | USER | XML SCHEMA COLLECTION
*/