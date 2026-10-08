/*
Project: TimberDataPlatform
Script: 01_organizational_hierarchy.sql

Business Question:
Which timber companies belong to each region and corporate company?

Intended Grain:
One row per timber company.

Purpose:
Demonstrate the organizational hierarchy by joining TimberCompany
to Region and CorporateCompany.

Tables Used:
- dbo.TimberCompany
- dbo.Region
- dbo.CorporateCompany

Expected Result:
One row per timber company showing:
- Timber company name
- Region name
- Corporate company name

QA Notes:
- Expected row count: 6 rows with the current synthetic seed data.
- Each timber company should appear once.
- No unexpected NULL values should appear.
- JOINs should preserve the intended grain.

Safety:
Read-only query. Does not modify data.

Created:
2026-10-06
*/

SELECT
	tc.CompanyName AS TimberCompanyName,
	r.RegionName,
	cc.CompanyName AS CorporateCompanyName
FROM dbo.TimberCompany AS tc
INNER JOIN dbo.Region AS r
	ON tc.RegionID = r.RegionID
INNER JOIN dbo.CorporateCompany AS cc
	ON r.CorporateCompanyID = cc.CorporateCompanyID
ORDER BY
TimberCompanyName;