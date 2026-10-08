/*
Project: Timber Data Platform
Script: 16_verify_mill_product_rate_data.sql

Purpose:
Verify synthetic mill, product, route, and rate data.

Expected Result:
- 3 MillCompanies
- 6 Mills
- 5 ProductTypes
- 13 MillProductType relationships
- 4 ContractMillRoute rows
- 6 ContractProductRate rows
- Mill/Product and Contract/Rate relationships resolve correctly.

Safety / Impact:
- Read-only verification.
- Does not insert, update, or delete data.

Created: 2026-08-24
*/

USE TimberDataPlatform;
GO


/* =========================================================
   Verify expected row counts
   ========================================================= */

SELECT 'MillCompany' AS TableName, COUNT(*) AS RecordCount
FROM dbo.MillCompany

UNION ALL

SELECT 'Mill', COUNT(*)
FROM dbo.Mill

UNION ALL

SELECT 'ProductType', COUNT(*)
FROM dbo.ProductType

UNION ALL

SELECT 'MillProductType', COUNT(*)
FROM dbo.MillProductType

UNION ALL

SELECT 'ContractMillRoute', COUNT(*)
FROM dbo.ContractMillRoute

UNION ALL

SELECT 'ContractProductRate', COUNT(*)
FROM dbo.ContractProductRate;
GO


/* =========================================================
   Verify MillCompany -> Mill relationships
   ========================================================= */

SELECT
    mc.CompanyName AS MillCompany,
    m.MillName,
    m.City,
    m.StateCode
FROM dbo.MillCompany AS mc
INNER JOIN dbo.Mill AS m
    ON mc.MillCompanyID = m.MillCompanyID
ORDER BY
    mc.CompanyName,
    m.MillName;
GO


/* =========================================================
   Verify Mill <-> ProductType many-to-many relationships
   ========================================================= */

SELECT
    m.MillName,
    pt.ProductCode,
    pt.ProductTypeName
FROM dbo.Mill AS m
INNER JOIN dbo.MillProductType AS mpt
    ON m.MillID = mpt.MillID
INNER JOIN dbo.ProductType AS pt
    ON mpt.ProductTypeID = pt.ProductTypeID
ORDER BY
    m.MillName,
    pt.ProductCode;
GO


/* =========================================================
   Verify Contract -> Mill routes and haul rates
   ========================================================= */

SELECT
    c.ContractNumber,
    m.MillName,
    cmr.Miles,
    cmr.HaulRate
FROM dbo.Contract AS c
INNER JOIN dbo.ContractMillRoute AS cmr
    ON c.ContractID = cmr.ContractID
INNER JOIN dbo.Mill AS m
    ON cmr.MillID = m.MillID
ORDER BY
    c.ContractNumber,
    m.MillName;
GO


/* =========================================================
   Verify Contract -> ProductType cut/load rates
   ========================================================= */

SELECT
    c.ContractNumber,
    pt.ProductCode,
    pt.ProductTypeName,
    cpr.CutLoadRate
FROM dbo.Contract AS c
INNER JOIN dbo.ContractProductRate AS cpr
    ON c.ContractID = cpr.ContractID
INNER JOIN dbo.ProductType AS pt
    ON cpr.ProductTypeID = pt.ProductTypeID
ORDER BY
    c.ContractNumber,
    pt.ProductCode;
GO