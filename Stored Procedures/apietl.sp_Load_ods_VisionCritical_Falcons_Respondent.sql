SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [apietl].[sp_Load_ods_VisionCritical_Falcons_Respondent]
AS
MERGE ods.VisionCritical_Falcons_Respondent AS target
USING
	(
	SELECT SSID_SurveyId ,
           SSID_RespondentId ,
           EmailAddress ,
           First_Name ,
           Last_Name ,
           MemberId ,
           Zip_Code ,
           Gate ,
           Seat_Level ,
           Seat_Section ,
           Gender ,
           Race_Gender ,
           Household_Income ,
           Fan_Tenure ,
           Marital_Status ,
           Age_Rollup
		   FROM apietl.vw_Respondent
	) AS source
ON	source.SSID_SurveyId = target.SSID_SurveyId AND source.SSID_RespondentId = target.SSID_RespondentId
WHEN MATCHED THEN
UPDATE SET target.EmailAddress = source.EmailAddress
           ,target.First_Name = source.First_Name
           ,target.Last_Name = source.Last_Name
           ,target.MemberId = source.MemberId
           ,target.Zip_Code = source.Zip_Code
           ,target.Gate =source.Gate
           ,target.Seat_Level = source.Seat_Level
           ,target.Seat_Section = source.Seat_Section
           ,target.Gender = source.Gender
           ,target.Race_Gender = source.Race_Gender
           ,target.Household_Income = source.Household_Income
           ,target.Fan_Tenure = source.Fan_Tenure
           ,target.Marital_Status = source.Marital_Status
           ,target.Age_Rollup = source.Age_Rollup
WHEN NOT MATCHED THEN
INSERT
	(
           ETL_CreatedDate ,
           ETL_UpdatedDate ,
           SSID_SurveyId ,
           SSID_RespondentId ,
           EmailAddress ,
           First_Name ,
           Last_Name ,
           MemberId ,
           Zip_Code ,
           Gate ,
           Seat_Level ,
           Seat_Section ,
           Gender ,
           Race_Gender ,
           Household_Income ,
           Fan_Tenure ,
           Marital_Status ,
           Age_Rollup 
	)
VALUES
	(
           getdate(),
           getdate(),
           source.SSID_SurveyId ,
           source.SSID_RespondentId ,
           source.EmailAddress ,
           source.First_Name ,
           source.Last_Name ,
           source.MemberId ,
           source.Zip_Code ,
           source.Gate ,
           source.Seat_Level ,
           source.Seat_Section ,
           source.Gender ,
           source.Race_Gender ,
           source.Household_Income ,
           source.Fan_Tenure ,
           source.Marital_Status ,
           source.Age_Rollup 
	);
GO
