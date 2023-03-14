USE AdventureWorks2012;
GO

-- Clean up the database from DB Role (HRPerson) demo
IF EXiSTS( SELECT 1 FROM sys.database_principals WHERE name = 'xrHR_Address' AND type = 'R') BEGIN
    ALTER ROLE xrHR_Addresss DROP MEMBER HRPerson
END
GO

-- Clean up the database from prior demo runs
IF EXiSTS( SELECT 1 FROM sys.database_principals WHERE name = 'xrAuditors' AND type = 'R') BEGIN
    ALTER ROLE xrAuditors DROP MEMBER AuditorPerson
    ALTER ROLE xrAuditors DROP MEMBER AuditManager
END
GO

IF EXiSTS( SELECT 1 FROM sys.database_principals WHERE name = 'xrAuditors_Admin' AND type = 'R') BEGIN
    ALTER ROLE xrAuditors_Admin DROP MEMBER AuditManager
END
GO

DROP USER IF EXISTS AuditPerson
DROP USER IF EXISTS AuditManager
GO

IF EXISTS (SELECT 1 FROM master.sys.server_principals WHERE name = 'AuditorPerson') BEGIN
    DROP LOGIN AuditorPerson -- drop from server
END
GO

IF EXISTS (SELECT 1 FROM master.sys.server_principals WHERE name = 'AuditManager') BEGIN
    DROP LOGIN AuditManager -- drop from server
END
GO

DROP ROLE IF EXiSTS xrAuditors
DROP ROLE IF EXiSTS xrAuditors_Admin
GO

DROP TABLE IF EXISTS Auditors.HelloAuditorsSchema
GO

DROP SCHEMA IF EXISTS Auditors
GO