SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/***************************************
Created By: Caeleon Work
Created On: 05-23-2018
Reviewed By: Jeff Barberio
Reviewed On: 05-29-2018
Modified By: Caeleon Work
Modified On: 05-29-2018
Modification Notes: Made case statement changes based on Jeff's recommendations and updated logic to remove dupes.
*****************************************/
CREATE PROC [etl].[sp_load_etl_FileExport_IMC_CustomerCustom]
AS
TRUNCATE TABLE etl.FileExport_IMC_CustomerCustom;

IF OBJECT_ID('tempdb..#duplicate') IS NOT NULL DROP TABLE #duplicate

SELECT x.RECIPIENT_ID,
       Email,
       CASE WHEN x.RecordRank > 1 THEN 'Yes'  ELSE 'No' END AS Duplicate
INTO #duplicate
FROM
(
    SELECT RECIPIENT_ID,
           Email,
           Last_Click,
           Last_Open,
           Last_Sent,
           ROW_NUMBER() OVER (PARTITION BY Email
                              ORDER BY CASE
                                           WHEN [PSL_Owner] = 'Yes' THEN
                                               1
                                           ELSE
                                               2
                                       END,
                                       Last_Click DESC,
                                       Last_Open DESC,
                                       Last_Sent DESC
                             ) RecordRank
    FROM ods.IMC_ContactList_MainDatabase (NOLOCK)
    WHERE ISNULL(Email, '') <> ''
) x

CREATE INDEX IDX_DupeEmail ON #duplicate (RECIPIENT_ID, Email);

IF OBJECT_ID('tempdb..#minsource') IS NOT NULL DROP TABLE #minsource

SELECT d1.EmailPrimary
      ,d1.SourceSystem
INTO #minsource
FROM dbo.vwDimCustomer_ModAcctId d1
    JOIN
    (
        SELECT dimcustomerid
			  ,ROW_NUMBER() OVER(PARTITION BY emailPrimary ORDER BY SSCreatedDate) rnk		--partition by emailprimary and use ROW_NUMBER() to ensure only one record is chosen (might want to create a ranking by source system instead)	
        FROM dbo.vwDimCustomer_ModAcctId
    ) EmailRank ON EmailRank.dimcustomerid = d1.dimcustomerid
WHERE rnk = 1

CREATE INDEX IDX_MinSourceEmail ON #minsource (EmailPrimary);

INSERT INTO etl.FileExport_IMC_CustomerCustom
(
    optin_AF_date,
    optin_AU_date,
    optin_Stadium_Date,
    PSL_Owner_SSB,
    United_Season_Ticket_Holder,
    Falcons_Season_Ticket_Holder,
    Duplicate,
    Recipient_id,
    acquisition_source,
    optin_AF_Source,
    optin_AU_Source,
    optin_Stadium_Source
)
SELECT cf.optin_AF_date,
       cf.optin_AU_date,
       cf.optin_Stadium_Date,
       CASE WHEN cf.PSL_Owner = '0' THEN 'No' WHEN cf.PSL_Owner = '1' THEN 'Yes' ELSE NULL END AS PSL_Owner_SSB,
       CASE WHEN cf.[2018_United_STM] = '0' THEN 'No' WHEN cf.[2018_United_STM] = '1' THEN 'Yes' ELSE NULL END AS United_Season_Ticket_Holder,
       CASE WHEN cf.[2018_Falcons_STM] = '0' THEN 'No' WHEN cf.[2018_Falcons_STM] = '1' THEN 'Yes' ELSE NULL END AS Falcons_Season_Ticket_Holder,
       d.Duplicate,
       dc1.SSID Recipient_id,
       ms.SourceSystem AS acquisition_source,
       CASE
           WHEN cf.optin_AF_date IS NOT NULL THEN
               'AF-TicketMaster'
           ELSE
               NULL
       END AS optin_AF_Source,
       CASE
           WHEN cf.optin_AU_date IS NOT NULL THEN
               'AU-TicketMaster'
       END AS optin_AU_Source,
       --CASE
       --    WHEN cf.optin_AF_date IS NOT NULL
       --         AND cf.optin_AU_date IS NULL
       --         AND cf.optin_Stadium_Date IS NULL THEN
       --        'AF-TicketMaster'
       --    WHEN cf.optin_AF_date IS NULL
       --         AND cf.optin_AU_date IS NOT NULL
       --         AND cf.optin_Stadium_Date IS NULL THEN
       --        'AU-TicketMaster'
       --    WHEN cf.optin_AF_date IS NULL
       --         AND cf.optin_AU_date IS NULL
       --         AND cf.optin_Stadium_Date IS NOT NULL THEN
       --        'MBS-TicketMaster'
       --    WHEN cf.optin_AF_date IS NOT NULL
       --         AND cf.optin_AU_date IS NOT NULL
       --         AND cf.optin_Stadium_Date IS NULL
       --         AND cf.optin_AF_date > cf.optin_AU_date THEN
       --        'AF-TicketMaster'
       --    WHEN cf.optin_AF_date IS NOT NULL
       --         AND cf.optin_AU_date IS NOT NULL
       --         AND cf.optin_Stadium_Date IS NULL
       --         AND cf.optin_AF_date < cf.optin_AU_date THEN
       --        'AU-TicketMaster'
       --    WHEN cf.optin_AF_date IS NOT NULL
       --         AND cf.optin_AU_date IS NULL
       --         AND cf.optin_Stadium_Date IS NOT NULL
       --         AND cf.optin_AF_date > cf.optin_Stadium_Date THEN
       --        'AF-TicketMaster'
       --    WHEN cf.optin_AF_date IS NOT NULL
       --         AND cf.optin_AU_date IS NULL
       --         AND cf.optin_Stadium_Date IS NOT NULL
       --         AND cf.optin_AF_date < cf.optin_Stadium_Date THEN
       --        'MBS-TicketMaster'
       --    WHEN cf.optin_AF_date IS NULL
       --         AND cf.optin_AU_date IS NOT NULL
       --         AND cf.optin_Stadium_Date IS NOT NULL
       --         AND cf.optin_AU_date > cf.optin_Stadium_Date THEN
       --        'AU-TicketMaster'
       --    WHEN cf.optin_AF_date IS NULL
       --         AND cf.optin_AU_date IS NOT NULL
       --         AND cf.optin_Stadium_Date IS NOT NULL
       --         AND cf.optin_AF_date < cf.optin_Stadium_Date THEN
       --        'MBS-TicketMaster'
       --    WHEN cf.optin_AF_date IS NOT NULL
       --         AND cf.optin_AU_date IS NOT NULL
       --         AND cf.optin_Stadium_Date IS NOT NULL
       --         AND cf.optin_AF_date > cf.optin_AU_date
       --         AND cf.optin_AF_date > cf.optin_Stadium_Date THEN
       --        'AF-TicketMaster'
       --    WHEN cf.optin_AF_date IS NOT NULL
       --         AND cf.optin_AU_date IS NOT NULL
       --         AND cf.optin_Stadium_Date IS NOT NULL
       --         AND cf.optin_AU_date > cf.optin_AF_date
       --         AND cf.optin_AU_date > cf.optin_Stadium_Date THEN
       --        'AU-TicketMaster'
       --    WHEN cf.optin_AF_date IS NOT NULL
       --         AND cf.optin_AU_date IS NOT NULL
       --         AND cf.optin_Stadium_Date IS NOT NULL
       --         AND cf.optin_Stadium_Date > cf.optin_AU_date
       --         AND cf.optin_AF_date < cf.optin_Stadium_Date THEN
       --        'MBS-TicketMaster'
       --    ELSE
       --        NULL
       --END AS optin_Stadium_Source
	   CASE WHEN cf.optin_AF_date IS NULL 
				  AND cf.optin_AU_date IS NULL 
				  AND cf.optin_Stadium_Date IS NULL														THEN NULL
			 WHEN ISNULL(cf.optin_AU_date,GETDATE()) < ISNULL(cf.optin_AF_date,GETDATE())
				  AND ISNULL(cf.optin_AU_date,GETDATE()) < ISNULL(cf.optin_Stadium_Date,GETDATE())	THEN 'AU-TicketMaster'
			 WHEN ISNULL(cf.optin_Stadium_Date,GETDATE()) < ISNULL(cf.optin_AF_date,GETDATE())		THEN 'MBS-TicketMaster'
			 ELSE 'AF-TicketMaster'
       END AS optin_Stadium_Source_NEW -- cleaned up the above case statement a bit
FROM dbo.vwDimCustomer_ModAcctId dc1
    JOIN #duplicate d
        ON d.Recipient_id = dc1.SSID
    JOIN #minsource ms
        ON ms.EmailPrimary = dc1.EmailPrimary
    LEFT JOIN etl.vw_customfield_group_by_email cf (NOLOCK)
        ON cf.EmailPrimary = dc1.EmailPrimary
WHERE dc1.SourceSystem = 'IBM_Email';



GO
