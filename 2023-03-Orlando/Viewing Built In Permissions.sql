-- See Server Level Permissions available
SELECT * FROM sys.fn_builtin_permissions('SERVER') ORDER BY permission_name;

-- Database Level Permissions available
SELECT * FROM sys.fn_builtin_permissions('DATABASE') ORDER BY permission_name;

-- Schema Level Permissions available
SELECT * FROM sys.fn_builtin_permissions('SCHEMA') ORDER BY permission_name;

-- Object Level Permissions available
SELECT * FROM sys.fn_builtin_permissions('OBJECT') ORDER BY permission_name;

-- https://learn.microsoft.com/en-us/sql/relational-databases/system-functions/sys-fn-builtin-permissions-transact-sql?view=sql-server-ver16

/* <securable_class> ::=
      APPLICATION ROLE | ASSEMBLY | ASYMMETRIC KEY | AVAILABILITY GROUP
    | CERTIFICATE | CONTRACT | DATABASE | DATABASE SCOPED CREDENTIAL
    | ENDPOINT | FULLTEXT CATALOG | FULLTEXT STOPLIST | LOGIN
    | MESSAGE TYPE | OBJECT | REMOTE SERVICE BINDING | ROLE | ROUTE
    | SCHEMA | SEARCH PROPERTY LIST | SERVER | SERVER ROLE | SERVICE
    | SYMMETRIC KEY | TYPE | USER | XML SCHEMA COLLECTION
*/