SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





-- =============================================
-- Author:		Caeleon Work
-- Create date: 7/11/2017
-- Description:	SilverPop GetList Load sProc
-- =============================================
CREATE PROCEDURE [apietl].[SP_Load_imc_rawRecipientDataExport]
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

    -- Insert statements for procedure here
        MERGE ods.IMC_RawRecipientData AS TARGET
        USING
            (
              SELECT  DISTINCT  GETDATE() AS ETL__InsertedDate
                      , GETDATE() AS ETL__UpdatedDate
                      , CAST(srrde.[Recipient Id] AS NVARCHAR(255)) AS RecipientID
                      , CAST(srrde.[Recipient Type] AS NVARCHAR(255)) AS RecipientType
                      , CAST(srrde.[Mailing Id] AS NVARCHAR(255)) AS MailingID
                      , CAST(srrde.[Report Id] AS NVARCHAR(255)) AS ReportID
                      , CAST(srrde.[Campaign Id] AS NVARCHAR(255)) AS CampaignID
                      , CAST(srrde.Email AS NVARCHAR(255)) AS Email
                      , CAST(srrde.[Event Type] AS NVARCHAR(255)) AS EventType
                      , CAST(srrde.[Event Timestamp] AS DATETIME2) AS EventTimestamp
                      , CAST(srrde.[Body Type] AS NVARCHAR(255)) AS BodyType
                      , CAST(srrde.[Content Id] AS NVARCHAR(255)) AS ContentId
                      , CAST(srrde.[Click Name] AS NVARCHAR(255)) AS ClickName
                      , CAST(srrde.URL AS NVARCHAR(1000)) AS URL
                      , CAST(srrde.[Conversion Action] AS NVARCHAR(255)) AS ConversionAction
                      , CAST(srrde.[Conversion Detail] AS NVARCHAR(255)) AS ConversionDetail
                      , CAST(srrde.[Conversion Amount] AS NVARCHAR(255)) AS ConversionAmount
                      , CAST(srrde.[Suppression Reason] AS NVARCHAR(255)) AS SuppressionReason
                      --, CAST(srrde.JOB_ID AS NVARCHAR(255)) AS JOB_ID
                      --, CAST(srrde.FILE_PATH AS NVARCHAR(255)) AS FILE_PATH
              FROM      apietl.silverpop_rawRecipientDataExport_0 AS srrde
            ) AS SOURCE
        ON TARGET.RecipientID = SOURCE.RecipientID
            AND TARGET.MailingID = SOURCE.MailingID
            AND TARGET.ReportID = SOURCE.ReportID
            AND TARGET.EventType = SOURCE.EventType
            AND TARGET.EventTimestamp = SOURCE.EventTimestamp
			AND TARGET.BodyType = SOURCE.BodyType
			AND TARGET.ClickName = SOURCE.ClickName
			AND TARGET.URL = SOURCE.URL
        WHEN NOT MATCHED THEN
            INSERT ( ETL__InsertedDate
                   , ETL__UpdatedDate
                   , RecipientID
                   , RecipientType
                   , MailingID
                   , ReportID
                   , CampaignID
                   , Email
                   , EventType
                   , EventTimestamp
                   , BodyType
                   , ContentId
                   , ClickName
                   , URL
                   , ConversionAction
                   , ConversionDetail
                   , ConversionAmount
                   , SuppressionReason
                   --, JOB_ID
                   --, FILE_PATH

                   )
            VALUES ( SOURCE.ETL__InsertedDate
                   , SOURCE.ETL__UpdatedDate
                   , SOURCE.RecipientID
                   , SOURCE.RecipientType
                   , SOURCE.MailingID
                   , SOURCE.ReportID
                   , SOURCE.CampaignID
                   , SOURCE.Email
                   , SOURCE.EventType
                   , SOURCE.EventTimestamp
                   , SOURCE.BodyType
                   , SOURCE.ContentId
                   , SOURCE.ClickName
                   , SOURCE.URL
                   , SOURCE.ConversionAction
                   , SOURCE.ConversionDetail
                   , SOURCE.ConversionAmount
                   , SOURCE.SuppressionReason
                   --, SOURCE.JOB_ID
                   --, SOURCE.FILE_PATH
                   )
			WHEN MATCHED
			THEN UPDATE SET 
			TARGET.ETL__UpdatedDate=SOURCE.ETL__UpdatedDate
			, TARGET.RecipientID=SOURCE.RecipientID
            , TARGET.RecipientType=SOURCE.RecipientType
            , TARGET.MailingID=SOURCE.MailingID
            , TARGET.ReportID=SOURCE.ReportID
            , TARGET.CampaignID=SOURCE.CampaignID
            , TARGET.Email=SOURCE.Email
            , TARGET.EventType=SOURCE.EventType
            , TARGET.EventTimestamp=SOURCE.EventTimestamp
            , TARGET.BodyType=SOURCE.BodyType
            , TARGET.ContentId=SOURCE.ContentId
            , TARGET.ClickName=SOURCE.ClickName
            , TARGET.URL=SOURCE.URL
            , TARGET.ConversionAction=SOURCE.ConversionAction
            , TARGET.ConversionDetail=SOURCE.ConversionDetail
            , TARGET.ConversionAmount=source.ConversionAmount
            , TARGET.SuppressionReason=SOURCE.SuppressionReason;

    END;


GO
