SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [apietl].[vw_Question_au]
AS
SELECT DISTINCT
	am.SurveyId AS SSID_SurveyId,
	am.QuestionId AS SSID_QuestionId,
	am.Question,
	am.SubQuestionId AS SSID_SubQuestionId,
	am.SubQuestion,
	am.questionType,
	am.Parent_orderInParent AS QuestionOrderId,
	am.orderInParent AS SubQuestionOrderId
FROM apietl.vw_VisionCritical_AnswerMap_au am

GO
