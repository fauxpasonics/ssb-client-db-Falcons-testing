SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[Matchkey_Name_UnverifiableAddress]
AS


SELECT *
FROM mdm.matchkeyconfig
WHERE matchkeyid = 14


GO
