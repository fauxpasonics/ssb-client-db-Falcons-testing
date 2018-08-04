SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
-- Get the status of your table 20 minutes ago...
DECLARE @AsOfDate DATETIME = (SELECT [etl].[ConvertToLocalTime](DATEADD(MINUTE,-20,GETDATE())))
SELECT * FROM [ods].[AsOf_TurnKey_GetSurveyInformation] (@AsOfDate)
*/

CREATE FUNCTION [ods].[AsOf_TurnKey_GetSurveyInformation] (@AsOfDate DATETIME)

RETURNS @Results TABLE
(
[SurveyID] [nvarchar](max) NULL,
[Question_Heading] [nvarchar](100) NULL,
[Question_Class] [nvarchar](100) NULL,
[Question_Column] [nvarchar](100) NULL,
[Question_Choice_Id] [nvarchar](100) NULL,
[Question_Choice_Specify] [nvarchar](100) NULL,
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
SELECT [SurveyID],[Question_Heading],[Question_Class],[Question_Column],[Question_Choice_Id],[Question_Choice_Specify],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy]
FROM
	(
	SELECT [SurveyID],[Question_Heading],[Question_Class],[Question_Column],[Question_Choice_Id],[Question_Choice_Specify],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy],@EndDate [RecordEndDate]
	FROM [ods].[TurnKey_GetSurveyInformation] t
	UNION ALL
	SELECT [SurveyID],[Question_Heading],[Question_Class],[Question_Column],[Question_Choice_Id],[Question_Choice_Specify],[ETL_CreatedOn],[ETL_CreatedBy],[ETL_UpdatedOn],[ETL_UpdatedBy],[RecordEndDate]
	FROM [ods].[Snapshot_TurnKey_GetSurveyInformation]
	) a
WHERE
	@AsOfDate BETWEEN [ETL_UpdatedOn] AND [RecordEndDate]
	AND [ETL_CreatedOn] <= @AsOfDate

RETURN

END

GO
