SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [apietl].[sp_Load_VisionCritical_Falcons_SurveyResponses]
AS
DECLARE @RunTime DATETIME= GETDATE();

--IF OBJECT_ID('tempdb..#Source') IS NOT NULL
--	DROP TABLE #Source
--CREATE TABLE #Source (
--	session_id VARCHAR(250),
--	survey_id VARCHAR(250),
--	Survey_Name VARCHAR(1000),
--	response_id VARCHAR(250),
--	QuestionName VARCHAR(250),
--	questionType VARCHAR(250),
--	QuestionText NVARCHAR(MAX),
--	ResponseValue NVARCHAR(MAX),
--	ResponseValue2 NVARCHAR(MAX),
--	SingleChoiceText NVARCHAR(MAX),
--	MultiChoiceText NVARCHAR(MAX),
--	dataTimestamp DATETIME,
--	ETL__DeltaHashkey BINARY(32)
--);
--INSERT INTO #Source (
--	session_id,
--    survey_id,
--    Survey_Name,
--    response_id,
--    QuestionName,
--    questionType,
--    QuestionText,
--    ResponseValue,
--    ResponseValue2,
--    SingleChoiceText,
--    MultiChoiceText,
--    dataTimestamp,
--	ETL__DeltaHashkey
--)
--SELECT  
--	session_id,
--	survey_id,
--	Survey_Name,
--	response_id,
--	QuestionName,
--	questionType,
--	QuestionText,
--	ResponseValue,
--	ResponseValue2,
--	SingleChoiceText,
--	MultiChoiceText,
--	dataTimestamp,
--	ETL__DeltaHashkey
--FROM apietl.vw_Load_VisionCritical_Falcons_SurveyResponse;

--UPDATE #Source
--SET ETL__DeltaHashkey = HASHBYTES('sha2_256',
--							  ISNULL(RTRIM(response_id), 'DBNULL_TEXT')
--							+ COALESCE((RTRIM(QuestionName), RTRIM(QuestionText), 'DBNULL_TEXT')
--							+ ISNULL(RTRIM(questionType), 'DBNULL_TEXT')
--							+ COALESCE(RTRIM(ResponseValue), RTRIM(ResponseValue2), 'DBNULL_TEXT')
--							+ ISNULL(RTRIM(SingleChoiceText), 'DBNULL_TEXT')
--							+ ISNULL(RTRIM(MultiChoiceText), 'DBNULL_TEXT')
--						);

						--DATALENGTH(
						--	HASHBYTES('sha2_256',
						--		  ISNULL(RTRIM(session_id), 'DBNULL_TEXT')
						--		+ ISNULL(RTRIM(survey_id), 'DBNULL_TEXT')
						--		+ ISNULL(RTRIM(Survey_Name), 'DBNULL_TEXT')
						--		+ ISNULL(RTRIM(response_id), 'DBNULL_TEXT')
						--		+ ISNULL(RTRIM(QuestionName), 'DBNULL_TEXT')
						--		+ ISNULL(RTRIM(questionType), 'DBNULL_TEXT')
						--		+ ISNULL(RTRIM(QuestionText), 'DBNULL_TEXT')
						--		+ ISNULL(RTRIM(ResponseValue), 'DBNULL_TEXT') -- This is the issue
						--		+ ISNULL(RTRIM(ResponseValue2), 'DBNULL_TEXT')
						--		+ ISNULL(RTRIM(SingleChoiceText), 'DBNULL_TEXT')
						--		+ ISNULL(RTRIM(MultiChoiceText), 'DBNULL_TEXT')
						--	)
						--);
       
--TRUNCATE TABLE ods.VisionCritical_Falcons_SurveyResponses
MERGE ods.VisionCritical_Falcons_SurveyResponses AS myTarget
USING apietl.vw_Load_VisionCritical_Falcons_SurveyResponse as mySource --#Source AS mySource
	ON  mySource.session_id = myTarget.session_id
	AND mySource.survey_id = myTarget.survey_id
	AND mySource.response_id = myTarget.response_id
	AND mySource.question_id = myTarget.question_id
	AND mySource.QuestionName = myTarget.QuestionName
	--AND mySource.ResponseValue = myTarget.ResponseValue
	--AND mySource.ResponseValue2 = myTarget.ResponseValue2
	--AND mySource.dataTimestamp = myTarget.datatimestamp
WHEN MATCHED 
	AND (ISNULL(mySource.ETL__DeltaHashkey, CONVERT(BINARY(32),'')) <> ISNULL(myTarget.ETL__DeltaHashkey, CONVERT(BINARY(32),'')))
THEN
    UPDATE
	SET myTarget.session_id = mySource.session_id,
        myTarget.survey_id = mySource.survey_id,
        myTarget.Survey_Name = mySource.Survey_Name,
        myTarget.response_id = mySource.response_id,
		myTarget.question_id = mySource.question_id,
        myTarget.QuestionName = mySource.QuestionName,
        myTarget.questionType = mySource.questionType,
        myTarget.QuestionText = mySource.QuestionText,
        myTarget.ResponseValue = mySource.ResponseValue,
        myTarget.ResponseValue2 = mySource.ResponseValue2,
        myTarget.SingleChoiceText = mySource.SingleChoiceText,
        myTarget.MultiChoiceText = mySource.MultiChoiceText,
        myTarget.datatimestamp = mySource.dataTimestamp,
        myTarget.ETL__UpdatedDate = @RunTime,
        myTarget.ETL__DeltaHashkey = mySource.ETL__DeltaHashkey
WHEN NOT MATCHED BY TARGET 
THEN
    INSERT (
		session_id,
        survey_id,
        Survey_Name,
        response_id,
		question_id,
        QuestionName,
        questionType,
        QuestionText,
        ResponseValue,
        ResponseValue2,
        SingleChoiceText,
        MultiChoiceText,
        datatimestamp,
        ETL__CreatedDate,
        ETL__UpdatedDate,
        ETL__DeltaHashkey
    )
    VALUES (
		mySource.session_id,
        mySource.survey_id,
        mySource.Survey_Name,
        mySource.response_id,
		mySource.question_id,
        mySource.QuestionName,
        mySource.questionType,
        mySource.QuestionText,
        mySource.ResponseValue,
        mySource.ResponseValue2,
        mySource.SingleChoiceText,
        mySource.MultiChoiceText,
        mySource.dataTimestamp,
        @RunTime,
        @RunTime,
        mySource.ETL__DeltaHashkey
    );
GO
