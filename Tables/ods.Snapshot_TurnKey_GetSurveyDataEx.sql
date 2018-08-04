CREATE TABLE [ods].[Snapshot_TurnKey_GetSurveyDataEx]
(
[TurnKey_GetSurveyDataExSK] [int] NOT NULL IDENTITY(1, 1),
[SurveyID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuestionID] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Response] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[recordid] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CreatedOn] [datetime] NULL,
[ETL_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_UpdatedOn] [datetime] NULL,
[ETL_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordEndDate] [datetime] NULL
)
GO
ALTER TABLE [ods].[Snapshot_TurnKey_GetSurveyDataEx] ADD CONSTRAINT [PK__Snapshot__26F179B26D37BBB2] PRIMARY KEY CLUSTERED  ([TurnKey_GetSurveyDataExSK])
GO
