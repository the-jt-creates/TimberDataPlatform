/*
Project: Timber Data Platform
Script: 05_create_foundation_tables.sql

Purpose:
Create the first foundational tables for the organizational hierarchy:
CorporateCompany, Region, and TimberCompany.

Dependencies:
- TimberDataPlatform database must already exist.

Expected Result:
- Three tables exist in dbo:
  CorporateCompany
  Region
  TimberCompany
- Region references CorporateCompany.
- TimberCompany references Region.
- Script can be rerun safely without attempting to recreate existing tables.

Safety / Impact:
- Schema creation only.
- Does not insert, update, or delete business data.

Created: 2026-08-10
*/

USE TimberDataPlatform;
GO

IF OBJECT_ID('dbo.CorporateCompany', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.CorporateCompany
    (
        CorporateCompanyID INT IDENTITY(1,1) NOT NULL,
        CompanyName NVARCHAR(100) NOT NULL,
        CompanyCode VARCHAR(20) NOT NULL,
        ActiveFlag BIT NOT NULL
            CONSTRAINT DF_CorporateCompany_ActiveFlag DEFAULT (1),

        CONSTRAINT PK_CorporateCompany
            PRIMARY KEY (CorporateCompanyID),

        CONSTRAINT UQ_CorporateCompany_CompanyCode
            UNIQUE (CompanyCode)
    );
END;
GO

IF OBJECT_ID('dbo.Region', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Region
    (
        RegionID INT IDENTITY(1,1) NOT NULL,
        CorporateCompanyID INT NOT NULL,
        RegionName NVARCHAR(100) NOT NULL,
        RegionCode VARCHAR(20) NOT NULL,
        ActiveFlag BIT NOT NULL
            CONSTRAINT DF_Region_ActiveFlag DEFAULT (1),

        CONSTRAINT PK_Region
            PRIMARY KEY (RegionID),

        CONSTRAINT UQ_Region_RegionCode
            UNIQUE (RegionCode),

        CONSTRAINT FK_Region_CorporateCompany
            FOREIGN KEY (CorporateCompanyID)
            REFERENCES dbo.CorporateCompany (CorporateCompanyID)
    );
END;
GO

IF OBJECT_ID('dbo.TimberCompany', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.TimberCompany
    (
        TimberCompanyID INT IDENTITY(1,1) NOT NULL,
        RegionID INT NOT NULL,
        CompanyName NVARCHAR(100) NOT NULL,
        CompanyCode VARCHAR(20) NOT NULL,
        ActiveFlag BIT NOT NULL
            CONSTRAINT DF_TimberCompany_ActiveFlag DEFAULT (1),

        CONSTRAINT PK_TimberCompany
            PRIMARY KEY (TimberCompanyID),

        CONSTRAINT UQ_TimberCompany_CompanyCode
            UNIQUE (CompanyCode),

        CONSTRAINT FK_TimberCompany_Region
            FOREIGN KEY (RegionID)
            REFERENCES dbo.Region (RegionID)
    );
END;
GO