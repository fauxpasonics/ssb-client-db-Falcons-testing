IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'SSBCLOUD\jlouviere')
CREATE LOGIN [SSBCLOUD\jlouviere] FROM WINDOWS
GO
CREATE USER [SSBCLOUD\jlouviere] FOR LOGIN [SSBCLOUD\jlouviere]
GO
