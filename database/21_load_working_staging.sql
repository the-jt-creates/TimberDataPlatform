/*
Project: Timber Data Platform
Script: 21_load_working_staging.sql

Purpose:
Load raw CSV data from stg.LoadImportRaw into the working
staging table stg.LoadImport.

Dependencies:
- stg.LoadImportRaw must contain the imported CSV data.
- stg.LoadImport must already exist.

Expected Result:
- 59 rows inserted into stg.LoadImport.
- LoadImportID generated automatically.
- Date/time source values preserved as text for validation.
- Re-running the script does not duplicate rows because the
  working staging table is cleared first.

Safety / Impact:
- Deletes rows from stg.LoadImport only.
- Does not modify dbo operational tables.
- Does not modify stg.LoadImportRaw.

Created: 2026-09-05
*/

USE TimberDataPlatform;
GO


/* =========================================================
   Clear working staging table
   ========================================================= */

DELETE FROM stg.LoadImport;
GO


/* =========================================================
   Load raw data into working staging
   ========================================================= */

INSERT INTO stg.LoadImport
(
    ContractNumber,
    LoadDateText,
    LoadTimeText,
    LoadTag,
    DriverName,
    MillName,
    ProductCode
)
SELECT
    ContractNumber,
    LoadDate,
    LoadTime,
    LoadTag,
    DriverName,
    MillName,
    ProductCode
FROM stg.LoadImportRaw;
GO


/* =========================================================
   Verify row count
   ========================================================= */

SELECT COUNT(*) AS WorkingStagingCount
FROM stg.LoadImport;
GO


/* =========================================================
   Preview loaded staging rows
   ========================================================= */

SELECT TOP (10)
    LoadImportID,
    ContractNumber,
    LoadDateText,
    LoadTimeText,
    LoadTag,
    DriverName,
    MillName,
    ProductCode
FROM stg.LoadImport
ORDER BY LoadImportID;
GO