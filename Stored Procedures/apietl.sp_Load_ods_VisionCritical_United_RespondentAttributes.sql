SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [apietl].[sp_Load_ods_VisionCritical_United_RespondentAttributes]
AS 
MERGE ods.VisionCritical_United_RespondentAttributes AS target
USING
	(
	SELECT SSID_SurveyId ,
           SSID_RespondentId ,
           AttributeName ,
           AttributeKey ,
           AttributeValue 
		   FROM apietl.vw_RespondentAttributes_au
	) AS source
ON source.SSID_SurveyId = target.SSID_SurveyId AND source.SSID_RespondentId = target.SSID_RespondentId
WHEN MATCHED THEN
UPDATE SET target.AttributeName = source.AttributeName,
		   target.AttributeKey =  source.AttributeKey, 
		   target.AttributeValue = source.AttributeValue
WHEN NOT MATCHED THEN
INSERT
	(
           ETL_CreatedDate ,
           ETL_UpdatedDate ,
           SSID_SurveyId ,
           SSID_RespondentId ,
           AttributeName ,
           AttributeKey ,
           AttributeValue
	)
VALUES
	(
           GETDATE() ,
           GETDATE() ,
           source.SSID_SurveyId ,
           source.SSID_RespondentId ,
           source.AttributeName ,
           source.AttributeKey ,
           source.AttributeValue		
	);
GO
