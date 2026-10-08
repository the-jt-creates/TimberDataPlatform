/*
Project: Timber Data Platform
Script: 13_verify_contract_data.sql

Purpose:
Verify synthetic tract, contract, and compartment data and relationships.

Expected Result:
- 4 Tracts
- 5 Contracts
- 5 Compartments
- One Tract has multiple Contracts over time.
- One Tract has multiple Compartments.

Safety / Impact:
- Read-only verification.
- Does not insert, update, or delete data.

Created: 2026-08-24
*/

USE TimberDataPlatform;
GO


/* Verify expected row counts */

SELECT 'Tract' AS TableName, COUNT(*) AS RecordCount
FROM dbo.Tract

UNION ALL

SELECT 'Contract', COUNT(*)
FROM dbo.Contract

UNION ALL

SELECT 'Compartment', COUNT(*)
FROM dbo.Compartment;
GO

/* Verify Contract -> TimberCompany -> Tract relationships */

SELECT
    c.ContractNumber,
    tc.CompanyName AS TimberCompany,
    t.TractName,
    c.StartDate,
    c.ExpirationDate,
    c.Status
FROM dbo.Contract AS c
INNER JOIN dbo.TimberCompany AS tc
    ON c.TimberCompanyID = tc.TimberCompanyID
INNER JOIN dbo.Tract AS t
    ON c.TractID = t.TractID
ORDER BY
    t.TractName,
    c.StartDate;

    /* Verify Tract -> Compartment relationships */

SELECT
    t.TractName,
    c.CompartmentCode
FROM dbo.Tract AS t
INNER JOIN dbo.Compartment AS c
    ON t.TractID = c.TractID
ORDER BY
    t.TractName,
    c.CompartmentCode;