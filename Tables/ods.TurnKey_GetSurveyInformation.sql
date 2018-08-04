CREATE TABLE [ods].[TurnKey_GetSurveyInformation]
(
[SurveyID] [int] NOT NULL,
[Question_Heading] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Question_Class] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Question_Column] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Question_Choice_Id] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Question_Choice_Specify] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL_CreatedOn] [datetime] NOT NULL CONSTRAINT [DF__TurnKey_G__ETL_C__30B7B83E] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[ETL_CreatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__TurnKey_G__ETL_C__31ABDC77] DEFAULT (suser_sname()),
[ETL_UpdatedOn] [datetime] NOT NULL CONSTRAINT [DF__TurnKey_G__ETL_U__32A000B0] DEFAULT ([etl].[ConvertToLocalTime](CONVERT([datetime2](0),getdate(),(0)))),
[ETL_UpdatedBy] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__TurnKey_G__ETL_U__339424E9] DEFAULT (suser_sname())
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

----------- CREATE TRIGGER -----------
CREATE TRIGGER [ods].[Snapshot_TurnKey_GetSurveyInformationUpdate] ON [ods].[TurnKey_GetSurveyInformation]
AFTER UPDATE, DELETE

AS
BEGIN

DECLARE @ETL_UpdatedOn DATETIME = (SELECT [etl].[ConvertToLocalTime](CAST(GETDATE() AS DATETIME2(0))))
DECLARE @ETL_UpdatedBy NVARCHAR(400) = (SELECT SYSTEM_USER)

UPDATE t SET
[ETL_UpdatedOn] = @ETL_UpdatedOn
,[ETL_UpdatedBy] = @ETL_UpdatedBy
FROM [ods].[TurnKey_GetSurveyInformation] t
	JOIN inserted i ON  t.[SurveyID] = i.[SurveyID] AND t.[Question_Heading] = i.[Question_Heading] AND t.[Question_Class] = i.[Question_Class] AND t.[Question_Column] = i.[Question_Column]

INSERT INTO [ods].[Snapshot_TurnKey_GetSurveyInformation] ([SurveyID],[Question_Heading],[Question_Class],[Question_Column],[Question_Choice_Id],[Question_Choice_Specify],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy],[RecordEndDate])
SELECT a.*,dateadd(s,-1,@ETL_UpdatedOn)
FROM deleted a

END

GO
ALTER TABLE [ods].[TurnKey_GetSurveyInformation] ADD CONSTRAINT [PK__TurnKey___F61D6A247332D01D] PRIMARY KEY CLUSTERED  ([SurveyID], [Question_Heading], [Question_Class], [Question_Column])
GO
