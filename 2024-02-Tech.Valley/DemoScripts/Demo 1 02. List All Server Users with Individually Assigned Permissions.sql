/*
DEMO 1

		1. Create USER1, USER2, USER3 in the database
		2. Grant them some individual permissions
		3. Create the stored procedure [dbo].[ListPermissions]
		4. Run the stored procedure to see the permissions
*/

USE [AdventureWorks2012]
GO

-- Create the login in the server
CREATE LOGIN USER1 WITH Password='demo$1234', DEFAULT_DATABASE = [AdventureWorks2012]
CREATE LOGIN USER2 WITH Password='demo$1234', DEFAULT_DATABASE = [AdventureWorks2012]
CREATE LOGIN USER3 WITH Password='demo$1234', DEFAULT_DATABASE = [AdventureWorks2012]

-- Create the user in the database
CREATE USER USER1 for LOGIN USER1
CREATE USER USER2 for LOGIN USER2
CREATE USER USER3 for LOGIN USER3

-- Assign some permissions
GRANT SELECT ON [Production].[Product] TO USER1
GRANT UPDATE ON [Production].[Product] TO USER2
GRANT EXECUTE ON [dbo].[uspGetBillOfMaterials] to USER3

/*
	DROP USER IF EXISTS USER1; 	DROP LOGIN USER1
	DROP USER IF EXISTS USER2; 	DROP LOGIN USER2
	DROP USER IF EXISTS USER3; 	DROP LOGIN USER3
*/


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[ListPermissions]
	@dbName varchar(100) = 'AdventureWorks2012'
AS BEGIN

	-- Based upon: https://stackoverflow.com/questions/35336351/to-find-database-names-users-and-permissions

	DECLARE @databases TABLE (dbname nvarchar(50))
	-- Add the databases you want to see in the WHERE condition
	-- Comment out the WHERE condition to see all databases on the server
	-- but can take a while to run on a large server

	INSERT INTO @databases
	SELECT name
	FROM sys.databases
	WHERE (name = @dbName) OR (@dbName = 'all')

	DECLARE @table TABLE (
		db nvarchar(100),
		Username nvarchar(100),
		UserType nvarchar(100),
		DatabaseUserName nvarchar(100),
		[Role] nvarchar(100),      
		PermissionType nvarchar(100),       
		PermissionState nvarchar(100), 
		ObjectType nvarchar(100),       
		ObjectName nvarchar(100),
		ColumnName nvarchar(100)
	)

	DECLARE @DBN nVARCHAR(100)
			,@sqlText NVARCHAR(max)
			,@sql NVARCHAR(max)
			,@n int = 0
			,@i int = 0

	SET @sqlText = 
	'--List all access provisioned to a sql user or windows user/group directly 
	SELECT  
		[db] = DB_NAME(),
		[UserName] = CASE princ.[type] 
						WHEN '+CHAR(39)+'S'+CHAR(39)+' THEN princ.[name]
						WHEN '+CHAR(39)+'U'+CHAR(39)+' THEN ulogin.[name] COLLATE Latin1_General_CI_AI
					 END,
		[UserType] = CASE princ.[type]
						WHEN '+CHAR(39)+'S'+CHAR(39)+' THEN '+CHAR(39)+'SQL User'+CHAR(39)+'
						WHEN '+CHAR(39)+'U'+CHAR(39)+' THEN '+CHAR(39)+'Windows User'+CHAR(39)+'
					 END,  
		[DatabaseUserName] = princ.[name],       
		[Role] = null,      
		[PermissionType] = perm.[permission_name],       
		[PermissionState] = perm.[state_desc],       
		[ObjectType] = obj.type_desc,--perm.[class_desc],       
		[ObjectName] = OBJECT_NAME(perm.major_id),
		[ColumnName] = col.[name]
	FROM    
		--database user
		sys.database_principals princ  
	LEFT JOIN
		--Login accounts
		sys.login_token ulogin on princ.[sid] = ulogin.[sid]
	LEFT JOIN        
		--Permissions
		sys.database_permissions perm ON perm.[grantee_principal_id] = princ.[principal_id]
	LEFT JOIN
		--Table columns
		sys.columns col ON col.[object_id] = perm.major_id 
						AND col.[column_id] = perm.[minor_id]
	LEFT JOIN
		sys.objects obj ON perm.[major_id] = obj.[object_id]
	WHERE 
		princ.[type] in ('+CHAR(39)+'S'+CHAR(39)+','+CHAR(39)+'U'+CHAR(39)+')
	UNION
	--List all access provisioned to a sql user or windows user/group through a database or application role
	SELECT  
		[db] = DB_NAME(),
		[UserName] = CASE memberprinc.[type] 
						WHEN '+CHAR(39)+'S'+CHAR(39)+' THEN memberprinc.[name]
						WHEN '+CHAR(39)+'U'+CHAR(39)+' THEN ulogin.[name] COLLATE Latin1_General_CI_AI
					 END,
		[UserType] = CASE memberprinc.[type]
						WHEN '+CHAR(39)+'S'+CHAR(39)+' THEN '+CHAR(39)+'SQL User'+CHAR(39)+'
						WHEN '+CHAR(39)+'U'+CHAR(39)+' THEN '+CHAR(39)+'Windows User'+CHAR(39)+'
					 END, 
		[DatabaseUserName] = memberprinc.[name],   
		[Role] = roleprinc.[name],      
		[PermissionType] = perm.[permission_name],       
		[PermissionState] = perm.[state_desc],       
		[ObjectType] = obj.type_desc,--perm.[class_desc],   
		[ObjectName] = OBJECT_NAME(perm.major_id),
		[ColumnName] = col.[name]
	FROM    
		--Role/member associations
		sys.database_role_members members
	JOIN
		--Roles
		sys.database_principals roleprinc ON roleprinc.[principal_id] = members.[role_principal_id]
	JOIN
		--Role members (database users)
		sys.database_principals memberprinc ON memberprinc.[principal_id] = members.[member_principal_id]
	LEFT JOIN
		--Login accounts
		sys.login_token ulogin on memberprinc.[sid] = ulogin.[sid]
	LEFT JOIN        
		--Permissions
		sys.database_permissions perm ON perm.[grantee_principal_id] = roleprinc.[principal_id]
	LEFT JOIN
		--Table columns
		sys.columns col on col.[object_id] = perm.major_id 
						AND col.[column_id] = perm.[minor_id]
	LEFT JOIN
		sys.objects obj ON perm.[major_id] = obj.[object_id]
	UNION
	--List all access provisioned to the public role, which everyone gets by default
	SELECT 
		[db] = DB_NAME(),
		[UserName] = '+CHAR(39)+'{All Users}'+CHAR(39)+',
		[UserType] = '+CHAR(39)+'{All Users}'+CHAR(39)+', 
		[DatabaseUserName] = '+CHAR(39)+'{All Users}'+CHAR(39)+',       
		[Role] = roleprinc.[name],      
		[PermissionType] = perm.[permission_name],       
		[PermissionState] = perm.[state_desc],       
		[ObjectType] = obj.type_desc,--perm.[class_desc],  
		[ObjectName] = OBJECT_NAME(perm.major_id),
		[ColumnName] = col.[name]
	FROM    
		--Roles
		sys.database_principals roleprinc
	LEFT JOIN        
		--Role permissions
		sys.database_permissions perm ON perm.[grantee_principal_id] = roleprinc.[principal_id]
	LEFT JOIN
		--Table columns
		sys.columns col on col.[object_id] = perm.major_id 
						AND col.[column_id] = perm.[minor_id]                   
	JOIN 
		--All objects   
		sys.objects obj ON obj.[object_id] = perm.[major_id]
	WHERE
		--Only roles
		roleprinc.[type] = '+CHAR(39)+'R'+CHAR(39)+' AND
		--Only public role
		roleprinc.[name] = '+CHAR(39)+'public'+CHAR(39)+' AND
		--Only objects of ours, not the MS objects
		obj.is_ms_shipped = 0
	ORDER BY
		princ.[Name],
		OBJECT_NAME(perm.major_id),
		col.[name],
		perm.[permission_name],
		perm.[state_desc],
		obj.type_desc--perm.[class_desc]'

	SELECT @n = COUNT(*)
	FROM @databases

	WHILE @n > @i
	BEGIN
		SELECT TOP 1 @DBN = dbname FROM @databases
		IF (@DBN <> 'msdb' AND @DBN <> 'tempdb') BEGIN
			SET @sql = 'USE '+@DBN +' '+@sqlText

			INSERT INTO @table
			EXEC sp_executesql @sql
		END
		set @i = @i+1
		DELETE FROM @databases WHERE dbname = @DBN
	END

	SELECT * 
	FROM @table
	WHERE 
		COALESCE(PermissionType, PermissionState, ObjectType,ObjectName,ColumnName) <> ''
	ORDER BY DB, DatabaseUserName, ObjectType, ObjectName, ColumnName
END