CREATE TABLE [ods].[TurnKey_GetSurveyDataEx]
(
[SurveyID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QuestionID] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Response] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[recordid] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL_CreatedOn] [datetime] NOT NULL CONSTRAINT [DF__TurnKey_G__ETL_C__549190E2] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[ETL_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__TurnKey_G__ETL_C__5585B51B] DEFAULT (suser_sname()),
[ETL_UpdatedOn] [datetime] NOT NULL CONSTRAINT [DF__TurnKey_G__ETL_U__5679D954] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[ETL_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__TurnKey_G__ETL_U__576DFD8D] DEFAULT (suser_sname())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----------- CREATE TRIGGER -----------
CREATE TRIGGER [ods].[Snapshot_TurnKey_GetSurveyDataExUpdate] ON [ods].[TurnKey_GetSurveyDataEx]
AFTER UPDATE, DELETE

AS
BEGIN

DECLARE @ETL_UpdatedOn DATETIME = (SELECT [etl].[ConvertToLocalTime](CAST(GETDATE() AS DATETIME2(0))))
DECLARE @ETL_UpdatedBy NVARCHAR(400) = (SELECT SYSTEM_USER)

UPDATE t SET
[ETL_UpdatedOn] = @ETL_UpdatedOn
,[ETL_UpdatedBy] = @ETL_UpdatedBy
FROM [ods].[TurnKey_GetSurveyDataEx] t
	JOIN inserted i ON  t.[SurveyID] = i.[SurveyID] AND t.[QuestionID] = i.[QuestionID] AND t.[recordid] = i.[recordid]

INSERT INTO [ods].[Snapshot_TurnKey_GetSurveyDataEx] ([SurveyID],[QuestionID],[Response],[recordid],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy],[RecordEndDate])
SELECT a.*,dateadd(s,-1,@ETL_UpdatedOn)
FROM deleted a

END

GO
ALTER TABLE [ods].[TurnKey_GetSurveyDataEx] ADD CONSTRAINT [PK__TurnKey___C24C3D7143504A32] PRIMARY KEY CLUSTERED  ([SurveyID], [QuestionID], [recordid])
GO
