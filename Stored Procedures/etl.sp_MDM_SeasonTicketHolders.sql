SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[sp_MDM_SeasonTicketHolders]
AS

SELECT *
INTO #tmpTrans
FROM etl.vwCRMProcess_SeasonTicketHolders

TRUNCATE TABLE etl.CRMProcess_SeasonTicketHolders

INSERT INTO etl.CRMProcess_SeasonTicketHolders (SSID, [SeasonYear], [SeasonYr], Team)
SELECT CAST(SSID AS VARCHAR(50)) SSID
, CAST(SeasonYear AS VARCHAR(50)) SeasonYear
, CAST(SeasonYr AS VARCHAR(50)) SeasonYr
, 'falcons' Team --updateme
FROM #tmpTrans


DROP TABLE #tmpTrans

GO
