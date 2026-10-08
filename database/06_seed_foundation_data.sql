/*
Project: Timber Data Platform
Script: 06_seed_foundation_data.sql

Purpose:
Insert a small set of synthetic foundation data for:
- CorporateCompany
- Region
- TimberCompany

Dependencies:
- TimberDataPlatform database must exist.
- 05_create_foundation_tables.sql must have been run successfully.

Expected Result:
- 1 corporate company
- 3 regions
- 6 timber companies
- All relationships resolve through valid foreign keys.

Safety / Impact:
- Inserts synthetic portfolio data only.
- No real company names or private operational data.

Created: 2026-08-10
*/

USE TimberDataPlatform;
GO

/* Corporate company */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.CorporateCompany
    WHERE CompanyCode = 'NTG'
)
BEGIN
    INSERT INTO dbo.CorporateCompany
    (
        CompanyName,
        CompanyCode
    )
    VALUES
    (
        N'Northstar Timber Group',
        'NTG'
    );
END;
GO

/* Regions */

DECLARE @CorporateCompanyID INT;

SELECT @CorporateCompanyID = CorporateCompanyID
FROM dbo.CorporateCompany
WHERE CompanyCode = 'NTG';

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Region
    WHERE RegionCode = 'CENTRAL'
)
BEGIN
    INSERT INTO dbo.Region
    (
        CorporateCompanyID,
        RegionName,
        RegionCode
    )
    VALUES
    (
        @CorporateCompanyID,
        N'Central Region',
        'CENTRAL'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Region
    WHERE RegionCode = 'SOUTH'
)
BEGIN
    INSERT INTO dbo.Region
    (
        CorporateCompanyID,
        RegionName,
        RegionCode
    )
    VALUES
    (
        @CorporateCompanyID,
        N'Southern Region',
        'SOUTH'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Region
    WHERE RegionCode = 'DELTA'
)
BEGIN
    INSERT INTO dbo.Region
    (
        CorporateCompanyID,
        RegionName,
        RegionCode
    )
    VALUES
    (
        @CorporateCompanyID,
        N'Delta Region',
        'DELTA'
    );
END;
GO

/* Timber companies */

DECLARE @CentralRegionID INT;
DECLARE @SouthRegionID INT;
DECLARE @DeltaRegionID INT;

SELECT @CentralRegionID = RegionID
FROM dbo.Region
WHERE RegionCode = 'CENTRAL';

SELECT @SouthRegionID = RegionID
FROM dbo.Region
WHERE RegionCode = 'SOUTH';

SELECT @DeltaRegionID = RegionID
FROM dbo.Region
WHERE RegionCode = 'DELTA';

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TimberCompany
    WHERE CompanyCode = 'PRT'
)
BEGIN
    INSERT INTO dbo.TimberCompany
    (
        RegionID,
        CompanyName,
        CompanyCode
    )
    VALUES
    (
        @CentralRegionID,
        N'Pine Ridge Timber',
        'PRT'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TimberCompany
    WHERE CompanyCode = 'BFT'
)
BEGIN
    INSERT INTO dbo.TimberCompany
    (
        RegionID,
        CompanyName,
        CompanyCode
    )
    VALUES
    (
        @CentralRegionID,
        N'Blue Fork Timber',
        'BFT'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TimberCompany
    WHERE CompanyCode = 'SCT'
)
BEGIN
    INSERT INTO dbo.TimberCompany
    (
        RegionID,
        CompanyName,
        CompanyCode
    )
    VALUES
    (
        @SouthRegionID,
        N'Southern Crest Timber',
        'SCT'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TimberCompany
    WHERE CompanyCode = 'LLT'
)
BEGIN
    INSERT INTO dbo.TimberCompany
    (
        RegionID,
        CompanyName,
        CompanyCode
    )
    VALUES
    (
        @SouthRegionID,
        N'Longleaf Timber',
        'LLT'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TimberCompany
    WHERE CompanyCode = 'DRT'
)
BEGIN
    INSERT INTO dbo.TimberCompany
    (
        RegionID,
        CompanyName,
        CompanyCode
    )
    VALUES
    (
        @DeltaRegionID,
        N'Delta River Timber',
        'DRT'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TimberCompany
    WHERE CompanyCode = 'CWT'
)
BEGIN
    INSERT INTO dbo.TimberCompany
    (
        RegionID,
        CompanyName,
        CompanyCode
    )
    VALUES
    (
        @DeltaRegionID,
        N'Cypress Woods Timber',
        'CWT'
    );
END;
GO