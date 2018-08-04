IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'ssbcloud\gholder')
CREATE LOGIN [ssbcloud\gholder] FROM WINDOWS
GO
CREATE USER [ssbcloud\gholder] FOR LOGIN [ssbcloud\gholder] WITH DEFAULT_SCHEMA=[ssbcloud\gholder]
GO
