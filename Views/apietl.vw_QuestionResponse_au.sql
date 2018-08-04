SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [apietl].[vw_QuestionResponse_au]
AS 
SELECT
	am.SurveyId AS SSID_SurveyId,
	responses.RespondentId AS SSID_RespondentId,
	responses.dataTimestamp AS ResponseCompletionTime,
	am.QuestionId AS SSID_QuestionId,
	am.SubQuestionId AS SSID_SubQuestionId,
	am.ResponseId AS SSID_ResponseId,
	am.Response,
	am.scaleValue,
	am.preCode
FROM apietl.vw_VisionCritical_AnswerMap_au am
INNER JOIN (
		SELECT DISTINCT
			respondents.id AS RespondentId,
			TRY_CAST(CASE WHEN respondents.dataTimestamp <> '' THEN respondents.dataTimestamp END AS DATETIME) AS dataTimestamp,
			ISNULL(responses.[value], responseValues.[value]) AS ResponseId
		FROM apietl.vc_au_records_0 respondents (NOLOCK)
		INNER JOIN apietl.vc_au_records_values_1 responses (NOLOCK)
			ON  respondents.vc_au_records_id = responses.vc_au_records_id
		LEFT OUTER JOIN apietl.vc_au_records_values_value responseValues (NOLOCK)
			ON  responses.vc_au_records_values_id = responseValues.vc_au_records_values_id
	) responses
	ON  am.ResponseId = responses.ResponseId
GO
