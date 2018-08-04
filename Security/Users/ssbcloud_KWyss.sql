IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'ssbcloud\KWyss')
CREATE LOGIN [ssbcloud\KWyss] FROM WINDOWS
GO
CREATE USER [ssbcloud\KWyss] FOR LOGIN [ssbcloud\KWyss] WITH DEFAULT_SCHEMA=[ssbcloud\KWyss]
GO
REVOKE CONNECT TO [ssbcloud\KWyss]
