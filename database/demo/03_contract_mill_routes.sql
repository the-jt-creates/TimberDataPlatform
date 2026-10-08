/*
Project: TimberDataPlatform
Script: 03_contract_mill_routes.sql

Business Question:
Which mills are approved for each contract, and what are the associated
mileage and hauling rates?

Intended Grain:
One row per contract/mill route.

Purpose:
Demonstrate the approved mill routes for each contract, including the
route mileage and hauling rate associated with each contract/mill pair.

Tables Used:
- dbo.ContractMillRoute
- dbo.Contract
- dbo.Mill

Expected Result:
One row per contract/mill route showing:
- Contract number
- Mill name
- Miles
- Haul rate

QA Notes:
- Expected row count: 4 rows with the current synthetic seed data.
- Each row should represent one unique contract/mill route.
- Joining to dbo.Contract should preserve the route grain.
- Joining to dbo.Mill should also preserve the route grain.
- No unexpected NULL values should appear.

Safety:
Read-only query. Does not modify data.

Created:
2026-10-07
*/

SELECT
	c.ContractNumber AS ContractNumber,
	m.MillName AS MillName,
	cmr.Miles AS Miles,
	cmr.HaulRate AS HaulRate

FROM dbo.ContractMillRoute AS cmr
INNER JOIN dbo.Contract AS c
	ON cmr.ContractID = c.ContractID
INNER JOIN dbo.Mill AS m
	ON m.MillID = cmr.MillID
ORDER BY
ContractNumber;