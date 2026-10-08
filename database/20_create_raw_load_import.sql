/*
Project: Timber Data Platform
Script: 20_create_raw_load_import.sql

Purpose:
Create a raw staging table whose structure exactly matches
the cleaned load CSV file for bulk import.

Dependencies:
- TimberDataPlatform database must exist.
- stg schema must exist.

Expected Result:
- stg.LoadImportRaw exists.
- Table contains exactly the seven fields present in loads_import.csv.

Safety / Impact:
- Schema creation only.
- Does not modify dbo operational data.

Created: 2026-09-05
*/

USE TimberDataPlatform;
GO

IF OBJECT_ID('stg.LoadImportRaw', 'U') IS NULL
BEGIN
    CREATE TABLE stg.LoadImportRaw
    (
        ContractNumber VARCHAR(30) NULL,
        LoadDate VARCHAR(30) NULL,
        LoadTime VARCHAR(30) NULL,
        LoadTag VARCHAR(20) NULL,
        DriverName NVARCHAR(100) NULL,
        MillName NVARCHAR(100) NULL,
        ProductCode VARCHAR(50) NULL
    );
END;
GO