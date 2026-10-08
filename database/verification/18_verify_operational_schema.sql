/*
Project: Timber Data Platform
Script: 18_verify_operational_schema.sql

Purpose:
Verify the operational core tables exist and are currently empty
before creating the Version 1 schema baseline backup.

Dependencies:
- 17_create_operational_tables.sql must have run successfully.

Expected Result:
- dbo.Load exists
- dbo.MillTicket exists
- dbo.WeeklyReconciliation exists
- All three tables currently contain 0 rows

Safety / Impact:
- Read-only verification.
- Does not insert, update, or delete data.

Created: 2026-08-26
*/

USE TimberDataPlatform;
GO


/* =========================================================
   Verify operational tables exist
   ========================================================= */

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME IN
  (
      'Load',
      'MillTicket',
      'WeeklyReconciliation'
  )
ORDER BY TABLE_NAME;
GO


/* =========================================================
   Verify operational tables are empty
   ========================================================= */

SELECT 'Load' AS TableName, COUNT(*) AS RecordCount
FROM dbo.Load

UNION ALL

SELECT 'MillTicket', COUNT(*)
FROM dbo.MillTicket

UNION ALL

SELECT 'WeeklyReconciliation', COUNT(*)
FROM dbo.WeeklyReconciliation;
GO