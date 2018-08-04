SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*************************************************

Created By: Caeleon Work
Created On: 
Updated By: Stephanie Gerber
Update Date: 2018-06-21
Update Notes: Manipulation of previous sp_Export_LiveA_Data SPROC with specific business rules for Atlanta United. 
Reviewed By: Daniel Horstman 
Review Date: 2018-07-18
Review Notes: Made some minor adjustments and materialized the resulting table
 
**************************************************/

 CREATE PROCEDURE [etl].[sp_Export_LiveA_Data]
 AS


SELECT dc.DimCustomerId
	, ssbid.SSB_CRMSYSTEM_CONTACT_ID
INTO #tmp_Active
FROM dbo.DimCustomer dc (NOLOCK)
JOIN dbo.dimcustomerssbid ssbid (NOLOCK)
	ON ssbid.DimCustomerId = dc.DimCustomerId
WHERE dc.sscreateddate >= DATEADD(YEAR, -3, getdate())
	OR dc.ssupdateddate >= DATEADD (YEAR, -3, getdate());

CREATE NONCLUSTERED INDEX idx_tmp_Active ON #tmp_Active(SSB_CRMSYSTEM_CONTACT_ID);	
--------------------------------------------------------------------------------------------------


SELECT DISTINCT fts.DimCustomerId
	, dc.SSB_CRMSYSTEM_CONTACT_ID
INTO #tmp_TicketBuyers
FROM dbo.FactTicketSales fts (NOLOCK)
JOIN dbo.dimcustomerssbid dc (nolock)
	ON dc.DimCustomerId = fts.DimCustomerId
JOIN dbo.DimDate dd (nolock)
	ON dd.DimDateId = fts.DimDateId
WHERE dd.CalDate >= dateadd(year, -3, getdate());

CREATE NONCLUSTERED INDEX idx_tmp_TicketBuyers ON #tmp_TicketBuyers(SSB_CRMSYSTEM_CONTACT_ID);	
--------------------------------------------------------------------------------------------------


SELECT DISTINCT ssbid.SSB_CRMSYSTEM_CONTACT_ID
INTO #tmp_DimCustomerSSBID_Omitted
FROM dbo.dimcustomerssbid ssbid (NOLOCK) 
JOIN (
	SELECT DISTINCT SSID
    FROM mdm.SSB_ID_History hist (NOLOCK)
	JOIN ods.LiveAnalytics_Customer cust (nolock)
		ON hist.ssb_crmsystem_contact_id = cust.acct_id
	) x
ON x.SSID = ssbid.SSID;

CREATE NONCLUSTERED INDEX idx_tmp_DimCustomerSSBID_Omitted ON #tmp_DimCustomerSSBID_Omitted(SSB_CRMSYSTEM_CONTACT_ID);	
--------------------------------------------------------------------------------------------------


--	proactively trim down the number of records being returned by moving applicable conditions to temp table build
SELECT modacct.*
INTO #tmp_vwCompositeRecord_ModAcctID
FROM dbo.vwCompositeRecord_ModAcctID modacct
WHERE modacct.EmailPrimary NOT LIKE '%@falcons.nfl.net'
	AND modacct.EmailPrimary NOT LIKE '%@ambfo.com'
	AND modacct.EmailPrimary NOT LIKE '%@ambse.com'
	AND modacct.EmailPrimary NOT LIKE '%@mercedesbenzstadium.com'
	AND modacct.EmailPrimary NOT LIKE '%@atlutd.com';

CREATE NONCLUSTERED INDEX idx_tmp_vwCompositeRecord_ModAcctID1 ON #tmp_vwCompositeRecord_ModAcctID(SSB_CRMSYSTEM_CONTACT_ID);
--------------------------------------------------------------------------------------------------


SELECT DISTINCT 
       compr.SSB_CRMSYSTEM_CONTACT_ID,
       NULL AS Blank1,
       NULLIF(compr.SourceSystem,'') AS SourceSystem,
       NULL AS Blank2,
       NULLIF(compr.CompanyName, '') AS CompanyName,
       NULLIF(compr.FirstName, '') FirstName,
       NULLIF(compr.MiddleName, '') MiddleName,
       NULLIF(compr.LastName, '') LastName,
       NULLIF(compr.Suffix, '') Suffix,
       NULLIF(compr.AddressPrimaryStreet, '') Address_Line1,
       NULLIF(compr.AddressPrimarySuite, '') Address_Line2,
       NULLIF(compr.AddressPrimaryCity, '') City,
       NULLIF(compr.AddressPrimaryState, '') State,
       NULLIF(compr.AddressPrimaryZip, '') Zip,
       NULLIF(compr.AddressPrimaryCountry, '') Country,
       NULLIF(compr.PhonePrimary, '') PhoneDay,
       NULLIF(compr.PhoneHome, '') PhoneEve,
       NULLIF(compr.EmailPrimary, '') Email
INTO #tmp_table1
FROM #tmp_vwCompositeRecord_ModAcctID compr (NOLOCK)
LEFT JOIN #tmp_DimCustomerSSBID_Omitted omit
	ON compr.SSB_CRMSYSTEM_CONTACT_ID = omit.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN #tmp_Active a (NOLOCK)
	ON a.ssb_crmsystem_contact_id = compr.SSB_CRMSYSTEM_CONTACT_ID
LEFT JOIN #tmp_TicketBuyers tb (NOLOCK)
	ON tb.ssb_crmsystem_contact_id = compr.SSB_CRMSYSTEM_CONTACT_ID
WHERE compr.AddressPrimaryStreet IS NOT NULL
	AND ISNULL(compr.FirstName, '') <> ''
	AND ISNULL(compr.LastName, '') <> ''
	AND compr.AddressPrimaryIsCleanStatus = 'Valid'
	AND ISNULL(compr.EmailPrimary, '') <> ''
	AND (a.ssb_crmsystem_contact_id IS NOT NULL	OR tb.ssb_crmsystem_contact_id IS NOT NULL)
	AND omit.SSB_CRMSYSTEM_CONTACT_ID IS NULL;


--	clear out tempdb
DROP TABLE #tmp_DimCustomerSSBID_Omitted;
DROP TABLE #tmp_Active;
DROP TABLE #tmp_TicketBuyers;
--------------------------------------------------------------------------------------------------


SELECT DISTINCT compr.SSB_CRMSYSTEM_CONTACT_ID,
	NULL AS Blank1,
	NULLIF(compr.SourceSystem,'') AS SourceSystem,
	NULL AS Blank2,
	NULLIF(compr.CompanyName, '') AS CompanyName,
	NULLIF(compr.FirstName, '') FirstName,
	NULLIF(compr.MiddleName, '') MiddleName,
	NULLIF(compr.LastName, '') LastName,
	NULLIF(compr.Suffix, '') Suffix,
	NULLIF(compr.AddressPrimaryStreet, '') Address_Line1,
	NULLIF(compr.AddressPrimarySuite, '') Address_Line2,
	NULLIF(compr.AddressPrimaryCity, '') City,
	NULLIF(compr.AddressPrimaryState, '') State,
	NULLIF(compr.AddressPrimaryZip, '') Zip,
	NULLIF(compr.AddressPrimaryCountry, '') Country,
	NULLIF(compr.PhonePrimary, '') PhoneDay,
	NULLIF(compr.PhoneHome, '') PhoneEve,
	NULLIF(compr.EmailPrimary, '') Email
INTO #tmp_table2
FROM dbo.FactTicketSales T1 (NOLOCK)
JOIN dbo.DimEvent T2 (NOLOCK)
	ON T2.DimEventId = T1.DimEventId
	AND T2.EventDate >= '2017-03-01'
	AND T1.DimCustomerId IS NOT NULL
	AND T2.SourceSystem = 'TM'
JOIN #tmp_vwCompositeRecord_ModAcctID compr (NOLOCK)
	ON T1.DimCustomerId = compr.DimCustomerId
LEFT JOIN dbo.DimPriceCode t4 (NOLOCK)
	ON t4.DimPriceCodeId = T1.DimPriceCodeId
JOIN (
	SELECT *
	FROM (
	    SELECT T1.*,
	           T2.Seat,
	           ROW_NUMBER() OVER (PARTITION BY T1.event_id,
	                                           T1.section_id,
	                                           T1.row_id,
	                                           T2.Seat
	                              ORDER BY T1.add_datetime DESC
	                             ) AS last_activity
	    FROM ods.TM_Tex T1 (NOLOCK)
	    JOIN dbo.Lkp_SeatList T2
			ON T2.Seat BETWEEN T1.seat_num AND T1.last_seat
	    WHERE 1 = 1
			AND activity_name IN ( 'TE Resale', 'Resale Transfer', 'Ticket Transfer', 'Forward' )
			AND CAST(T1.event_date AS DATE) >= '2016-01-01'
		) T1
		WHERE T1.last_activity = 1
) T5
	ON T5.event_id = T2.SSID_event_id
	AND T5.section_id = T1.SSID_section_id
	AND T5.row_id = T1.SSID_row_id
--	AND T2.SourceSystem = 'TM'				moved above to join condition	DCH 2018-07-18
WHERE 1 = 1
AND (t4.PC2 IS NULL OR t4.PC2 <> 'C')
--	AND T2.EventDate >= '2017-03-01'		moved above to join condition	DCH 2018-07-18
--	AND T1.DimCustomerId IS NOT NULL		moved above to join condition	DCH 2018-07-18
;
--------------------------------------------------------------------------------------------------


truncate table etl.FileExport_LiveAnalytics;


insert etl.FileExport_LiveAnalytics
select *
from #tmp_table1
UNION
select *
from #tmp_table2;





GO
