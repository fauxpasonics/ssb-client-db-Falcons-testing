SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[CleanUpDuplicateTMAccountCustomers]

AS
BEGIN


SELECT AccountId, COUNT(*) cnt 
INTO #Dupes
FROM dbo.DimCustomer
WHERE CustomerType = 'Primary' AND SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
GROUP BY AccountId
HAVING COUNT(*) > 1


SELECT CONVERT(NVARCHAR(25), acct_id) + ':' + CONVERT(NVARCHAR(25), cust_name_id) SSID
, acct_id, cust_name_id, upd_date
, ROW_NUMBER() OVER(PARTITION BY acct_id ORDER BY upd_date desc) RowRank
INTO #CustRanking
FROM ods.TM_Cust c
INNER JOIN #Dupes d ON c.acct_id = d.AccountId
WHERE Primary_code = 'Primary'


SELECT old.DimCustomerId OldDimCustomerId, old.SSID OldSSID, new.DimCustomerId NewDimCustomerId, new.SSID NewSSID
INTO #CustomerUpdates
FROM (
SELECT cr.RowRank, dc.DimCustomerId, dc.AccountId, dc.SSID
FROM dbo.DimCustomer dc
INNER JOIN #CustRanking cr ON cr.SSID = dc.SSID
WHERE cr.RowRank > 1
) old 
INNER JOIN (
	SELECT cr.RowRank, dc.DimCustomerId, dc.AccountId, dc.SSID
	FROM dbo.DimCustomer dc
	INNER JOIN #CustRanking cr ON cr.SSID = dc.SSID AND dc.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
	WHERE cr.RowRank = 1
) new ON old.AccountId = new.AccountId

UPDATE f
SET f.DimCustomerId = cu.NewDimCustomerId
FROM dbo.FactAttendance f
INNER JOIN #CustomerUpdates cu ON f.DimCustomerId = cu.OldDimCustomerId

UPDATE f
SET f.DimCustomerId = cu.NewDimCustomerId
FROM dbo.FactTicketSales f
INNER JOIN #CustomerUpdates cu ON f.DimCustomerId = cu.OldDimCustomerId

UPDATE f
SET f.SoldDimCustomerId = cu.NewDimCustomerId
FROM dbo.FactInventory f
INNER JOIN #CustomerUpdates cu ON f.SoldDimCustomerId = cu.OldDimCustomerId



DELETE dbo.DimCustomer
WHERE DimCustomerId IN (SELECT DISTINCT OldDimCustomerId FROM #CustomerUpdates)


DELETE ods.TM_Cust
WHERE CONVERT(NVARCHAR(25), acct_id) + ':' + CONVERT(NVARCHAR(25), cust_name_id) IN (SELECT DISTINCT OldSSID FROM #CustomerUpdates)




END










GO
