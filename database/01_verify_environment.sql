/*
Project: Timber Operations, Settlement, and Financial Analytics Platform
Purpose: Verify the local SQL Server installation and connection.
Created: 2026-08-05
*/

SELECT
    @@SERVERNAME AS ServerName,
    @@VERSION AS VersionInfo,
    SUSER_SNAME() AS CurrentLogin,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductVersion') AS ProductVersion,
    SERVERPROPERTY('ProductLevel') AS ProductLevel;