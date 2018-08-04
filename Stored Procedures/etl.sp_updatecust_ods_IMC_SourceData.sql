SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[sp_updatecust_ods_IMC_SourceData]
AS

/*PSL Owners*/
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

/*Founding Members*/
IF OBJECT_ID('tempdb..#Founding_Members') IS NOT NULL
    DROP TABLE #Founding_Members
select distinct b.dimcustomerid, B.ACCOUNTID, b.emailprimary
INTO #Founding_Members
from dbo.FactTicketSales (NOLOCK) a
JOIN [dbo].[DimCustomer]b ON b.DimCustomerId = a.DimCustomerId
where a.dimcustomerid = b.dimcustomerid
and a.DimPlanId=173----Full Season
and b.sourcedb = 'Falcons'

/*Multi Packs*/
IF OBJECT_ID('tempdb..#MulitPack') IS NOT NULL
    DROP TABLE #MulitPack
select distinct b.dimcustomerid, B.ACCOUNTID, b.emailprimary
INTO #MulitPack
from dbo.FactTicketSales a JOIN 
[dbo].[DimCustomer]b ON b.DimCustomerId = a.DimCustomerId
where a.DimPlanId IN (162
,164
,171
,174
,179)
and b.sourcedb = 'Falcons'

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

/*United STM Paid*/
IF OBJECT_ID('tempdb..#UnitedSTM_Paid') IS NOT NULL
    DROP TABLE #UnitedSTM_Paid
SELECT DISTINCT fts.DimCustomerId, fts.SSID_acct_id, dpc.PriceCode, b.emailprimary
INTO #UnitedSTM_Paid
FROM dbo.FactTicketSales fts (NOLOCK)
JOIN dbo.dimcustomer b (NOLOCK) ON b.dimcustomerid=fts.dimcustomerid
JOIN dbo.DimPriceCode dpc (NOLOCK) ON dpc.DimPriceCodeId = fts.DimPriceCodeId
 WHERE fts.DimSeasonId = 144
 AND fts.DimEventId=592
 AND dpc.PC2='S'

/*Falcons Single Game*/
IF OBJECT_ID('tempdb..#Falcons_SingleGame') IS NOT NULL
    DROP TABLE #Falcons_SingleGame
SELECT DISTINCT fts.DimCustomerId, fts.SSID_acct_id, dpc.PriceCode, b.emailprimary
INTO #Falcons_SingleGame
FROM dbo.FactTicketSales fts (NOLOCK)
JOIN dbo.dimcustomer b (NOLOCK) ON b.dimcustomerid=fts.dimcustomerid
JOIN dbo.DimPriceCode dpc (NOLOCK) ON dpc.DimPriceCodeId = fts.DimPriceCodeId
 WHERE fts.DimSeasonId = 182
 AND fts.IsSingleEvent=1

 /*United Single Game*/
 IF OBJECT_ID('tempdb..#United_SingleGame') IS NOT NULL
    DROP TABLE #United_SingleGame
SELECT DISTINCT fts.DimCustomerId, fts.SSID_acct_id, dpc.PriceCode, b.emailprimary
INTO #United_SingleGame
FROM dbo.FactTicketSales fts (NOLOCK)
JOIN dbo.dimcustomer b (NOLOCK) ON b.dimcustomerid=fts.dimcustomerid
JOIN dbo.DimPriceCode dpc (NOLOCK) ON dpc.DimPriceCodeId = fts.DimPriceCodeId
 WHERE fts.DimSeasonId = 144
 AND fts.IsSingleEvent=1


  IF OBJECT_ID('tempdb..#Staged') IS NOT NULL
    DROP TABLE #Staged
 SELECT DISTINCT isd.EMAIL, CASE WHEN fsg.EmailPrimary IS NOT NULL THEN 'Yes' ELSE NULL END AS Falcons_SingleGameBuyer_SSB,
 CASE WHEN fm.EmailPrimary IS NOT NULL THEN 'Yes' ELSE NULL END AS FoundingMembers,
 CASE WHEN mp.EmailPrimary IS NOT NULL THEN 'Yes' ELSE NULL END AS United_MultiPack_SSB,
 CASE WHEN psl.EmailPrimary IS NOT NULL THEN 'Yes' ELSE NULL END AS PSL_Owner_SSB,
 CASE WHEN sp.EmailPrimary IS NOT NULL THEN 'Yes' ELSE NULL END AS [2017_Falcons_STM_Paid],
 CASE WHEN usp.EmailPrimary IS NOT NULL THEN 'Yes' ELSE NULL END AS [2017_United_STM_Paid],
 CASE WHEN usg.EmailPrimary IS NOT NULL THEN 'Yes' ELSE NULL END AS United_SingleGameBuyer_SSB
 INTO #Staged
 FROM ods.IMC_SourceData isd (NOLOCK)
 LEFT JOIN #Falcons_SingleGame fsg ON isd.EMAIL=fsg.EmailPrimary
 LEFT JOIN #Founding_Members fm ON isd.EMAIL=fm.EmailPrimary
 LEFT JOIN #MulitPack mp ON isd.EMAIL=mp.EmailPrimary
 LEFT JOIN #PSL_Owner psl ON isd.EMAIL=psl.EmailPrimary
 LEFT JOIN #STM_Paid sp ON isd.EMAIL=sp.EmailPrimary
 LEFT JOIN #UnitedSTM_Paid usp ON isd.EMAIL=usp.EmailPrimary
 LEFT JOIN #United_SingleGame usg ON isd.EMAIL=usg.EmailPrimary

MERGE ods.IMC_SourceData AS myTarget
USING
    ( SELECT    *
      FROM      #Staged
    ) AS mySource
ON ( myTarget.EMAIL = mySource.EMAIL
   )
WHEN MATCHED THEN
    UPDATE SET myTarget.PSL_Owner_SSB=mySource.PSL_Owner_SSB
			,myTarget.[2017_United_STM_Paid]=mySource.[2017_United_STM_Paid]
			,myTarget.United_MultiPack_SSB=mySource.United_MultiPack_SSB
			,myTarget.United_SingleGameBuyer_SSB=mySource.United_SingleGameBuyer_SSB
			,myTarget.[2017_Falcons_STM_Paid]=mySource.[2017_Falcons_STM_Paid]
			,myTarget.Falcons_SingleGameBuyer_SSB=mySource.Falcons_SingleGameBuyer_SSB;
GO
