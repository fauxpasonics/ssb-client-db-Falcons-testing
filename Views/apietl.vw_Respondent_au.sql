SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [apietl].[vw_Respondent_au]
AS
SELECT 
	ra.SSID_SurveyId,
	ra.SSID_RespondentId,
	MAX(CASE WHEN ra.AttributeName = 'Email_Address' THEN ra.AttributeValue END) AS EmailAddress,
	MAX(CASE WHEN ra.AttributeName = 'First_Name' THEN ra.AttributeValue END) AS First_Name,
	MAX(CASE WHEN ra.AttributeName = 'Last_Name' THEN ra.AttributeValue END) AS Last_Name,
	MAX(CASE WHEN ra.AttributeName = 'MemberId' THEN ra.AttributeValue END) AS MemberId,
	MAX(CASE WHEN ra.AttributeName = 'ZIP_Code' THEN ra.AttributeValue END) AS Zip_Code,
	MAX(CASE WHEN ra.AttributeName = 'Q_GATE' THEN ra.AttributeValue END) AS Gate,
	MAX(CASE WHEN ra.AttributeName = 'Q_SEAT_LEVEL' THEN ra.AttributeValue END) AS Seat_Level,
	MAX(CASE WHEN ra.AttributeName = 'Q_SEAT_SECTION' THEN ra.AttributeValue END) AS Seat_Section,
	MAX(CASE WHEN ra.AttributeName = 'Q_GENDER' THEN ra.AttributeValue END) AS Gender,
	MAX(CASE WHEN ra.AttributeName = 'Race_gender' THEN ra.AttributeValue END) AS Race_Gender,
	MAX(CASE WHEN ra.AttributeName = 'Q_HOUSEHOLD_INCOME' THEN ra.AttributeValue END) AS Household_Income,
	MAX(CASE WHEN ra.AttributeName = 'Q_FAN_TENURE' THEN ra.AttributeValue END) AS Fan_Tenure,
	MAX(CASE WHEN ra.AttributeName = 'Q_MARITAL_STATUS' THEN ra.AttributeValue END) AS Marital_Status,
	MAX(CASE WHEN ra.AttributeName = 'AGE_ROLLUP' THEN ra.AttributeValue END) AS Age_Rollup
FROM apietl.vw_RespondentAttributes_au ra
GROUP BY
	ra.SSID_SurveyId,
	ra.SSID_RespondentId

GO
