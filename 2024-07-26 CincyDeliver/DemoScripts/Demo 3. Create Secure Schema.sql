/*
DEMO 3

 	What if some users want to create objects in your production database?

	You can limit their activity to a schema in the database 

	In this example, there are Auditors and AuditManagers
	Auditors can only execute custom queries and use objects created by AuditManagers.
*/

USE AdventureWorks2012;
GO

-- Create the database schema
DROP SCHEMA IF EXISTS Auditors
GO
CREATE SCHEMA Auditors
GO

-- Create two database roles, one for auditors and one to admin the schema
CREATE ROLE xrAuditors 

CREATE ROLE xrAuditors_Admin
GO

-- Grant limited usage rights on the Schema to the xrAuditors db role
-- All auditors, including admins, will be in this role
GRANT DELETE, INSERT, SELECT, UPDATE, EXECUTE, VIEW DEFINITION, REFERENCES 
ON SCHEMA::Auditors TO xrAuditors
GO

-- Grant admin rights on the Schema to the xrAuditors_Admin db role
GRANT ALTER, CONTROL, TAKE OWNERSHIP ON SCHEMA::Auditors TO xrAuditors_Admin

-- At first glance below, it looks like I am granting permissins to create anywhere in the DB
-- But I am not! 

-- These permissions cannot be granted to a schema, must be granted to the db role
-- No concern - does not grant this permissions database-wide as it appears
-- Requires ALTER or CONTROL permission as well to be able to create an object
-- which has only been granted to schema Auditors
GRANT CREATE TABLE, CREATE VIEW, CREATE PROCEDURE, CREATE FUNCTION TO xrAuditors_Admin 
GO   

/**********************************************************************************/
-- Drop and add Auditor and AuditManager
DROP USER IF EXISTS Auditor  -- drop from database
IF EXISTS (SELECT 1 FROM master.sys.server_principals WHERE name = 'Auditor')
BEGIN
    DROP LOGIN Auditor -- drop from server
END

CREATE LOGIN Auditor WITH Password='demo$1234', DEFAULT_DATABASE = [AdventureWorks2012]
CREATE USER Auditor for LOGIN Auditor

-- Remove admin auditor user if exists
DROP USER IF EXISTS AuditManager  -- drop from database
IF EXISTS (SELECT 1 FROM master.sys.server_principals WHERE name = 'AuditManager')
BEGIN
    DROP LOGIN AuditManager -- drop from server
END

-- Add admin auditor user
CREATE LOGIN AuditManager WITH Password='demo$1234', DEFAULT_DATABASE = [AdventureWorks2012]
CREATE USER AuditManager for LOGIN AuditManager
/**********************************************************************************/

-- Add standard auditor user to the xrAuditors role
ALTER ROLE xrAuditors ADD MEMBER Auditor
GO

-- Add admin auditor user to the xrAuditors role -  admin users need to be in both db roles
ALTER ROLE xrAuditors ADD MEMBER AuditManager
ALTER ROLE xrAuditors_Admin ADD MEMBER AuditManager
GO 

-- Auditor cannot create a table in Auditors schema
EXECUTE AS LOGIN = 'Auditor'
		DROP TABLE IF EXISTS Auditors.HelloAuditorsSchema
		CREATE TABLE Auditors.HelloAuditorsSchema (
			[ID] [int] IDENTITY(1,1) NOT NULL,
			[Message] [varchar](100) NULL
		) ON [PRIMARY]
		GO
REVERT;
GO


-- AuditManager can create a table in Auditors schema
EXECUTE AS LOGIN = 'AuditManager'
		DROP TABLE IF EXISTS Auditors.HelloAuditorsSchema
		CREATE TABLE Auditors.HelloAuditorsSchema (
			[ID] [int] IDENTITY(1,1) NOT NULL,
			[Message] [varchar](100) NULL
		) ON [PRIMARY]
		GO
REVERT;
GO


-- AuditManager can NOT create a table in any other schema
Use AdventureWorks2012;
EXECUTE AS LOGIN = 'AuditManager'
		DROP TABLE IF EXISTS HumanResources.HelloPersonSchema
		CREATE TABLE HumanResources.HelloPersonSchema (
			[ID] [int] IDENTITY(1,1) NOT NULL,
			[Message] [varchar](100) NULL
		) ON [PRIMARY]
		GO
REVERT
GO
