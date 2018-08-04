SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [apietl].[vw_Survey]
AS
SELECT 
	survey.id AS SSID_SurveyId,
	survey.[name] AS SurveyName
FROM apietl.vc_af_datasets_0 survey
GO
