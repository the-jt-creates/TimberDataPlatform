/*
Project: Timber Data Platform
Script: 11_create_contract_tables.sql

Purpose:
Create the contract/land foundation tables:
- Tract
- Contract
- Compartment

Dependencies:
- TimberDataPlatform database must exist.
- dbo.TimberCompany must already exist.

Expected Result:
- dbo.Tract
- dbo.Contract
- dbo.Compartment
- Contract references TimberCompany and Tract.
- Compartment references Tract.

Safety / Impact:
- Schema creation only.
- Does not insert, update, or delete business data.

Created: 2026-08-24
*/

USE TimberDataPlatform;
GO

IF OBJECT_ID('dbo.Tract', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Tract
    (
        TractID INT IDENTITY(1,1) NOT NULL,
        TractName NVARCHAR(100) NOT NULL,
        City NVARCHAR(100) NULL,
        StateCode CHAR(2) NULL,
        ActiveFlag BIT NOT NULL
            CONSTRAINT DF_Tract_ActiveFlag DEFAULT (1),

        CONSTRAINT PK_Tract
            PRIMARY KEY (TractID)
    );
END;
GO

IF OBJECT_ID('dbo.Contract', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Contract
    (
        ContractID INT IDENTITY(1,1) NOT NULL,
        TimberCompanyID INT NOT NULL,
        TractID INT NOT NULL,
        ContractNumber VARCHAR(30) NOT NULL,
        StartDate DATE NOT NULL,
        ExpirationDate DATE NOT NULL,
        Status VARCHAR(20) NOT NULL,

        CONSTRAINT PK_Contract
            PRIMARY KEY (ContractID),

        CONSTRAINT UQ_Contract_ContractNumber
            UNIQUE (ContractNumber),

        CONSTRAINT FK_Contract_TimberCompany
            FOREIGN KEY (TimberCompanyID)
            REFERENCES dbo.TimberCompany (TimberCompanyID),

        CONSTRAINT FK_Contract_Tract
            FOREIGN KEY (TractID)
            REFERENCES dbo.Tract (TractID)
    );
END;
GO

IF OBJECT_ID('dbo.Compartment', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Compartment
    (
        CompartmentID INT IDENTITY(1,1) NOT NULL,
        TractID INT NOT NULL,
        CompartmentCode VARCHAR(30) NOT NULL,
        ActiveFlag BIT NOT NULL
            CONSTRAINT DF_Compartment_ActiveFlag DEFAULT (1),

        CONSTRAINT PK_Compartment
            PRIMARY KEY (CompartmentID),

        CONSTRAINT UQ_Compartment_Tract_CompartmentCode
            UNIQUE (TractID, CompartmentCode),

        CONSTRAINT FK_Compartment_Tract
            FOREIGN KEY (TractID)
            REFERENCES dbo.Tract (TractID)
    );
END;
GO