SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [apietl].[sp_Load_ods_VisionCritical_United_Survey]
AS 
MERGE ods.VisionCritical_United_Survey AS target 
USING
	(
	SELECT SSID_SurveyId ,
           SurveyName 
	FROM apietl.vw_Survey_au
	) AS source
ON (source.SSID_SurveyId = target.SSID_SurveyID)
WHEN MATCHED THEN
UPDATE SET target.SurveyName = source.SurveyName 
WHEN NOT MATCHED THEN
INSERT
	(
	 ETL_CreatedDate
	, ETL_UpdatedDate
	, SSID_SurveyID
	, SurveyName
	)
VALUES
	(
	GETDATE()
	, GETDATE()
	, source.SSID_SurveyId
	, source.SurveyName
	);
GO
