/*
Project: Timber Data Platform
Script: 15_seed_mill_product_rate_data.sql

Purpose:
Insert synthetic mill companies, mills, product types,
mill/product acceptance relationships, contract/mill routes,
and contract/product rates.

Dependencies:
- TimberDataPlatform database must exist.
- dbo.Contract must contain synthetic contract data.
- 14_create_mill_product_rate_tables.sql must have been run successfully.

Expected Result:
- 3 MillCompanies
- 6 Mills
- 5 ProductTypes
- Multiple MillProductType relationships
- Multiple ContractMillRoute rows
- Multiple ContractProductRate rows

Safety / Impact:
- Inserts synthetic portfolio data only.
- No real company names, mill names, or private operational data.

Created: 2026-08-24
*/

USE TimberDataPlatform;
GO


/* =========================================================
   Mill Companies
   ========================================================= */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.MillCompany
    WHERE CompanyCode = 'GFP'
)
BEGIN
    INSERT INTO dbo.MillCompany
    (
        CompanyName,
        CompanyCode
    )
    VALUES
    (
        N'Green Forest Products',
        'GFP'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.MillCompany
    WHERE CompanyCode = 'SRL'
)
BEGIN
    INSERT INTO dbo.MillCompany
    (
        CompanyName,
        CompanyCode
    )
    VALUES
    (
        N'Southern River Lumber',
        'SRL'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.MillCompany
    WHERE CompanyCode = 'BFP'
)
BEGIN
    INSERT INTO dbo.MillCompany
    (
        CompanyName,
        CompanyCode
    )
    VALUES
    (
        N'Bluewater Forest Products',
        'BFP'
    );
END;
GO


/* =========================================================
   Look up MillCompany IDs
   ========================================================= */

DECLARE @GFP_ID INT;
DECLARE @SRL_ID INT;
DECLARE @BFP_ID INT;

SELECT @GFP_ID = MillCompanyID
FROM dbo.MillCompany
WHERE CompanyCode = 'GFP';

SELECT @SRL_ID = MillCompanyID
FROM dbo.MillCompany
WHERE CompanyCode = 'SRL';

SELECT @BFP_ID = MillCompanyID
FROM dbo.MillCompany
WHERE CompanyCode = 'BFP';


/* =========================================================
   Mills
   ========================================================= */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Mill
    WHERE MillCompanyID = @GFP_ID
      AND MillName = N'River City Mill'
)
BEGIN
    INSERT INTO dbo.Mill
    (
        MillCompanyID,
        MillName,
        City,
        StateCode
    )
    VALUES
    (
        @GFP_ID,
        N'River City Mill',
        N'Riverton',
        'MS'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Mill
    WHERE MillCompanyID = @GFP_ID
      AND MillName = N'Pine Valley Mill'
)
BEGIN
    INSERT INTO dbo.Mill
    (
        MillCompanyID,
        MillName,
        City,
        StateCode
    )
    VALUES
    (
        @GFP_ID,
        N'Pine Valley Mill',
        N'Clearwater',
        'MS'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Mill
    WHERE MillCompanyID = @SRL_ID
      AND MillName = N'Delta Crossing Mill'
)
BEGIN
    INSERT INTO dbo.Mill
    (
        MillCompanyID,
        MillName,
        City,
        StateCode
    )
    VALUES
    (
        @SRL_ID,
        N'Delta Crossing Mill',
        N'Westhaven',
        'MS'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Mill
    WHERE MillCompanyID = @SRL_ID
      AND MillName = N'Southern Ridge Mill'
)
BEGIN
    INSERT INTO dbo.Mill
    (
        MillCompanyID,
        MillName,
        City,
        StateCode
    )
    VALUES
    (
        @SRL_ID,
        N'Southern Ridge Mill',
        N'Lakeview',
        'MS'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Mill
    WHERE MillCompanyID = @BFP_ID
      AND MillName = N'Bluewater North Mill'
)
BEGIN
    INSERT INTO dbo.Mill
    (
        MillCompanyID,
        MillName,
        City,
        StateCode
    )
    VALUES
    (
        @BFP_ID,
        N'Bluewater North Mill',
        N'Northfield',
        'MS'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Mill
    WHERE MillCompanyID = @BFP_ID
      AND MillName = N'Bluewater South Mill'
)
BEGIN
    INSERT INTO dbo.Mill
    (
        MillCompanyID,
        MillName,
        City,
        StateCode
    )
    VALUES
    (
        @BFP_ID,
        N'Bluewater South Mill',
        N'Southport',
        'MS'
    );
END;
GO


/* =========================================================
   Product Types
   ========================================================= */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.ProductType
    WHERE ProductCode = 'PPW'
)
BEGIN
    INSERT INTO dbo.ProductType
    (
        ProductCode,
        ProductTypeName
    )
    VALUES
    (
        'PPW',
        N'Pine Pulpwood'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.ProductType
    WHERE ProductCode = 'HPW'
)
BEGIN
    INSERT INTO dbo.ProductType
    (
        ProductCode,
        ProductTypeName
    )
    VALUES
    (
        'HPW',
        N'Hardwood Pulpwood'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.ProductType
    WHERE ProductCode = 'CNS'
)
BEGIN
    INSERT INTO dbo.ProductType
    (
        ProductCode,
        ProductTypeName
    )
    VALUES
    (
        'CNS',
        N'Chip-N-Saw'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.ProductType
    WHERE ProductCode = 'PST'
)
BEGIN
    INSERT INTO dbo.ProductType
    (
        ProductCode,
        ProductTypeName
    )
    VALUES
    (
        'PST',
        N'Pine Sawtimber'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.ProductType
    WHERE ProductCode = 'HST'
)
BEGIN
    INSERT INTO dbo.ProductType
    (
        ProductCode,
        ProductTypeName
    )
    VALUES
    (
        'HST',
        N'Hardwood Sawtimber'
    );
END;
GO


/* =========================================================
   Look up Mill and ProductType IDs
   ========================================================= */

DECLARE @RiverCityMillID INT;
DECLARE @PineValleyMillID INT;
DECLARE @DeltaCrossingMillID INT;
DECLARE @SouthernRidgeMillID INT;
DECLARE @BluewaterNorthMillID INT;
DECLARE @BluewaterSouthMillID INT;

DECLARE @PPW_ID INT;
DECLARE @HPW_ID INT;
DECLARE @CNS_ID INT;
DECLARE @PST_ID INT;
DECLARE @HST_ID INT;

SELECT @RiverCityMillID = MillID
FROM dbo.Mill
WHERE MillName = N'River City Mill';

SELECT @PineValleyMillID = MillID
FROM dbo.Mill
WHERE MillName = N'Pine Valley Mill';

SELECT @DeltaCrossingMillID = MillID
FROM dbo.Mill
WHERE MillName = N'Delta Crossing Mill';

SELECT @SouthernRidgeMillID = MillID
FROM dbo.Mill
WHERE MillName = N'Southern Ridge Mill';

SELECT @BluewaterNorthMillID = MillID
FROM dbo.Mill
WHERE MillName = N'Bluewater North Mill';

SELECT @BluewaterSouthMillID = MillID
FROM dbo.Mill
WHERE MillName = N'Bluewater South Mill';

SELECT @PPW_ID = ProductTypeID
FROM dbo.ProductType
WHERE ProductCode = 'PPW';

SELECT @HPW_ID = ProductTypeID
FROM dbo.ProductType
WHERE ProductCode = 'HPW';

SELECT @CNS_ID = ProductTypeID
FROM dbo.ProductType
WHERE ProductCode = 'CNS';

SELECT @PST_ID = ProductTypeID
FROM dbo.ProductType
WHERE ProductCode = 'PST';

SELECT @HST_ID = ProductTypeID
FROM dbo.ProductType
WHERE ProductCode = 'HST';


/* =========================================================
   Mill / Product Type Relationships
   ========================================================= */

/* River City accepts PPW, CNS, PST */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.MillProductType
    WHERE MillID = @RiverCityMillID
      AND ProductTypeID = @PPW_ID
)
BEGIN
    INSERT INTO dbo.MillProductType (MillID, ProductTypeID)
    VALUES (@RiverCityMillID, @PPW_ID);
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.MillProductType
    WHERE MillID = @RiverCityMillID
      AND ProductTypeID = @CNS_ID
)
BEGIN
    INSERT INTO dbo.MillProductType (MillID, ProductTypeID)
    VALUES (@RiverCityMillID, @CNS_ID);
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.MillProductType
    WHERE MillID = @RiverCityMillID
      AND ProductTypeID = @PST_ID
)
BEGIN
    INSERT INTO dbo.MillProductType (MillID, ProductTypeID)
    VALUES (@RiverCityMillID, @PST_ID);
END;


/* Pine Valley accepts PPW and PST */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.MillProductType
    WHERE MillID = @PineValleyMillID
      AND ProductTypeID = @PPW_ID
)
BEGIN
    INSERT INTO dbo.MillProductType (MillID, ProductTypeID)
    VALUES (@PineValleyMillID, @PPW_ID);
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.MillProductType
    WHERE MillID = @PineValleyMillID
      AND ProductTypeID = @PST_ID
)
BEGIN
    INSERT INTO dbo.MillProductType (MillID, ProductTypeID)
    VALUES (@PineValleyMillID, @PST_ID);
END;


/* Delta Crossing accepts HPW and HST */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.MillProductType
    WHERE MillID = @DeltaCrossingMillID
      AND ProductTypeID = @HPW_ID
)
BEGIN
    INSERT INTO dbo.MillProductType (MillID, ProductTypeID)
    VALUES (@DeltaCrossingMillID, @HPW_ID);
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.MillProductType
    WHERE MillID = @DeltaCrossingMillID
      AND ProductTypeID = @HST_ID
)
BEGIN
    INSERT INTO dbo.MillProductType (MillID, ProductTypeID)
    VALUES (@DeltaCrossingMillID, @HST_ID);
END;


/* Southern Ridge accepts PPW and CNS */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.MillProductType
    WHERE MillID = @SouthernRidgeMillID
      AND ProductTypeID = @PPW_ID
)
BEGIN
    INSERT INTO dbo.MillProductType (MillID, ProductTypeID)
    VALUES (@SouthernRidgeMillID, @PPW_ID);
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.MillProductType
    WHERE MillID = @SouthernRidgeMillID
      AND ProductTypeID = @CNS_ID
)
BEGIN
    INSERT INTO dbo.MillProductType (MillID, ProductTypeID)
    VALUES (@SouthernRidgeMillID, @CNS_ID);
END;


/* Bluewater North accepts PPW and HPW */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.MillProductType
    WHERE MillID = @BluewaterNorthMillID
      AND ProductTypeID = @PPW_ID
)
BEGIN
    INSERT INTO dbo.MillProductType (MillID, ProductTypeID)
    VALUES (@BluewaterNorthMillID, @PPW_ID);
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.MillProductType
    WHERE MillID = @BluewaterNorthMillID
      AND ProductTypeID = @HPW_ID
)
BEGIN
    INSERT INTO dbo.MillProductType (MillID, ProductTypeID)
    VALUES (@BluewaterNorthMillID, @HPW_ID);
END;


/* Bluewater South accepts CNS and PST */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.MillProductType
    WHERE MillID = @BluewaterSouthMillID
      AND ProductTypeID = @CNS_ID
)
BEGIN
    INSERT INTO dbo.MillProductType (MillID, ProductTypeID)
    VALUES (@BluewaterSouthMillID, @CNS_ID);
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.MillProductType
    WHERE MillID = @BluewaterSouthMillID
      AND ProductTypeID = @PST_ID
)
BEGIN
    INSERT INTO dbo.MillProductType (MillID, ProductTypeID)
    VALUES (@BluewaterSouthMillID, @PST_ID);
END;
GO


/* =========================================================
   Look up Contract, Mill, and ProductType IDs again
   for the next batch
   ========================================================= */

DECLARE @CNT2001_ID INT;
DECLARE @CNT2002_ID INT;
DECLARE @CNT2003_ID INT;

DECLARE @RiverCityMillID2 INT;
DECLARE @PineValleyMillID2 INT;
DECLARE @DeltaCrossingMillID2 INT;
DECLARE @SouthernRidgeMillID2 INT;

DECLARE @PPW_ID2 INT;
DECLARE @HPW_ID2 INT;
DECLARE @CNS_ID2 INT;
DECLARE @PST_ID2 INT;

SELECT @CNT2001_ID = ContractID
FROM dbo.Contract
WHERE ContractNumber = 'CNT-2001';

SELECT @CNT2002_ID = ContractID
FROM dbo.Contract
WHERE ContractNumber = 'CNT-2002';

SELECT @CNT2003_ID = ContractID
FROM dbo.Contract
WHERE ContractNumber = 'CNT-2003';

SELECT @RiverCityMillID2 = MillID
FROM dbo.Mill
WHERE MillName = N'River City Mill';

SELECT @PineValleyMillID2 = MillID
FROM dbo.Mill
WHERE MillName = N'Pine Valley Mill';

SELECT @DeltaCrossingMillID2 = MillID
FROM dbo.Mill
WHERE MillName = N'Delta Crossing Mill';

SELECT @SouthernRidgeMillID2 = MillID
FROM dbo.Mill
WHERE MillName = N'Southern Ridge Mill';

SELECT @PPW_ID2 = ProductTypeID
FROM dbo.ProductType
WHERE ProductCode = 'PPW';

SELECT @HPW_ID2 = ProductTypeID
FROM dbo.ProductType
WHERE ProductCode = 'HPW';

SELECT @CNS_ID2 = ProductTypeID
FROM dbo.ProductType
WHERE ProductCode = 'CNS';

SELECT @PST_ID2 = ProductTypeID
FROM dbo.ProductType
WHERE ProductCode = 'PST';


/* =========================================================
   Contract / Mill Routes
   ========================================================= */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.ContractMillRoute
    WHERE ContractID = @CNT2001_ID
      AND MillID = @RiverCityMillID2
)
BEGIN
    INSERT INTO dbo.ContractMillRoute
    (
        ContractID,
        MillID,
        Miles,
        HaulRate
    )
    VALUES
    (
        @CNT2001_ID,
        @RiverCityMillID2,
        42.50,
        8.2500
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.ContractMillRoute
    WHERE ContractID = @CNT2001_ID
      AND MillID = @PineValleyMillID2
)
BEGIN
    INSERT INTO dbo.ContractMillRoute
    (
        ContractID,
        MillID,
        Miles,
        HaulRate
    )
    VALUES
    (
        @CNT2001_ID,
        @PineValleyMillID2,
        61.00,
        9.5000
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.ContractMillRoute
    WHERE ContractID = @CNT2002_ID
      AND MillID = @SouthernRidgeMillID2
)
BEGIN
    INSERT INTO dbo.ContractMillRoute
    (
        ContractID,
        MillID,
        Miles,
        HaulRate
    )
    VALUES
    (
        @CNT2002_ID,
        @SouthernRidgeMillID2,
        35.75,
        7.7500
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.ContractMillRoute
    WHERE ContractID = @CNT2003_ID
      AND MillID = @DeltaCrossingMillID2
)
BEGIN
    INSERT INTO dbo.ContractMillRoute
    (
        ContractID,
        MillID,
        Miles,
        HaulRate
    )
    VALUES
    (
        @CNT2003_ID,
        @DeltaCrossingMillID2,
        78.25,
        11.2500
    );
END;


/* =========================================================
   Contract / Product Rates
   ========================================================= */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.ContractProductRate
    WHERE ContractID = @CNT2001_ID
      AND ProductTypeID = @PPW_ID2
)
BEGIN
    INSERT INTO dbo.ContractProductRate
    (
        ContractID,
        ProductTypeID,
        CutLoadRate
    )
    VALUES
    (
        @CNT2001_ID,
        @PPW_ID2,
        7.5000
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.ContractProductRate
    WHERE ContractID = @CNT2001_ID
      AND ProductTypeID = @CNS_ID2
)
BEGIN
    INSERT INTO dbo.ContractProductRate
    (
        ContractID,
        ProductTypeID,
        CutLoadRate
    )
    VALUES
    (
        @CNT2001_ID,
        @CNS_ID2,
        9.2500
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.ContractProductRate
    WHERE ContractID = @CNT2001_ID
      AND ProductTypeID = @PST_ID2
)
BEGIN
    INSERT INTO dbo.ContractProductRate
    (
        ContractID,
        ProductTypeID,
        CutLoadRate
    )
    VALUES
    (
        @CNT2001_ID,
        @PST_ID2,
        12.0000
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.ContractProductRate
    WHERE ContractID = @CNT2002_ID
      AND ProductTypeID = @PPW_ID2
)
BEGIN
    INSERT INTO dbo.ContractProductRate
    (
        ContractID,
        ProductTypeID,
        CutLoadRate
    )
    VALUES
    (
        @CNT2002_ID,
        @PPW_ID2,
        7.7500
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.ContractProductRate
    WHERE ContractID = @CNT2002_ID
      AND ProductTypeID = @CNS_ID2
)
BEGIN
    INSERT INTO dbo.ContractProductRate
    (
        ContractID,
        ProductTypeID,
        CutLoadRate
    )
    VALUES
    (
        @CNT2002_ID,
        @CNS_ID2,
        9.5000
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.ContractProductRate
    WHERE ContractID = @CNT2003_ID
      AND ProductTypeID = @HPW_ID2
)
BEGIN
    INSERT INTO dbo.ContractProductRate
    (
        ContractID,
        ProductTypeID,
        CutLoadRate
    )
    VALUES
    (
        @CNT2003_ID,
        @HPW_ID2,
        8.5000
    );
END;
GO