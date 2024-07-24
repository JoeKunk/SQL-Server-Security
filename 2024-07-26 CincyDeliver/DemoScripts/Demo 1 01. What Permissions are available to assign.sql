/*
DEMO 1

	So what permisisons are AVAILABLE to assign?
	Can be confusing reading the docs, so why not just ask SQL Server?
*/

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