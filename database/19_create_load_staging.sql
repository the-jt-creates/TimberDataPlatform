/*
Project: Timber Data Platform
Script: 19_create_load_staging.sql

Purpose:
Create the staging schema and staging table used to receive
cleaned load-import data before validation and insertion into dbo.Load.

Dependencies:
- TimberDataPlatform database must exist.
- dbo.Load and related reference tables must exist.

Expected Result:
- stg schema exists.
- stg.LoadImport exists.
- Staging table accepts source-friendly text values for validation.

Safety / Impact:
- Schema creation only.
- Does not insert, update, or delete operational data.

Created: 2026-09-05
*/

USE TimberDataPlatform;
GO


/* =========================================================
   Create staging schema
   ========================================================= */

IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'stg'
)
BEGIN
    EXEC('CREATE SCHEMA stg');
END;
GO


/* =========================================================
   Create load staging table
   ========================================================= */

IF OBJECT_ID('stg.LoadImport', 'U') IS NULL
BEGIN
    CREATE TABLE stg.LoadImport
    (
        LoadImportID INT IDENTITY(1,1) NOT NULL,

        ContractNumber VARCHAR(30) NULL,
        LoadDateText VARCHAR(30) NULL,
        LoadTimeText VARCHAR(30) NULL,
        LoadTag VARCHAR(20) NULL,
        DriverName NVARCHAR(100) NULL,
        MillName NVARCHAR(100) NULL,
        ProductCode VARCHAR(50) NULL,

        CONSTRAINT PK_LoadImport
            PRIMARY KEY (LoadImportID)
    );
END;
GO