/*
Project: Timber Data Platform
Script: 12_seed_contract_data.sql

Purpose:
Insert synthetic tract, contract, and compartment data.

Dependencies:
- TimberDataPlatform database must exist.
- dbo.TimberCompany must already contain foundation seed data.
- 11_create_contract_tables.sql must have been run successfully.

Expected Result:
- 4 tracts
- 5 contracts
- 5 compartments
- One tract has two contracts over time.
- One tract has two compartments.

Safety / Impact:
- Inserts synthetic portfolio data only.
- No real company names, landowner names, or private operational data.

Created: 2026-08-24
*/

USE TimberDataPlatform;
GO


/* =========================================================
   Tracts
   ========================================================= */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Tract
    WHERE TractName = N'North Creek Tract'
)
BEGIN
    INSERT INTO dbo.Tract
    (
        TractName,
        City,
        StateCode
    )
    VALUES
    (
        N'North Creek Tract',
        N'Riverton',
        'MS'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Tract
    WHERE TractName = N'Long Pine Tract'
)
BEGIN
    INSERT INTO dbo.Tract
    (
        TractName,
        City,
        StateCode
    )
    VALUES
    (
        N'Long Pine Tract',
        N'Clearwater',
        'MS'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Tract
    WHERE TractName = N'River Bend Tract'
)
BEGIN
    INSERT INTO dbo.Tract
    (
        TractName,
        City,
        StateCode
    )
    VALUES
    (
        N'River Bend Tract',
        N'Westhaven',
        'MS'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Tract
    WHERE TractName = N'Cypress Ridge Tract'
)
BEGIN
    INSERT INTO dbo.Tract
    (
        TractName,
        City,
        StateCode
    )
    VALUES
    (
        N'Cypress Ridge Tract',
        N'Lakeview',
        'MS'
    );
END;
GO


/* =========================================================
   Look up Tract IDs
   ========================================================= */

DECLARE @NorthCreekTractID INT;
DECLARE @LongPineTractID INT;
DECLARE @RiverBendTractID INT;
DECLARE @CypressRidgeTractID INT;

SELECT @NorthCreekTractID = TractID
FROM dbo.Tract
WHERE TractName = N'North Creek Tract';

SELECT @LongPineTractID = TractID
FROM dbo.Tract
WHERE TractName = N'Long Pine Tract';

SELECT @RiverBendTractID = TractID
FROM dbo.Tract
WHERE TractName = N'River Bend Tract';

SELECT @CypressRidgeTractID = TractID
FROM dbo.Tract
WHERE TractName = N'Cypress Ridge Tract';


/* =========================================================
   Look up TimberCompany IDs
   ========================================================= */

DECLARE @PRT_ID INT;
DECLARE @BFT_ID INT;
DECLARE @SCT_ID INT;
DECLARE @DRT_ID INT;

SELECT @PRT_ID = TimberCompanyID
FROM dbo.TimberCompany
WHERE CompanyCode = 'PRT';

SELECT @BFT_ID = TimberCompanyID
FROM dbo.TimberCompany
WHERE CompanyCode = 'BFT';

SELECT @SCT_ID = TimberCompanyID
FROM dbo.TimberCompany
WHERE CompanyCode = 'SCT';

SELECT @DRT_ID = TimberCompanyID
FROM dbo.TimberCompany
WHERE CompanyCode = 'DRT';


/* =========================================================
   Contracts
   ========================================================= */

/* Historical contract on North Creek Tract */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Contract
    WHERE ContractNumber = 'CNT-1001'
)
BEGIN
    INSERT INTO dbo.Contract
    (
        TimberCompanyID,
        TractID,
        ContractNumber,
        StartDate,
        ExpirationDate,
        Status
    )
    VALUES
    (
        @PRT_ID,
        @NorthCreekTractID,
        'CNT-1001',
        '2024-01-01',
        '2024-12-31',
        'Completed'
    );
END;


/* Newer contract on the same tract */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Contract
    WHERE ContractNumber = 'CNT-2001'
)
BEGIN
    INSERT INTO dbo.Contract
    (
        TimberCompanyID,
        TractID,
        ContractNumber,
        StartDate,
        ExpirationDate,
        Status
    )
    VALUES
    (
        @BFT_ID,
        @NorthCreekTractID,
        'CNT-2001',
        '2026-01-01',
        '2026-12-31',
        'Active'
    );
END;


IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Contract
    WHERE ContractNumber = 'CNT-2002'
)
BEGIN
    INSERT INTO dbo.Contract
    (
        TimberCompanyID,
        TractID,
        ContractNumber,
        StartDate,
        ExpirationDate,
        Status
    )
    VALUES
    (
        @SCT_ID,
        @LongPineTractID,
        'CNT-2002',
        '2026-02-01',
        '2026-11-30',
        'Active'
    );
END;


IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Contract
    WHERE ContractNumber = 'CNT-2003'
)
BEGIN
    INSERT INTO dbo.Contract
    (
        TimberCompanyID,
        TractID,
        ContractNumber,
        StartDate,
        ExpirationDate,
        Status
    )
    VALUES
    (
        @DRT_ID,
        @RiverBendTractID,
        'CNT-2003',
        '2026-03-15',
        '2027-03-14',
        'Active'
    );
END;


IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Contract
    WHERE ContractNumber = 'CNT-2004'
)
BEGIN
    INSERT INTO dbo.Contract
    (
        TimberCompanyID,
        TractID,
        ContractNumber,
        StartDate,
        ExpirationDate,
        Status
    )
    VALUES
    (
        @PRT_ID,
        @CypressRidgeTractID,
        'CNT-2004',
        '2026-05-01',
        '2027-04-30',
        'Active'
    );
END;
GO


/* =========================================================
   Look up Tract IDs again for this batch
   ========================================================= */

DECLARE @NorthCreekTractID2 INT;
DECLARE @LongPineTractID2 INT;
DECLARE @RiverBendTractID2 INT;
DECLARE @CypressRidgeTractID2 INT;

SELECT @NorthCreekTractID2 = TractID
FROM dbo.Tract
WHERE TractName = N'North Creek Tract';

SELECT @LongPineTractID2 = TractID
FROM dbo.Tract
WHERE TractName = N'Long Pine Tract';

SELECT @RiverBendTractID2 = TractID
FROM dbo.Tract
WHERE TractName = N'River Bend Tract';

SELECT @CypressRidgeTractID2 = TractID
FROM dbo.Tract
WHERE TractName = N'Cypress Ridge Tract';


/* =========================================================
   Compartments
   ========================================================= */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Compartment
    WHERE TractID = @NorthCreekTractID2
      AND CompartmentCode = 'C1'
)
BEGIN
    INSERT INTO dbo.Compartment
    (
        TractID,
        CompartmentCode
    )
    VALUES
    (
        @NorthCreekTractID2,
        'C1'
    );
END;


IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Compartment
    WHERE TractID = @LongPineTractID2
      AND CompartmentCode = 'C1'
)
BEGIN
    INSERT INTO dbo.Compartment
    (
        TractID,
        CompartmentCode
    )
    VALUES
    (
        @LongPineTractID2,
        'C1'
    );
END;


IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Compartment
    WHERE TractID = @RiverBendTractID2
      AND CompartmentCode = 'C1'
)
BEGIN
    INSERT INTO dbo.Compartment
    (
        TractID,
        CompartmentCode
    )
    VALUES
    (
        @RiverBendTractID2,
        'C1'
    );
END;


IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Compartment
    WHERE TractID = @CypressRidgeTractID2
      AND CompartmentCode = 'C1'
)
BEGIN
    INSERT INTO dbo.Compartment
    (
        TractID,
        CompartmentCode
    )
    VALUES
    (
        @CypressRidgeTractID2,
        'C1'
    );
END;


IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Compartment
    WHERE TractID = @CypressRidgeTractID2
      AND CompartmentCode = 'C2'
)
BEGIN
    INSERT INTO dbo.Compartment
    (
        TractID,
        CompartmentCode
    )
    VALUES
    (
        @CypressRidgeTractID2,
        'C2'
    );
END;
GO