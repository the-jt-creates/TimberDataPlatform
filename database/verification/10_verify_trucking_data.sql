SELECT 'TruckingCompany' AS TableName, COUNT(*) AS RecordCount
FROM dbo.TruckingCompany

UNION ALL

SELECT 'Driver', COUNT(*)
FROM dbo.Driver

UNION ALL

SELECT 'TimberCompanyTruckingCompany', COUNT(*)
FROM dbo.TimberCompanyTruckingCompany;

SELECT
    tc.CompanyName AS TimberCompany,
    tr.CompanyName AS TruckingCompany
FROM dbo.TimberCompany AS tc
INNER JOIN dbo.TimberCompanyTruckingCompany AS tctc
    ON tc.TimberCompanyID = tctc.TimberCompanyID
INNER JOIN dbo.TruckingCompany AS tr
    ON tctc.TruckingCompanyID = tr.TruckingCompanyID
ORDER BY
    tc.CompanyName,
    tr.CompanyName;

    SELECT
    tkc.CompanyName AS TruckingCompany,
	tc.CompanyName AS TimberCompany

FROM dbo.TruckingCompany AS tkc
INNER JOIN dbo.TimberCompanyTruckingCompany AS tctc
	ON tkc.TruckingCompanyID = tctc.TruckingCompanyID
INNER JOIN dbo.TimberCompany AS tc
	ON tctc.TimberCompanyID = tc.TimberCompanyID
ORDER BY
tkc.CompanyName,
tc.CompanyName;