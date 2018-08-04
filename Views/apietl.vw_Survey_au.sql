SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [apietl].[vw_Survey_au]
AS
SELECT 
	survey.id AS SSID_SurveyId,
	survey.[name] AS SurveyName
FROM apietl.vc_au_datasets_0 survey

GO
