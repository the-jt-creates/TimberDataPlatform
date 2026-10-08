/*
Project: Timber Data Platform
Script: 22_validate_load_staging.sql

Purpose:
Validate working load-staging data before insertion into dbo.Load.

Checks:
- Date conversion
--Unknow contracts
- Time conversion
- Missing/unknown drivers
- Unknown mills
- Unknown products
- Duplicate ContractNumber + LoadTag keys
- Driver authorization for contract/timber company
- Mill/product compatibility

Safety / Impact:
- Read-only validation.
- Does not modify staging or production data.

Created: 2026-09-05
*/

USE TimberDataPlatform;
GO


/* =========================================================
   1. Date / Time conversion checks
   ========================================================= */

SELECT
    LoadImportID,
    LoadDateText,
    TRY_CONVERT(date, LoadDateText) AS ConvertedLoadDate,
    LoadTimeText,
    TRY_CONVERT(time, LoadTimeText) AS ConvertedLoadTime
FROM stg.LoadImport
WHERE TRY_CONVERT(date, LoadDateText) IS NULL
   OR TRY_CONVERT(time, LoadTimeText) IS NULL;
GO

/* =========================================================
   2. Unknown contracts
   ========================================================= */

SELECT
    li.LoadImportID,
    li.ContractNumber
FROM stg.LoadImport AS li
LEFT JOIN dbo.Contract AS c
    ON c.ContractNumber = li.ContractNumber
WHERE c.ContractID IS NULL;
GO


/* =========================================================
   3. Missing or unknown drivers
   ========================================================= */

SELECT
    li.LoadImportID,
    li.ContractNumber,
    li.DriverName
FROM stg.LoadImport AS li
LEFT JOIN dbo.Driver AS d
    ON CONCAT(d.FirstName, ' ', d.LastName) = li.DriverName
WHERE li.DriverName IS NULL
   OR LTRIM(RTRIM(li.DriverName)) = ''
   OR d.DriverID IS NULL;
GO


/* =========================================================
   4. Unknown mills
   ========================================================= */

SELECT
    li.LoadImportID,
    li.ContractNumber,
    li.MillName
FROM stg.LoadImport AS li
LEFT JOIN dbo.Mill AS m
    ON m.MillName = li.MillName
WHERE m.MillID IS NULL;
GO


/* =========================================================
   5. Unknown products
   ========================================================= */

SELECT
    li.LoadImportID,
    li.ContractNumber,
    li.ProductCode
FROM stg.LoadImport AS li
LEFT JOIN dbo.ProductType AS pt
    ON pt.ProductCode = li.ProductCode
WHERE pt.ProductTypeID IS NULL;
GO


/* =========================================================
   6. Duplicate ContractNumber + LoadTag keys
   ========================================================= */

SELECT
    ContractNumber,
    LoadTag,
    COUNT(*) AS DuplicateCount
FROM stg.LoadImport
GROUP BY
    ContractNumber,
    LoadTag
HAVING COUNT(*) > 1
ORDER BY
    ContractNumber,
    LoadTag;
GO


/* =========================================================
   7. Driver authorization check
   Contract -> TimberCompany -> authorized TruckingCompany
   -> Driver
   ========================================================= */

SELECT
    li.LoadImportID,
    li.ContractNumber,
    li.DriverName,
    tc.CompanyName AS TimberCompany,
    tkc.CompanyName AS DriverTruckingCompany
FROM stg.LoadImport AS li
INNER JOIN dbo.Contract AS c
    ON c.ContractNumber = li.ContractNumber
INNER JOIN dbo.TimberCompany AS tc
    ON tc.TimberCompanyID = c.TimberCompanyID
INNER JOIN dbo.Driver AS d
    ON CONCAT(d.FirstName, ' ', d.LastName) = li.DriverName
INNER JOIN dbo.TruckingCompany AS tkc
    ON tkc.TruckingCompanyID = d.TruckingCompanyID
LEFT JOIN dbo.TimberCompanyTruckingCompany AS tctc
    ON tctc.TimberCompanyID = tc.TimberCompanyID
   AND tctc.TruckingCompanyID = tkc.TruckingCompanyID
WHERE tctc.TimberCompanyID IS NULL;
GO


/* =========================================================
   8. Mill / Product compatibility
   ========================================================= */

SELECT
    li.LoadImportID,
    li.ContractNumber,
    li.MillName,
    li.ProductCode
FROM stg.LoadImport AS li
INNER JOIN dbo.Mill AS m
    ON m.MillName = li.MillName
INNER JOIN dbo.ProductType AS pt
    ON pt.ProductCode = li.ProductCode
LEFT JOIN dbo.MillProductType AS mpt
    ON mpt.MillID = m.MillID
   AND mpt.ProductTypeID = pt.ProductTypeID
WHERE mpt.MillID IS NULL;
GO


/* =========================================================
   9. Is the mill on this staged load an allowed route for this contract?
   ========================================================= */
   SELECT
    li.LoadImportID,
    li.ContractNumber,
    li.MillName
FROM stg.LoadImport AS li
INNER JOIN dbo.Contract AS c
    ON li.ContractNumber = c.ContractNumber
INNER JOIN dbo.Mill AS m
    ON li.MillName = m.MillName
LEFT JOIN dbo.ContractMillRoute AS cmr
    ON cmr.ContractID = c.ContractID
   AND cmr.MillID = m.MillID
WHERE cmr.ContractMillRouteID IS NULL
ORDER BY
    li.ContractNumber,
    li.MillName;
GO
