SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




-- =============================================
-- Author:		Caeleon Work
-- Create date: 07/11/2017
-- Description:	SilverPop GetList Load sProc
-- =============================================
CREATE PROCEDURE [apietl].[sp_Load_IMC_GetSentMailings]
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

    -- Insert statements for procedure here
        MERGE ods.IMC_Mailings AS TARGET
        USING
            (
              SELECT    *
              FROM      (
                          SELECT    GETDATE() AS ETL__InsertedDate
                                  , GETDATE() AS ETL__UpdatedDate
                                  , CAST(list.MailingId AS NVARCHAR(400)) AS MailingId
                                  , CAST(MailingName.[#cdata-section] AS NVARCHAR(400)) AS mailingName
                                  , CAST(Subject.[#cdata-section] AS NVARCHAR(400)) AS subject
                                  , CAST(list.ParentListId AS NVARCHAR(400)) AS ParentListId
                                  , CAST(list.ListId AS NVARCHAR(400)) AS ListId
                                  , CAST(Listname.[#cdata-section] AS NVARCHAR(400)) AS listName
                                --  , CAST(list.ContactListId AS NVARCHAR(400)) AS ContactListId
                                --  , CAST(list.ContactListName AS NVARCHAR(400)) AS ContactListName
                                  , CAST(list.UserName AS NVARCHAR(400)) AS UserName
                                  , CAST(list.ScheduledTS AS DATETIME2) AS ScheduledTS
                                  , CAST(list.SentTS AS DATETIME2) AS SentTS
                                  , CAST(list.NumSent AS INT) AS NumSent
                                  , CAST(list.Visibility AS NVARCHAR(400)) AS Visibility
                                  , CAST(list.ParentTemplateId AS NVARCHAR(400)) AS ParentTemplateId
                                  , CAST(list.QueryId AS NVARCHAR(400)) AS QueryId
                                  , CAST(list.QueryName AS NVARCHAR(400)) AS QueryName
                                  , ROW_NUMBER() OVER ( PARTITION BY list.MailingId ORDER BY list.ETL__insert_datetime DESC ) AS mailing_rank
                          FROM      apietl.silverpop_get_sent_mailings_for_list_0 AS list
                                    LEFT JOIN apietl.silverpop_get_sent_mailings_for_list_ListName_1 AS Listname ON Listname.ETL__silverpop_get_sent_mailings_for_list_id = list.ETL__silverpop_get_sent_mailings_for_list_id 
                                    LEFT JOIN apietl.silverpop_get_sent_mailings_for_list_Subject_1 AS Subject ON Subject.ETL__silverpop_get_sent_mailings_for_list_id = list.ETL__silverpop_get_sent_mailings_for_list_id
                                    LEFT JOIN apietl.silverpop_get_sent_mailings_for_list_MailingName_1 AS MailingName ON MailingName.ETL__silverpop_get_sent_mailings_for_list_id = list.ETL__silverpop_get_sent_mailings_for_list_id
                        ) a
              WHERE     a.mailing_rank = 1
            ) AS SOURCE
        ON TARGET.MailingId = SOURCE.MailingId
        WHEN MATCHED THEN
            UPDATE SET
                    TARGET.ETL__UpdatedDate = SOURCE.ETL__UpdatedDate
                  , TARGET.mailingName = SOURCE.mailingName
                  , TARGET.subject = SOURCE.subject
                  , TARGET.ParentListId = SOURCE.ParentListId
                  , TARGET.ListId = SOURCE.ListId
                  , TARGET.listName = SOURCE.listName
                  --, TARGET.ContactListId = SOURCE.ContactListId
                  --, TARGET.ContactListName = SOURCE.ContactListName
                  , TARGET.UserName = SOURCE.UserName
                  , TARGET.ScheduledTS = SOURCE.ScheduledTS
                  , TARGET.SentTS = SOURCE.SentTS
                  , TARGET.NumSent = SOURCE.NumSent
                  , TARGET.Visibility = SOURCE.Visibility
                  , TARGET.ParentTemplateId = SOURCE.ParentTemplateId
                  , TARGET.QueryId = SOURCE.QueryId
                  , TARGET.QueryName = SOURCE.QueryName
        WHEN NOT MATCHED THEN
            INSERT ( ETL__InsertedDate
                   , ETL__UpdatedDate
                   , MailingId
                   , mailingName
                   , subject
                   , ParentListId
                   , ListId
                   , listName
                   --, ContactListId
                   --, ContactListName
                   , UserName
                   , ScheduledTS
                   , SentTS
                   , NumSent
                   , Visibility
                   , ParentTemplateId
                   , QueryId
                   , QueryName
                   )
            VALUES ( SOURCE.ETL__InsertedDate
                   , SOURCE.ETL__UpdatedDate
                   , SOURCE.MailingId
                   , SOURCE.mailingName
                   , SOURCE.subject
                   , SOURCE.ParentListId
                   , SOURCE.ListId
                   , SOURCE.listName
                   --, SOURCE.ContactListId
                   --, SOURCE.ContactListName
                   , SOURCE.UserName
                   , SOURCE.ScheduledTS
                   , SOURCE.SentTS
                   , SOURCE.NumSent
                   , SOURCE.Visibility
                   , SOURCE.ParentTemplateId
                   , SOURCE.QueryId
                   , SOURCE.QueryName
                   );

    END;




GO
