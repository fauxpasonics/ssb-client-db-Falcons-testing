CREATE TABLE [ods].[TurnKey_GetParticipantDataEx]
(
[SurveyID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[recordid] [bigint] NOT NULL,
[started] [datetime] NULL,
[completed] [datetime] NULL,
[branched_out] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[over_quota] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[modified] [datetime] NULL,
[campaign_status] [int] NULL,
[culture] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[http_referer] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[http_user_agent] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[remote_addr] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[remote_host] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Participant_last_page] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Participant_url] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Participant_last_page_number] [int] NULL,
[Participant_modifier] [int] NULL,
[Participant_device_type] [int] NULL,
[Participant_ua_family] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Participant_ua_majorver] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Participant_os_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Participant_os_family] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Participant_iploc_long] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Participant_iploc_lat] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Participant_iploc_city] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Participant_iploc_state] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Participant_iploc_country] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Participant_iploc_zipcode] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CreatedOn] [datetime] NOT NULL CONSTRAINT [DF__TurnKey_G__ETL_C__41F5BC2B] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[ETL_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__TurnKey_G__ETL_C__42E9E064] DEFAULT (suser_sname()),
[ETL_UpdatedOn] [datetime] NOT NULL CONSTRAINT [DF__TurnKey_G__ETL_U__43DE049D] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[ETL_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__TurnKey_G__ETL_U__44D228D6] DEFAULT (suser_sname())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----------- CREATE TRIGGER -----------
CREATE TRIGGER [ods].[Snapshot_TurnKey_GetParticipantDataExUpdate] ON [ods].[TurnKey_GetParticipantDataEx]
AFTER UPDATE, DELETE

AS
BEGIN

DECLARE @ETL_UpdatedOn DATETIME = (SELECT [etl].[ConvertToLocalTime](CAST(GETDATE() AS DATETIME2(0))))
DECLARE @ETL_UpdatedBy NVARCHAR(400) = (SELECT SYSTEM_USER)

UPDATE t SET
[ETL_UpdatedOn] = @ETL_UpdatedOn
,[ETL_UpdatedBy] = @ETL_UpdatedBy
FROM [ods].[TurnKey_GetParticipantDataEx] t
	JOIN inserted i ON  t.[SurveyID] = i.[SurveyID] AND t.[recordid] = i.[recordid]

INSERT INTO [ods].[Snapshot_TurnKey_GetParticipantDataEx] ([SurveyID],[recordid],[started],[completed],[branched_out],[over_quota],[modified],[campaign_status],[culture],[http_referer],[http_user_agent],[remote_addr],[remote_host],[Participant_last_page],[Participant_url],[Participant_last_page_number],[Participant_modifier],[Participant_device_type],[Participant_ua_family],[Participant_ua_majorver],[Participant_os_name],[Participant_os_family],[Participant_iploc_long],[Participant_iploc_lat],[Participant_iploc_city],[Participant_iploc_state],[Participant_iploc_country],[Participant_iploc_zipcode],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy],[RecordEndDate])
SELECT a.*,dateadd(s,-1,@ETL_UpdatedOn)
FROM deleted a

END

GO
ALTER TABLE [ods].[TurnKey_GetParticipantDataEx] ADD CONSTRAINT [PK__TurnKey___D8CA5ED6EF2EA6D7] PRIMARY KEY CLUSTERED  ([SurveyID], [recordid])
GO
