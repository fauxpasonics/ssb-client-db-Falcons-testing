SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
-- Get the status of your table 20 minutes ago...
DECLARE @AsOfDate DATETIME = (SELECT [etl].[ConvertToLocalTime](DATEADD(MINUTE,-20,GETDATE())))
SELECT * FROM [ods].[AsOf_TurnKey_GetParticipantDataEx] (@AsOfDate)
*/

CREATE FUNCTION [ods].[AsOf_TurnKey_GetParticipantDataEx] (@AsOfDate DATETIME)

RETURNS @Results TABLE
(
[SurveyID] [nvarchar](50) NULL,
[recordid] [bigint] NULL,
[started] [datetime] NULL,
[completed] [datetime] NULL,
[branched_out] [nvarchar](50) NULL,
[over_quota] [nvarchar](50) NULL,
[modified] [datetime] NULL,
[campaign_status] [int] NULL,
[culture] [nvarchar](50) NULL,
[http_referer] [nvarchar](255) NULL,
[http_user_agent] [nvarchar](500) NULL,
[remote_addr] [nvarchar](255) NULL,
[remote_host] [nvarchar](255) NULL,
[Participant_last_page] [int] NULL,
[Participant_url] [nvarchar](500) NULL,
[Participant_last_page_number] [int] NULL,
[Participant_modifier] [int] NULL,
[Participant_device_type] [int] NULL,
[Participant_ua_family] [nvarchar](255) NULL,
[Participant_ua_majorver] [nvarchar](255) NULL,
[Participant_os_name] [nvarchar](255) NULL,
[Participant_os_family] [nvarchar](255) NULL,
[Participant_iploc_long] [nvarchar](100) NULL,
[Participant_iploc_lat] [nvarchar](100) NULL,
[Participant_iploc_city] [nvarchar](100) NULL,
[Participant_iploc_state] [nvarchar](255) NULL,
[Participant_iploc_country] [nvarchar](255) NULL,
[Participant_iploc_zipcode] [nvarchar](100) NULL,
[ETL_CreatedOn] [datetime] NOT NULL,
[ETL_CreatedBy] NVARCHAR(400) NOT NULL,
[ETL_UpdatedOn] [datetime] NOT NULL,
[ETL_UpdatedBy] NVARCHAR(400) NOT NULL
)

AS
BEGIN

DECLARE @EndDate DATETIME = (SELECT [etl].[ConvertToLocalTime](CAST(GETDATE() AS datetime2(0))))
SET @AsOfDate = (SELECT CAST(@AsOfDate AS datetime2(0)))

INSERT INTO @Results
SELECT [SurveyID],[recordid],[started],[completed],[branched_out],[over_quota],[modified],[campaign_status],[culture],[http_referer],[http_user_agent],[remote_addr],[remote_host],[Participant_last_page],[Participant_url],[Participant_last_page_number],[Participant_modifier],[Participant_device_type],[Participant_ua_family],[Participant_ua_majorver],[Participant_os_name],[Participant_os_family],[Participant_iploc_long],[Participant_iploc_lat],[Participant_iploc_city],[Participant_iploc_state],[Participant_iploc_country],[Participant_iploc_zipcode],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy]
FROM
	(
	SELECT [SurveyID],[recordid],[started],[completed],[branched_out],[over_quota],[modified],[campaign_status],[culture],[http_referer],[http_user_agent],[remote_addr],[remote_host],[Participant_last_page],[Participant_url],[Participant_last_page_number],[Participant_modifier],[Participant_device_type],[Participant_ua_family],[Participant_ua_majorver],[Participant_os_name],[Participant_os_family],[Participant_iploc_long],[Participant_iploc_lat],[Participant_iploc_city],[Participant_iploc_state],[Participant_iploc_country],[Participant_iploc_zipcode],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy],@EndDate [RecordEndDate]
	FROM [ods].[TurnKey_GetParticipantDataEx] t
	UNION ALL
	SELECT [SurveyID],[recordid],[started],[completed],[branched_out],[over_quota],[modified],[campaign_status],[culture],[http_referer],[http_user_agent],[remote_addr],[remote_host],[Participant_last_page],[Participant_url],[Participant_last_page_number],[Participant_modifier],[Participant_device_type],[Participant_ua_family],[Participant_ua_majorver],[Participant_os_name],[Participant_os_family],[Participant_iploc_long],[Participant_iploc_lat],[Participant_iploc_city],[Participant_iploc_state],[Participant_iploc_country],[Participant_iploc_zipcode],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy],[RecordEndDate]
	FROM [ods].[Snapshot_TurnKey_GetParticipantDataEx]
	) a
WHERE
	@AsOfDate BETWEEN [ETL_UpdatedOn] AND [RecordEndDate]
	AND [ETL_CreatedOn] <= @AsOfDate

RETURN

END

GO
