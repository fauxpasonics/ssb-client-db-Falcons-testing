SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [etl].[sp_CRMInteg_RecentCustData]
AS

TRUNCATE TABLE etl.CRMProcess_RecentCustData

DECLARE @Client VARCHAR(50)
SET @Client = 'falcons' ;--updateme



/*
--PRE-GO-LIVE ONLY

IF OBJECT_ID('tempdb..#PSL_Owner') IS NOT NULL
    DROP TABLE #PSL_Owner
SELECT distinct psl.DimCustomerId, psl.SSID_acct_id, dc.emailprimary
INTO #PSL_Owner
from  dbo.FactTicketSales (NOLOCK) psl
JOIN dbo.dimcustomer dc (NOLOCK) ON dc.dimcustomerid=psl.dimcustomerid
where 1=1
and psl.DimSeasonId = 153
and psl.DimEventId in (197,677)
AND psl.SourceSystem = 'TM-Falcons_PSL'

/*Falcons STM Paid*/
IF OBJECT_ID('tempdb..#STM_Paid') IS NOT NULL
    DROP TABLE #STM_Paid
SELECT DISTINCT fts.DimCustomerId, fts.SSID_acct_id, dpc.PriceCode, b.emailprimary
INTO #STM_Paid 
FROM dbo.FactTicketSales fts (NOLOCK)
JOIN dbo.dimcustomer b (NOLOCK) ON b.dimcustomerid=fts.dimcustomerid
JOIN dbo.DimPriceCode dpc (NOLOCK) ON dpc.DimPriceCodeId = fts.DimPriceCodeId
 WHERE fts.DimSeasonId = 182
 AND fts.DimEventId=787
 AND dpc.PC2='S'


SELECT x.dimcustomerid, MAX(x.maxtransdate) maxtransdate, x.team
INTO #tmpTicketSales
	FROM (



		--SELECT DimCustomerid, sscreateddate AS maxtransdate, @Client AS team
		--FROM dbo.vwDimCustomer_ModAcctId WHERE ISNULL(firstname,'') + ISNULL(lastname,'') != '' AND ISNULL(EmailPrimary,'') + ISNULL(AddressPrimaryStreet,'') != ''

		--WILL NEED TO FILTER OUT LEGACY CRM AFTER FIRST RUN. SHOULD PROBABLY LIMIT THE ONE OFF SOURCES AS WELL

		/*PSL Owners*/


 SELECT ma.DimCustomerId, ma.SSCreateddate AS maxtransdate, @Client AS Team 
 FROM dbo.vwDimCustomer_ModAcctId ma
 LEFT JOIN #PSL_Owner p
 ON p.DimCustomerId = ma.DimCustomerId
 LEFT JOIN #STM_Paid s
 ON s.DimCustomerId = ma.DimCustomerId
 WHERE p.DimCustomerId IS NOT NULL OR s.DimCustomerId IS NOT null



		) x
		GROUP BY x.dimcustomerid, x.team

*/

--SELECT SSB_CRMSYSTEM_CONTACT_ID, COUNT(DISTINCT SourceSystem) count
--INTO #temp
--FROM dbo.vwDimCustomer_ModAcctId
--GROUP BY SSB_CRMSYSTEM_CONTACT_ID

--SELECT ma.SSB_CRMSYSTEM_CONTACT_ID
--INTO #IBM_Only
--FROM #temp t
--INNER JOIN dbo.vwDimCustomer_ModAcctId ma
--ON ma.SSB_CRMSYSTEM_CONTACT_ID = t.SSB_CRMSYSTEM_CONTACT_ID and ma.SourceSystem = 'IBM_Email' AND t.count = 1

SELECT ma.DimCustomerId, ma.SSID, CreatedDate AS MaxTransDate, @Client AS Team
INTO [#tmpTicketSales]
FROM dbo.vwCompositeRecord_ModAcctID ma
--LEFT JOIN #IBM_Only i ON i.SSB_CRMSYSTEM_CONTACT_ID = ma.SSB_CRMSYSTEM_CONTACT_ID
WHERE ma.SourceSystem IN (
'Fanatics',
'FB_Leads',
'IBM_Email',
'TM',
'TM-Falcons_PSL'
)
--AND i.SSB_CRMSYSTEM_CONTACT_ID IS null
UNION
SELECT ma.DimCustomerId, ma.SSID, CreatedDate AS MaxTransDate, @Client AS Team
FROM dbo.vwCompositeRecord_ModAcctID ma
WHERE ma.SourceSystem NOT IN (
'Fanatics',
'FB_Leads',
'IBM_Email',
'TM',
'TM-Falcons_PSL'
, 'Legacy_Dynamics_Contact'
, 'Legacy_Dynamics_Account'
)
AND createddate > GETDATE() - 10


INSERT INTO etl.CRMProcess_RecentCustData (dimcustomerid, SSID, MaxTransDate, Team)
SELECT a.dimcustomerid, a.SSID, [MaxTransDate], Team FROM [#tmpTicketSales] a 
INNER JOIN dbo.[vwDimCustomer_ModAcctId] b ON [b].[DimCustomerId] = [a].[DimCustomerId]



GO
