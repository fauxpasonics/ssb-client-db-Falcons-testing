SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [preods].[TurnKey_GetSurveyDataEx]
AS

SELECT DISTINCT
	CONVERT(NVARCHAR(50),[ETL__multi_query_value_for_audit]) [SurveyID_K]
	,CONVERT(NVARCHAR(20),REPLACE([1_Key],'AllData_Table1_','')) [QuestionID_K]
	,CONVERT(NVARCHAR(MAX),[1_Value]) [Response]
	,CONVERT(NVARCHAR(50),[L3_AllData_Table1_recordid]) [recordid_K]
FROM [src].[TurnKey_GetSurveyDataEx] WITH (NOLOCK)

GO
