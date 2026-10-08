/*
Project: Timber Operations, Settlement, and Financial Analytics Platform
Script: 04_verify_database_configuration.sql

Purpose:
Inspect the physical database files and important configuration settings
for the TimberDataPlatform development database.

Execution context:
- Run while connected to the local SQL Server instance.
- Queries SQL Server system catalog views.
- Does not modify database settings.

Expected result:
- Shows database status, recovery model, compatibility level, and safety settings.
- Shows logical file names, physical file locations, sizes, and autogrowth settings.

Safety / impact:
- Read-only script.
- Makes no changes to the database or server.
- Safe to rerun at any time.

Created: 2026-08-07
*/

USE master;
GO

-- Review important database-level configuration.
SELECT
    name AS DatabaseName,
    state_desc AS DatabaseState,
    recovery_model_desc AS RecoveryModel,
    compatibility_level AS CompatibilityLevel,
    page_verify_option_desc AS PageVerify,
    is_auto_close_on AS AutoCloseEnabled,
    is_auto_shrink_on AS AutoShrinkEnabled
FROM sys.databases
WHERE name = N'TimberDataPlatform';
GO

-- Review the physical data and transaction log files.
SELECT
    DB_NAME(database_id) AS DatabaseName,
    name AS LogicalFileName,
    type_desc AS FileType,
    physical_name AS PhysicalFilePath,
    CAST(size * 8.0 / 1024 AS DECIMAL(10,2)) AS SizeMB,
    CASE
        WHEN is_percent_growth = 1
            THEN CAST(growth AS VARCHAR(20)) + '%'
        ELSE
            CAST(CAST(growth * 8.0 / 1024 AS DECIMAL(10,2)) AS VARCHAR(20)) + ' MB'
    END AS AutoGrowth
FROM sys.master_files
WHERE database_id = DB_ID(N'TimberDataPlatform')
ORDER BY type_desc;
GO