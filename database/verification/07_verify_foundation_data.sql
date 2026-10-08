/*
Project: Timber Data Platform
Script: 07_verify_foundation_data.sql

Purpose:
Verify foundation seed data and relationships for:
- CorporateCompany
- Region
- TimberCompany

Expected Result:
- 1 CorporateCompany
- 3 Regions
- 6 TimberCompanies
- All TimberCompanies correctly join through Region to CorporateCompany

Safety / Impact:
- Read-only verification.
- Does not insert, update, or delete data.

Created: 2026-08-12
*/

USE TimberDataPlatform;
GO

/* Verify relationships and descriptive data */

SELECT
    tc.CompanyName AS TimberCompany,
    r.RegionName,
    cc.CompanyName AS CorporateCompany
FROM dbo.TimberCompany AS tc
INNER JOIN dbo.Region AS r
    ON tc.RegionID = r.RegionID
INNER JOIN dbo.CorporateCompany AS cc
    ON r.CorporateCompanyID = cc.CorporateCompanyID
ORDER BY
    r.RegionName,
    tc.CompanyName;


/* Verify expected row counts */

SELECT 'CorporateCompany' AS TableName, COUNT(*) AS RecordCount
FROM dbo.CorporateCompany

UNION ALL

SELECT 'Region', COUNT(*)
FROM dbo.Region

UNION ALL

SELECT 'TimberCompany', COUNT(*)
FROM dbo.TimberCompany;
GO