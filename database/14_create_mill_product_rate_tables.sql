/*
Project: Timber Data Platform
Script: 14_create_mill_product_rate_tables.sql

Purpose:
Create the mill, product, and contract-rate tables:
- MillCompany
- Mill
- ProductType
- MillProductType
- ContractMillRoute
- ContractProductRate

Dependencies:
- TimberDataPlatform database must exist.
- dbo.Contract must already exist.

Expected Result:
- MillCompany 1:M Mill
- Mill M:M ProductType through MillProductType
- Contract 1:M ContractMillRoute
- Mill 1:M ContractMillRoute
- Contract 1:M ContractProductRate
- ProductType 1:M ContractProductRate

Safety / Impact:
- Schema creation only.
- Does not insert, update, or delete business data.

Created: 2026-08-24
*/

USE TimberDataPlatform;
GO

IF OBJECT_ID('dbo.MillCompany', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.MillCompany
    (
        MillCompanyID INT IDENTITY(1,1) NOT NULL,
        CompanyName NVARCHAR(100) NOT NULL,
        CompanyCode VARCHAR(20) NOT NULL,
        ActiveFlag BIT NOT NULL
            CONSTRAINT DF_MillCompany_ActiveFlag DEFAULT (1),

        CONSTRAINT PK_MillCompany
            PRIMARY KEY (MillCompanyID),

        CONSTRAINT UQ_MillCompany_CompanyCode
            UNIQUE (CompanyCode)
    );
END;
GO

IF OBJECT_ID('dbo.Mill', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Mill
    (
        MillID INT IDENTITY(1,1) NOT NULL,
        MillCompanyID INT NOT NULL,
        MillName NVARCHAR(100) NOT NULL,
        City NVARCHAR(100) NULL,
        StateCode CHAR(2) NULL,
        ActiveFlag BIT NOT NULL
            CONSTRAINT DF_Mill_ActiveFlag DEFAULT (1),

        CONSTRAINT PK_Mill
            PRIMARY KEY (MillID),

        CONSTRAINT UQ_Mill_MillCompany_MillName
            UNIQUE (MillCompanyID, MillName),

        CONSTRAINT FK_Mill_MillCompany
            FOREIGN KEY (MillCompanyID)
            REFERENCES dbo.MillCompany (MillCompanyID)
    );
END;
GO

IF OBJECT_ID('dbo.ProductType', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ProductType
    (
        ProductTypeID INT IDENTITY(1,1) NOT NULL,
        ProductCode VARCHAR(20) NOT NULL,
        ProductTypeName NVARCHAR(100) NOT NULL,
        ActiveFlag BIT NOT NULL
            CONSTRAINT DF_ProductType_ActiveFlag DEFAULT (1),

        CONSTRAINT PK_ProductType
            PRIMARY KEY (ProductTypeID),

        CONSTRAINT UQ_ProductType_ProductCode
            UNIQUE (ProductCode)
    );
END;
GO

IF OBJECT_ID('dbo.MillProductType', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.MillProductType
    (
        MillID INT NOT NULL,
        ProductTypeID INT NOT NULL,

        CONSTRAINT PK_MillProductType
            PRIMARY KEY
            (
                MillID,
                ProductTypeID
            ),

        CONSTRAINT FK_MillProductType_Mill
            FOREIGN KEY (MillID)
            REFERENCES dbo.Mill (MillID),

        CONSTRAINT FK_MillProductType_ProductType
            FOREIGN KEY (ProductTypeID)
            REFERENCES dbo.ProductType (ProductTypeID)
    );
END;
GO

IF OBJECT_ID('dbo.ContractMillRoute', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ContractMillRoute
    (
        ContractMillRouteID INT IDENTITY(1,1) NOT NULL,
        ContractID INT NOT NULL,
        MillID INT NOT NULL,
        Miles DECIMAL(6,2) NOT NULL,
        HaulRate DECIMAL(10,4) NOT NULL,

        CONSTRAINT PK_ContractMillRoute
            PRIMARY KEY (ContractMillRouteID),

        CONSTRAINT UQ_ContractMillRoute_Contract_Mill
            UNIQUE (ContractID, MillID),

        CONSTRAINT FK_ContractMillRoute_Contract
            FOREIGN KEY (ContractID)
            REFERENCES dbo.Contract (ContractID),

        CONSTRAINT FK_ContractMillRoute_Mill
            FOREIGN KEY (MillID)
            REFERENCES dbo.Mill (MillID)
    );
END;
GO

IF OBJECT_ID('dbo.ContractProductRate', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ContractProductRate
    (
        ContractProductRateID INT IDENTITY(1,1) NOT NULL,
        ContractID INT NOT NULL,
        ProductTypeID INT NOT NULL,
        CutLoadRate DECIMAL(10,4) NOT NULL,

        CONSTRAINT PK_ContractProductRate
            PRIMARY KEY (ContractProductRateID),

        CONSTRAINT UQ_ContractProductRate_Contract_Product
            UNIQUE (ContractID, ProductTypeID),

        CONSTRAINT FK_ContractProductRate_Contract
            FOREIGN KEY (ContractID)
            REFERENCES dbo.Contract (ContractID),

        CONSTRAINT FK_ContractProductRate_ProductType
            FOREIGN KEY (ProductTypeID)
            REFERENCES dbo.ProductType (ProductTypeID)
    );
END;
GO