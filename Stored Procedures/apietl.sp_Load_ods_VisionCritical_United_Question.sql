SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [apietl].[sp_Load_ods_VisionCritical_United_Question]
AS 
MERGE ods.VisionCritical_United_Question AS target
USING
	(
	SELECT SSID_SurveyId ,
       SSID_QuestionId ,
       Question ,
       SSID_SubQuestionId ,
       SubQuestion ,
       questionType ,
       QuestionOrderId ,
       SubQuestionOrderId FROM apietl.vw_Question_au
	) AS source
ON source.SSID_SurveyId = target.SSID_SurveyId AND source.SSID_QuestionId = target.SSID_QuestionId AND source.SSID_SubQuestionId = target.SSID_SubQuestionId
WHEN MATCHED THEN
UPDATE SET target.Question = source.Question
		  , target.SubQuestion = source.SubQuestion
		  , target.questionType = source.questionType
		  , target.QuestionOrderId = source.QuestionOrderId
		  , target.SubQuestionOrderId = source.SubQuestionOrderId
WHEN NOT MATCHED THEN
INSERT
	(
           ETL_CreatedDate ,
           ETL_UpdatedDate ,
           SSID_SurveyId ,
           SSID_QuestionId ,
           Question ,
           SSID_SubQuestionId ,
           SubQuestion ,
           questionType ,
           QuestionOrderId ,
           SubQuestionOrderId
	)
VALUES
	(
           getdate() ,
           getdate() ,
           source.SSID_SurveyId ,
           source.SSID_QuestionId ,
           source.Question ,
           source.SSID_SubQuestionId ,
           source.SubQuestion ,
           source.questionType ,
           source.QuestionOrderId ,
           source.SubQuestionOrderId
	); 
GO
