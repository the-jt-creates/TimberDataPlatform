/*
Project: TimberDataPlatform
Script: 02_contract_tract_company.sql

Business Question:
Which contracts are associated with each tract and timber company?

Intended Grain:
One row per contract.

Purpose:
Demonstrate how each contract relates to its tract and responsible
timber company.

Tables Used:
- dbo.Contract
- dbo.Tract
- dbo.TimberCompany

Expected Result:
One row per contract showing:
- Contract number
- Tract name
- Timber company name

QA Notes:
- Expected row count: 5 rows with the current synthetic seed data.
- Each contract should appear once.
- Join to dbo.Tract should preserve the 5-row contract grain.
- Join to dbo.TimberCompany should also preserve the 5-row contract grain.
- No unexpected NULL values should appear.

Safety:
Read-only query. Does not modify data.

Created:
2026-10-07
*/

SELECT
    c.ContractNumber AS ContractNumber,
    t.TractName AS TractName,
    tc.CompanyName AS TimberCompanyName
FROM dbo.Contract AS c
INNER JOIN dbo.Tract AS t
    ON c.TractID = t.TractID
INNER JOIN dbo.TimberCompany AS tc
    ON c.TimberCompanyID = tc.TimberCompanyID
ORDER BY
    ContractNumber;