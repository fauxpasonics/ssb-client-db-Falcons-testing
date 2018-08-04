CREATE TABLE [ods].[Snapshot_TurnKey_GetSurveyInformation]
(
[TurnKey_GetSurveyInformationSK] [int] NOT NULL IDENTITY(1, 1),
[SurveyID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_Heading] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_Class] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_Column] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_Choice_Id] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_Choice_Specify] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CreatedOn] [datetime] NULL,
[ETL_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_UpdatedOn] [datetime] NULL,
[ETL_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordEndDate] [datetime] NULL
)
GO
ALTER TABLE [ods].[Snapshot_TurnKey_GetSurveyInformation] ADD CONSTRAINT [PK__Snapshot__448F8AE974A48C15] PRIMARY KEY CLUSTERED  ([TurnKey_GetSurveyInformationSK])
GO
