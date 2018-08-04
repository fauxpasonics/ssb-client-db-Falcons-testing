SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [preods].[TurnKey_GetSurveyInformation]
AS

WITH Level1 (SurveyId, Question_Heading,Question_Class,Question_Column, Question_Choice_Id, Question_Choice_Specify)
AS
(SELECT  [ETL__multi_query_value_for_audit] [SurveyID]
	,CONVERT(NVARCHAR(100),[L3_AllData_Question_heading]) [Question_heading]
	,CONVERT(NVARCHAR(100),[L3_AllData_Question_class]) [Question_class]
	,CONVERT(NVARCHAR(100),[L3_AllData_Question_column]) [Question_column]
	,CONVERT(NVARCHAR(100),[L4_AllData_Question_Choice_id]) [Question_Choice_id]
	,CONVERT(NVARCHAR(100),[L4_AllData_Question_Choice_specify]) [Question_Choice_specify]
FROM [src].[TurnKey_GetSurveyInformation] WITH (NOLOCK)),
level2 (SurveyID, Question_Heading, Question_Class, Question_Option_Id, Question_Option_Column, Question_Option_Type)
AS
(SELECT [ETL__multi_query_value_for_audit] [SurveyID]
	,CONVERT(NVARCHAR(100),[L3_AllData_Question_heading]) [Question_heading]
	,CONVERT(NVARCHAR(100),[L3_AllData_Question_class]) [Question_class]
	,CONVERT(NVARCHAR(100),[L4_AllData_Question_Option_id]) [Question_Option_id]
	,CONVERT(NVARCHAR(100),[L4_AllData_Question_Option_column]) [Question_Option_column]
	,CONVERT(NVARCHAR(100),[L4_AllData_Question_Option_type]) [Question_Option_type]
	FROM [src].[TurnKey_GetSurveyInformation] WITH (NOLOCK)),
level3 (SurveyID, Question_Heading, Question_Class, Question_Side_Id, Question_Side_Class, Question_Side_Topic_Id, Question_Side_Topic_Column)
AS
(SELECT [ETL__multi_query_value_for_audit] [SurveyID]
	,CONVERT(NVARCHAR(100),[L3_AllData_Question_heading]) [Question_heading]
	,CONVERT(NVARCHAR(100),[L3_AllData_Question_class]) [Question_class]
	,CONVERT(NVARCHAR(100),[L4_AllData_Question_Side_id]) [Question_Side_id]
	,CONVERT(NVARCHAR(100),[L4_AllData_Question_Side_class]) [Question_Side_class]
	,CONVERT(NVARCHAR(100),[L6_AllData_Question_Side_Topic_id]) [Question_Side_Topic_id]
	,CONVERT(NVARCHAR(100),[L6_AllData_Question_Side_Topic_column]) [Question_Side_Topic_column]
	FROM [src].[TurnKey_GetSurveyInformation] WITH (NOLOCK)),
level4 (SurveyID, Question_Heading, Question_Class,Question_Option_Id, Question_Option_Column, Question_Option_Type)
AS
(SELECT [ETL__multi_query_value_for_audit] [SurveyID]
	,CONVERT(NVARCHAR(100),[L3_AllData_Question_heading]) [Question_heading]
	,CONVERT(NVARCHAR(100),[L3_AllData_Question_class]) [Question_class]
	,CONVERT(NVARCHAR(100),[L5_AllData_Question_Option_id]) [Question_Option_id]
	,CONVERT(NVARCHAR(100),[L5_AllData_Question_Option_column]) [Question_Option_column]
	,CONVERT(NVARCHAR(100),[L5_AllData_Question_Option_type]) [Question_Option_type]
	FROM [src].[TurnKey_GetSurveyInformation] WITH (NOLOCK)),
level5 (SurveyId, Question_Heading,Question_Class,Question_Column, Question_Choice_Id, Question_Choice_Specify)
AS
(SELECT  [ETL__multi_query_value_for_audit] [SurveyID]
	,CONVERT(NVARCHAR(100),[L3_AllData_Question_heading]) [Question_heading]
	,CONVERT(NVARCHAR(100),[L3_AllData_Question_class]) [Question_class]
	,CONVERT(NVARCHAR(100),[L5_AllData_Question_Choice_id]) [Question_Choice_id]
	,CONVERT(NVARCHAR(100),[L5_AllData_Question_Choice_column]) [Question_Choice_column]
	,CONVERT(NVARCHAR(100),[L5_AllData_Question_Choice_specify]) [Question_Choice_specify]
	FROM [src].[TurnKey_GetSurveyInformation] WITH (NOLOCK))
SELECT DISTINCT l1.SurveyId [SurveyID_K]
    , l1.Question_Heading [Question_Heading_K]
	, l1.Question_Class [Question_Class_K]
	, l1.Question_Column [Question_Column_K]
	, l1.Question_Choice_Id [Question_Choice_Id]
	, l1.Question_Choice_Specify
	FROM Level1 l1
	WHERE l1.Question_Column IS NOT NULL
UNION
SELECT DISTINCT level2.SurveyID
	, level2.Question_Heading
	, level2.Question_Class
	, level2.Question_Option_Column
	, level2.Question_Option_Id 
	,level2.Question_Option_Type
FROM level2
	WHERE level2.Question_Option_Column IS NOT NULL
UNION
SELECT DISTINCT level3.SurveyID
	, level3.Question_Heading
	, level3.Question_Class
	, level3.Question_Side_Topic_Column
	, level3.Question_Side_Topic_Id
	, level3.Question_Side_Class
	FROM level3
	WHERE level3.Question_Side_Topic_Column IS NOT NULL
UNION
SELECT DISTINCT level4.SurveyID
	, level4.Question_Heading
	, level4.Question_Class
	, level4.Question_Option_Column
	, level4.Question_Option_Id
	, level4.Question_Option_Type
	FROM level4
	WHERE level4.Question_Option_Column IS NOT NULL
UNION
SELECT DISTINCT level5.SurveyId
	, level5.Question_Heading
	, level5.Question_Class
	, level5.Question_Column
	, level5.Question_Choice_Id
	, level5.Question_Choice_Specify
	FROM level5
	WHERE level5.Question_Column IS NOT NULL

GO
