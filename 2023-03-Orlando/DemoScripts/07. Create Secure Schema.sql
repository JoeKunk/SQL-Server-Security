/*      AUTHOR: Joseph Kunk, Senior Software Architect at Dewpoint, Lansing MI USA. 
                LinkedIn:	joe-kunk-b926091
				Twitter:	@joekunk
				Mastodon:	@joekunk@techhub.social
				Email:		joekunk@gmail.com
*/

/* 	What if some users want to create objects in your production database?

	You can limit their activity to a schema in the database 
	
	In this example, there are Auditors and AuditManagers
	Auditors can only execute custom queries, and use objects created by AuditManagers.
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

-- Grant usage rights on the Schema to the xrAuditors db role
-- All auditors will be in this role
GRANT DELETE, INSERT, SELECT, UPDATE, EXECUTE, VIEW DEFINITION, REFERENCES 
ON SCHEMA::Auditors TO xrAuditors
GO

-- Grant admin rights on the Schema to the xrAuditors_Admin db role
GRANT ALTER, CONTROL, TAKE OWNERSHIP ON SCHEMA::Auditors TO xrAuditors_Admin

-- These permissions cannot be granted to a schema, must be granted to the db role
-- Does not grant create to anywhere in the database as it may appear
-- Requires ALTER or CONTROL permission as well to be able to create an object
GRANT CREATE TABLE, CREATE VIEW, CREATE PROCEDURE, CREATE FUNCTION TO xrAuditors_Admin 
GO   

-- ALTER AUTHORIZATION on SCHEMA::Auditors to xrAuditors_Admin

/**********************************************************************************/
-- Remove standard auditor user if exists
DROP USER IF EXISTS AuditorPerson  -- drop from database
IF EXISTS (SELECT 1 FROM master.sys.server_principals WHERE name = 'AuditorPerson')
BEGIN
    DROP LOGIN AuditorPerson -- drop from server
END

-- Add standard auditor user
CREATE LOGIN AuditorPerson WITH Password='demo$1234', DEFAULT_DATABASE = [AdventureWorks2012]
CREATE USER AuditorPerson for LOGIN AuditorPerson

-- Add standard auditor user to the xrAuditors role
ALTER ROLE xrAuditors ADD MEMBER AuditorPerson
GO

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
ALTER ROLE xrAuditors ADD MEMBER AuditorPerson
GO

-- Add admin auditor user to the xrAuditors role -  admin users need to be in both db roles
ALTER ROLE xrAuditors ADD MEMBER AuditManager
ALTER ROLE xrAuditors_Admin ADD MEMBER AuditManager
GO 

-- Standard auditor cannot create a table in Auditors schema, but AuditManager can

EXECUTE AS LOGIN = 'AuditorPerson'
-- EXECUTE AS LOGIN = 'AuditManager'
DROP TABLE IF EXISTS Auditors.HelloAuditorsSchema
CREATE TABLE Auditors.HelloAuditorsSchema (
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Message] [varchar](100) NULL
) ON [PRIMARY]
GO;
REVERT;
GO

-- Can AuditManager create a table in the Person schema?
Use AdventureWorks2012;
-- EXECUTE AS LOGIN = 'AuditorPerson'
EXECUTE AS LOGIN = 'AuditManager'
DROP TABLE IF EXISTS dbo.HelloPersonSchema
CREATE TABLE dbo.HelloPersonSchema (
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Message] [varchar](100) NULL
) ON [PRIMARY]
GO
REVERT
GO


