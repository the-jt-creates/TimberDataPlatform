/*
Project: Timber Data Platform
Script: 08_create_trucking_tables.sql

Purpose:
Create the trucking-company, driver, and timber-company/trucking-company
relationship tables.

Dependencies:
- TimberDataPlatform database must exist.
- dbo.TimberCompany must already exist.

Expected Result:
- dbo.TruckingCompany
- dbo.Driver
- dbo.TimberCompanyTruckingCompany

Safety / Impact:
- Schema creation only.
- Does not insert, update, or delete business data.

Created: 2026-08-13
*/

USE TimberDataPlatform;
GO


/* =========================================================
   TruckingCompany
   ========================================================= */

IF OBJECT_ID('dbo.TruckingCompany', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.TruckingCompany
    (
        TruckingCompanyID INT IDENTITY(1,1) NOT NULL,
        CompanyName NVARCHAR(100) NOT NULL,
        CompanyCode VARCHAR(20) NOT NULL,
        ActiveFlag BIT NOT NULL
            CONSTRAINT DF_TruckingCompany_ActiveFlag DEFAULT (1),

        CONSTRAINT PK_TruckingCompany
            PRIMARY KEY (TruckingCompanyID),

        CONSTRAINT UQ_TruckingCompany_CompanyCode
            UNIQUE (CompanyCode)
    );
END;
GO


/* =========================================================
   Driver
   ========================================================= */

IF OBJECT_ID('dbo.Driver', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Driver
    (
        DriverID INT IDENTITY(1,1) NOT NULL,
        TruckingCompanyID INT NOT NULL,
        DriverCode VARCHAR(20) NOT NULL,
        FirstName NVARCHAR(50) NOT NULL,
        LastName NVARCHAR(50) NOT NULL,
        ActiveFlag BIT NOT NULL
            CONSTRAINT DF_Driver_ActiveFlag DEFAULT (1),

        CONSTRAINT PK_Driver
            PRIMARY KEY (DriverID),

        CONSTRAINT UQ_Driver_TruckingCompany_DriverCode
            UNIQUE (TruckingCompanyID, DriverCode),

        CONSTRAINT FK_Driver_TruckingCompany
            FOREIGN KEY (TruckingCompanyID)
            REFERENCES dbo.TruckingCompany (TruckingCompanyID)
    );
END;
GO


/* =========================================================
   TimberCompanyTruckingCompany
   Junction table: supports the many-to-many relationship
   between timber companies and trucking companies.
   ========================================================= */

IF OBJECT_ID('dbo.TimberCompanyTruckingCompany', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.TimberCompanyTruckingCompany
    (
        TimberCompanyID INT NOT NULL,
        TruckingCompanyID INT NOT NULL,

        CONSTRAINT PK_TimberCompanyTruckingCompany
            PRIMARY KEY
            (
                TimberCompanyID,
                TruckingCompanyID
            ),

        CONSTRAINT FK_TCTC_TimberCompany
            FOREIGN KEY (TimberCompanyID)
            REFERENCES dbo.TimberCompany (TimberCompanyID),

        CONSTRAINT FK_TCTC_TruckingCompany
            FOREIGN KEY (TruckingCompanyID)
            REFERENCES dbo.TruckingCompany (TruckingCompanyID)
    );
END;
GO