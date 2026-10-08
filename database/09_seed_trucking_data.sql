/*
Project: Timber Data Platform
Script: 09_seed_trucking_data.sql

Purpose:
Insert synthetic trucking companies, drivers, and timber-company /
trucking-company relationships.

Dependencies:
- TimberDataPlatform database must exist.
- dbo.TimberCompany must already contain foundation seed data.
- 08_create_trucking_tables.sql must have been run successfully.

Expected Result:
- 4 trucking companies
- 8 drivers
- Multiple TimberCompany-to-TruckingCompany relationships
- At least one trucking company linked to multiple timber companies
- At least one timber company linked to multiple trucking companies

Safety / Impact:
- Inserts synthetic portfolio data only.
- No real company names or private operational data.

Created: 2026-08-15
*/

USE TimberDataPlatform;
GO


/* =========================================================
   Trucking Companies
   ========================================================= */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TruckingCompany
    WHERE CompanyCode = 'PRH'
)
BEGIN
    INSERT INTO dbo.TruckingCompany
    (
        CompanyName,
        CompanyCode
    )
    VALUES
    (
        N'Pine Ridge Hauling',
        'PRH'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TruckingCompany
    WHERE CompanyCode = 'DFS'
)
BEGIN
    INSERT INTO dbo.TruckingCompany
    (
        CompanyName,
        CompanyCode
    )
    VALUES
    (
        N'Delta Freight Services',
        'DFS'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TruckingCompany
    WHERE CompanyCode = 'LHT'
)
BEGIN
    INSERT INTO dbo.TruckingCompany
    (
        CompanyName,
        CompanyCode
    )
    VALUES
    (
        N'Longhaul Timber Transport',
        'LHT'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TruckingCompany
    WHERE CompanyCode = 'BCH'
)
BEGIN
    INSERT INTO dbo.TruckingCompany
    (
        CompanyName,
        CompanyCode
    )
    VALUES
    (
        N'Bayou Creek Hauling',
        'BCH'
    );
END;
GO


/* =========================================================
   Look up TruckingCompany IDs
   ========================================================= */

DECLARE @PRH_ID INT;
DECLARE @DFS_ID INT;
DECLARE @LHT_ID INT;
DECLARE @BCH_ID INT;

SELECT @PRH_ID = TruckingCompanyID
FROM dbo.TruckingCompany
WHERE CompanyCode = 'PRH';

SELECT @DFS_ID = TruckingCompanyID
FROM dbo.TruckingCompany
WHERE CompanyCode = 'DFS';

SELECT @LHT_ID = TruckingCompanyID
FROM dbo.TruckingCompany
WHERE CompanyCode = 'LHT';

SELECT @BCH_ID = TruckingCompanyID
FROM dbo.TruckingCompany
WHERE CompanyCode = 'BCH';


/* =========================================================
   Drivers
   ========================================================= */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Driver
    WHERE TruckingCompanyID = @PRH_ID
      AND DriverCode = 'D001'
)
BEGIN
    INSERT INTO dbo.Driver
    (
        TruckingCompanyID,
        DriverCode,
        FirstName,
        LastName
    )
    VALUES
    (
        @PRH_ID,
        'D001',
        N'Ethan',
        N'Cole'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Driver
    WHERE TruckingCompanyID = @PRH_ID
      AND DriverCode = 'D002'
)
BEGIN
    INSERT INTO dbo.Driver
    (
        TruckingCompanyID,
        DriverCode,
        FirstName,
        LastName
    )
    VALUES
    (
        @PRH_ID,
        'D002',
        N'Marcus',
        N'Reed'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Driver
    WHERE TruckingCompanyID = @DFS_ID
      AND DriverCode = 'D001'
)
BEGIN
    INSERT INTO dbo.Driver
    (
        TruckingCompanyID,
        DriverCode,
        FirstName,
        LastName
    )
    VALUES
    (
        @DFS_ID,
        'D001',
        N'Caleb',
        N'Brooks'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Driver
    WHERE TruckingCompanyID = @DFS_ID
      AND DriverCode = 'D002'
)
BEGIN
    INSERT INTO dbo.Driver
    (
        TruckingCompanyID,
        DriverCode,
        FirstName,
        LastName
    )
    VALUES
    (
        @DFS_ID,
        'D002',
        N'Andre',
        N'Lewis'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Driver
    WHERE TruckingCompanyID = @LHT_ID
      AND DriverCode = 'D001'
)
BEGIN
    INSERT INTO dbo.Driver
    (
        TruckingCompanyID,
        DriverCode,
        FirstName,
        LastName
    )
    VALUES
    (
        @LHT_ID,
        'D001',
        N'Noah',
        N'Bennett'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Driver
    WHERE TruckingCompanyID = @LHT_ID
      AND DriverCode = 'D002'
)
BEGIN
    INSERT INTO dbo.Driver
    (
        TruckingCompanyID,
        DriverCode,
        FirstName,
        LastName
    )
    VALUES
    (
        @LHT_ID,
        'D002',
        N'Jordan',
        N'Price'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Driver
    WHERE TruckingCompanyID = @BCH_ID
      AND DriverCode = 'D001'
)
BEGIN
    INSERT INTO dbo.Driver
    (
        TruckingCompanyID,
        DriverCode,
        FirstName,
        LastName
    )
    VALUES
    (
        @BCH_ID,
        'D001',
        N'Lucas',
        N'Grant'
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.Driver
    WHERE TruckingCompanyID = @BCH_ID
      AND DriverCode = 'D002'
)
BEGIN
    INSERT INTO dbo.Driver
    (
        TruckingCompanyID,
        DriverCode,
        FirstName,
        LastName
    )
    VALUES
    (
        @BCH_ID,
        'D002',
        N'Mason',
        N'Harper'
    );
END;
GO


/* =========================================================
   Look up TimberCompany IDs
   ========================================================= */

DECLARE @PRT_ID INT;
DECLARE @BFT_ID INT;
DECLARE @SCT_ID INT;
DECLARE @LLT_ID INT;
DECLARE @DRT_ID INT;
DECLARE @CWT_ID INT;

SELECT @PRT_ID = TimberCompanyID
FROM dbo.TimberCompany
WHERE CompanyCode = 'PRT';

SELECT @BFT_ID = TimberCompanyID
FROM dbo.TimberCompany
WHERE CompanyCode = 'BFT';

SELECT @SCT_ID = TimberCompanyID
FROM dbo.TimberCompany
WHERE CompanyCode = 'SCT';

SELECT @LLT_ID = TimberCompanyID
FROM dbo.TimberCompany
WHERE CompanyCode = 'LLT';

SELECT @DRT_ID = TimberCompanyID
FROM dbo.TimberCompany
WHERE CompanyCode = 'DRT';

SELECT @CWT_ID = TimberCompanyID
FROM dbo.TimberCompany
WHERE CompanyCode = 'CWT';


/* Look up TruckingCompany IDs again in this batch */

DECLARE @PRH_ID2 INT;
DECLARE @DFS_ID2 INT;
DECLARE @LHT_ID2 INT;
DECLARE @BCH_ID2 INT;

SELECT @PRH_ID2 = TruckingCompanyID
FROM dbo.TruckingCompany
WHERE CompanyCode = 'PRH';

SELECT @DFS_ID2 = TruckingCompanyID
FROM dbo.TruckingCompany
WHERE CompanyCode = 'DFS';

SELECT @LHT_ID2 = TruckingCompanyID
FROM dbo.TruckingCompany
WHERE CompanyCode = 'LHT';

SELECT @BCH_ID2 = TruckingCompanyID
FROM dbo.TruckingCompany
WHERE CompanyCode = 'BCH';


/* =========================================================
   TimberCompany / TruckingCompany relationships
   ========================================================= */

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TimberCompanyTruckingCompany
    WHERE TimberCompanyID = @PRT_ID
      AND TruckingCompanyID = @PRH_ID2
)
BEGIN
    INSERT INTO dbo.TimberCompanyTruckingCompany
    (
        TimberCompanyID,
        TruckingCompanyID
    )
    VALUES
    (
        @PRT_ID,
        @PRH_ID2
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TimberCompanyTruckingCompany
    WHERE TimberCompanyID = @PRT_ID
      AND TruckingCompanyID = @DFS_ID2
)
BEGIN
    INSERT INTO dbo.TimberCompanyTruckingCompany
    (
        TimberCompanyID,
        TruckingCompanyID
    )
    VALUES
    (
        @PRT_ID,
        @DFS_ID2
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TimberCompanyTruckingCompany
    WHERE TimberCompanyID = @BFT_ID
      AND TruckingCompanyID = @PRH_ID2
)
BEGIN
    INSERT INTO dbo.TimberCompanyTruckingCompany
    (
        TimberCompanyID,
        TruckingCompanyID
    )
    VALUES
    (
        @BFT_ID,
        @PRH_ID2
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TimberCompanyTruckingCompany
    WHERE TimberCompanyID = @SCT_ID
      AND TruckingCompanyID = @LHT_ID2
)
BEGIN
    INSERT INTO dbo.TimberCompanyTruckingCompany
    (
        TimberCompanyID,
        TruckingCompanyID
    )
    VALUES
    (
        @SCT_ID,
        @LHT_ID2
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TimberCompanyTruckingCompany
    WHERE TimberCompanyID = @LLT_ID
      AND TruckingCompanyID = @LHT_ID2
)
BEGIN
    INSERT INTO dbo.TimberCompanyTruckingCompany
    (
        TimberCompanyID,
        TruckingCompanyID
    )
    VALUES
    (
        @LLT_ID,
        @LHT_ID2
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TimberCompanyTruckingCompany
    WHERE TimberCompanyID = @LLT_ID
      AND TruckingCompanyID = @BCH_ID2
)
BEGIN
    INSERT INTO dbo.TimberCompanyTruckingCompany
    (
        TimberCompanyID,
        TruckingCompanyID
    )
    VALUES
    (
        @LLT_ID,
        @BCH_ID2
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TimberCompanyTruckingCompany
    WHERE TimberCompanyID = @DRT_ID
      AND TruckingCompanyID = @DFS_ID2
)
BEGIN
    INSERT INTO dbo.TimberCompanyTruckingCompany
    (
        TimberCompanyID,
        TruckingCompanyID
    )
    VALUES
    (
        @DRT_ID,
        @DFS_ID2
    );
END;

IF NOT EXISTS
(
    SELECT 1
    FROM dbo.TimberCompanyTruckingCompany
    WHERE TimberCompanyID = @CWT_ID
      AND TruckingCompanyID = @BCH_ID2
)
BEGIN
    INSERT INTO dbo.TimberCompanyTruckingCompany
    (
        TimberCompanyID,
        TruckingCompanyID
    )
    VALUES
    (
        @CWT_ID,
        @BCH_ID2
    );
END;
GO