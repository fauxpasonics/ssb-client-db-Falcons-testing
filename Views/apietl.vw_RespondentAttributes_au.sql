SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [apietl].[vw_RespondentAttributes_au]
AS
SELECT 
	respondents.multi_query_value_for_audit AS SSID_SurveyId,
	respondents.id AS SSID_RespondentId,
	question.[name] AS AttributeName,
	attr.[value] AS AttributeKey,
	ISNULL(answers.[text], attr.[value]) AS AttributeValue
FROM apietl.vc_au_records_0 respondents (NOLOCK)
INNER JOIN apietl.vc_au_records_values_1 attr (NOLOCK)
	ON  respondents.vc_au_records_id = attr.vc_au_records_id
INNER JOIN apietl.vc_au_concepts_column_1 col  (NOLOCK)
	ON  attr.columnId = col.id
INNER JOIN apietl.vc_au_concepts_0 question (NOLOCK)
	ON  col.vc_au_concepts_id = question.vc_au_concepts_id
LEFT OUTER JOIN apietl.vc_au_concepts_extraData_1 colData (NOLOCK)
	ON  col.vc_au_concepts_id = colData.vc_au_concepts_id
LEFT JOIN apietl.vc_au_concepts_extraData_choices_2 answers (NOLOCK)
	ON  colData.vc_au_concepts_extraData_id = answers.vc_au_concepts_extraData_id
	AND attr.[value] = answers.id
WHERE ((answers.[text] IS NOT NULL AND answers.[text] <> '') OR (attr.[value] IS NOT NULL AND attr.[value] <> ''))
	--AND respondents.id = '05e18611-0000-0000-c97f-1cdd27000000'

GO
