-- View permissions within the database

--		Select * from sys.database_permissions where grantee_principal_id = 5

SELECT 
	dpr.name as [Database User]
	, dpr.type_desc as [Login Type]
	, dpm.state_desc as [Level]
	, dpm.permission_name as [Permission]
	, CASE  WHEN st.schema_id is not null THEN Schema_Name(st.schema_id)
			WHEN sv.schema_id is not null THEN Schema_Name(sv.schema_id)
			WHEN prc.schema_id is not null THEN Schema_Name(prc.schema_id)
	  END as [Schema]
	, OBJECT_NAME(Major_id) as [Object]
	, CASE WHEN Minor_ID = 0 THEN NULL ELSE minor_id END as Column_Ordinal
	, col.name as Column_Name
FROM sys.database_permissions dpm
	LEFT JOIN sys.database_principals dpr on dpm.grantee_principal_id = dpr.principal_id
	LEFT JOIN sys.tables st on st.object_id = dpm.major_id
	LEFT JOIN sys.columns col on col.object_id = major_id and col.column_id = minor_id
	LEFT JOIN sys.procedures prc on prc.object_id = major_id
	LEFT JOIN sys.views sv on sv.object_id = dpm.major_id
	WHERE dpr.name in ('HRPerson')
