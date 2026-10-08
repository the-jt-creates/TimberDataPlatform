/*
Project: Timber Data Platform
Script: 17_create_operational_tables.sql

Purpose:
Create the operational core tables:
- Load
- MillTicket
- WeeklyReconciliation

Dependencies:
- TimberDataPlatform database must exist.
- Contract, Driver, Mill, ProductType, and Compartment tables must exist.

Expected Result:
- Load stores internally expected operational load data.
- MillTicket stores mill-confirmed delivery data.
- WeeklyReconciliation stores contract-level weekly reconciliation totals.

Safety / Impact:
- Schema creation only.
- Does not insert, update, or delete business data.

Created: 2026-08-26
*/

USE TimberDataPlatform;
GO
IF OBJECT_ID('dbo.Load', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Load
    (
        LoadID INT IDENTITY(1,1) NOT NULL,
        ContractID INT NOT NULL,
        DriverID INT NOT NULL,
        MillID INT NOT NULL,
        ProductTypeID INT NOT NULL,
        CompartmentID INT NULL,
        LoadTagID CHAR(4) NOT NULL,
        LoadDate DATE NOT NULL,
        LoadTime TIME NULL,

        CONSTRAINT PK_Load
            PRIMARY KEY (LoadID),

        CONSTRAINT UQ_Load_Contract_LoadTag
            UNIQUE (ContractID, LoadTagID),

        CONSTRAINT FK_Load_Contract
            FOREIGN KEY (ContractID)
            REFERENCES dbo.Contract (ContractID),

        CONSTRAINT FK_Load_Driver
            FOREIGN KEY (DriverID)
            REFERENCES dbo.Driver (DriverID),

        CONSTRAINT FK_Load_Mill
            FOREIGN KEY (MillID)
            REFERENCES dbo.Mill (MillID),

        CONSTRAINT FK_Load_ProductType
            FOREIGN KEY (ProductTypeID)
            REFERENCES dbo.ProductType (ProductTypeID),

        CONSTRAINT FK_Load_Compartment
            FOREIGN KEY (CompartmentID)
            REFERENCES dbo.Compartment (CompartmentID)
    );
END;
GO

IF OBJECT_ID('dbo.MillTicket', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.MillTicket
    (
        MillTicketID INT IDENTITY(1,1) NOT NULL,
        LoadID INT NULL,
        MillID INT NOT NULL,
        DriverID INT NOT NULL,
        ProductTypeID INT NOT NULL,
        ScaleTicketNumber VARCHAR(10) NOT NULL,
        NetTons DECIMAL(10,2) NOT NULL,
        DeliveryDate DATE NOT NULL,
        ArrivalTime TIME NULL,

        CONSTRAINT PK_MillTicket
            PRIMARY KEY (MillTicketID),

        CONSTRAINT UQ_MillTicket_Mill_ScaleTicket
            UNIQUE (MillID, ScaleTicketNumber),

        CONSTRAINT UQ_MillTicket_Load
            UNIQUE (LoadID),

        CONSTRAINT FK_MillTicket_Load
            FOREIGN KEY (LoadID)
            REFERENCES dbo.Load (LoadID),

        CONSTRAINT FK_MillTicket_Mill
            FOREIGN KEY (MillID)
            REFERENCES dbo.Mill (MillID),

        CONSTRAINT FK_MillTicket_Driver
            FOREIGN KEY (DriverID)
            REFERENCES dbo.Driver (DriverID),

        CONSTRAINT FK_MillTicket_ProductType
            FOREIGN KEY (ProductTypeID)
            REFERENCES dbo.ProductType (ProductTypeID)
    );
END;
GO

IF OBJECT_ID('dbo.WeeklyReconciliation', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.WeeklyReconciliation
    (
        ReconciliationID INT IDENTITY(1,1) NOT NULL,
        ContractID INT NOT NULL,
        SettleWeekEndingDate DATE NOT NULL,

        InternalTotalTons DECIMAL(12,2) NOT NULL,
        SettlementTotalTons DECIMAL(12,2) NOT NULL,

        ExpectedGrossPay DECIMAL(12,2) NOT NULL,
        SettlementGrossPay DECIMAL(12,2) NOT NULL,

        LoggerCullTons DECIMAL(10,2) NOT NULL
            CONSTRAINT DF_WeeklyReconciliation_LoggerCullTons DEFAULT (0),

        TractCullTons DECIMAL(10,2) NOT NULL
            CONSTRAINT DF_WeeklyReconciliation_TractCullTons DEFAULT (0),

        OverweightTons DECIMAL(10,2) NOT NULL
            CONSTRAINT DF_WeeklyReconciliation_OverweightTons DEFAULT (0),

        PenaltyAmount DECIMAL(12,2) NOT NULL
            CONSTRAINT DF_WeeklyReconciliation_PenaltyAmount DEFAULT (0),

        BonusAmount DECIMAL(12,2) NOT NULL
            CONSTRAINT DF_WeeklyReconciliation_BonusAmount DEFAULT (0),

        SettlementNetPay DECIMAL(12,2) NOT NULL,
        Notes NVARCHAR(500) NULL,

        CONSTRAINT PK_WeeklyReconciliation
            PRIMARY KEY (ReconciliationID),

        CONSTRAINT UQ_WeeklyReconciliation_Contract_Week
            UNIQUE (ContractID, SettleWeekEndingDate),

        CONSTRAINT FK_WeeklyReconciliation_Contract
            FOREIGN KEY (ContractID)
            REFERENCES dbo.Contract (ContractID)
    );
END;
GO