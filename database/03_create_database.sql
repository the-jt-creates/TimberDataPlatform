/*
Project: Timber Operations, Settlement, and Financial Analytics Platform
Script: 03_create_database.sql

Purpose:
Create the primary SQL Server development database for the portfolio project.

Execution context:
- Run while connected to the local SQL Server instance.
- Run from the master database.
- Requires permission to create databases.

Expected result:
- Creates a database named TimberDataPlatform if it does not already exist.
- Does not recreate or overwrite the database if it already exists.
- Returns database information so creation can be verified.

Safety / impact:
- Non-destructive if TimberDataPlatform already exists.
- Does not drop, overwrite, or modify an existing database.
- This project will use synthetic portfolio data only.

Created: 2026-08-07
*/

USE master;
GO

-- Create the project database only if it does not already exist.
IF DB_ID(N'TimberDataPlatform') IS NULL
BEGIN
    PRINT 'Creating TimberDataPlatform database...';

    CREATE DATABASE TimberDataPlatform;

    PRINT 'TimberDataPlatform database created successfully.';
END
ELSE
BEGIN
    PRINT 'TimberDataPlatform already exists. No changes were made.';
END;
GO

-- Verify that the database exists and review its current status.
SELECT
    name AS DatabaseName,
    database_id AS DatabaseID,
    create_date AS CreatedDate,
    state_desc AS DatabaseState,
    recovery_model_desc AS RecoveryModel,
    compatibility_level AS CompatibilityLevel
FROM sys.databases
WHERE name = N'TimberDataPlatform';
GO