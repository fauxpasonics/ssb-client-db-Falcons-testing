SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [apietl].[sp_Load_ods_VisionCritical_United_QuestionResponse]
AS 
MERGE ods.VisionCritical_United_QuestionResponse AS target
USING
	(
	SELECT SSID_SurveyId ,
           SSID_RespondentId ,
           ResponseCompletionTime ,
           SSID_QuestionId ,
           SSID_SubQuestionId ,
           SSID_ResponseId ,
           Response ,
           scaleValue ,
           preCode FROM apietl.vw_QuestionResponse_au
	) AS source
ON source.SSID_SurveyId = target.SSID_SurveyId
	AND source.SSID_RespondentId = target.SSID_RespondentId
	AND source.SSID_QuestionId = target.SSID_QuestionId
	AND source.SSID_SubQuestionId = target.SSID_SubQuestionId
	AND source.SSID_ResponseId = target.SSID_ResponseId
WHEN MATCHED THEN
UPDATE SET target.ResponseCompletionTime = source.ResponseCompletionTime
			, target.Response = source.Response
			, target.scaleValue = source.scaleValue
			, target.preCode = source.preCode
WHEN NOT MATCHED THEN
INSERT
	(
           ETL_CreatedDate ,
           ETL_UpdatedDate ,
           SSID_SurveyId ,
           SSID_RespondentId ,
           ResponseCompletionTime ,
           SSID_QuestionId ,
           SSID_SubQuestionId ,
           SSID_ResponseId ,
           Response ,
           scaleValue ,
           preCode
	)
VALUES
	(
           getdate() ,
           getdate() ,
           source.SSID_SurveyId ,
           source.SSID_RespondentId ,
           source.ResponseCompletionTime ,
           source.SSID_QuestionId ,
           source.SSID_SubQuestionId ,
           source.SSID_ResponseId ,
           source.Response ,
           source.scaleValue ,
           source.preCode
	);
GO
