SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [stg].[Facebook_Leads_Process]  
    @DataTable [stg].[Facebook_Leads_Type] READONLY  
AS  
BEGIN  
  
	DECLARE @finalXml  XML  
  
	BEGIN TRY  
  
		DECLARE @recordCount INT  
		SELECT @recordCount = COUNT(*)  
			FROM @DataTable  
			  
		INSERT INTO [stg].[Facebook_Leads] 
		([SessionId], [DynamicData], [id], [created_time], [ad_id], [ad_name], [adset_id], [adset_name], [campaign_id], [campaign_name],
		[form_id], [is_organic], [email], [first_name], [last_name], [full_name], [zip_code], [phone_number])
		SELECT [SessionId], [DynamicData], [id], [created_time], [ad_id], [ad_name], [adset_id], [adset_name], [campaign_id], [campaign_name],
		[form_id], [is_organic], [email], [first_name], [last_name], [full_name], [zip_code], [phone_number]  
		FROM @DataTable  
		  
		SET @finalXml = '<Root><ResponseInfo><Success>true</Success><RecordsInserted>' + CAST(@recordCount AS NVARCHAR(10)) + '</RecordsInserted></ResponseInfo></Root>'  
  
	END TRY  
  
  
	BEGIN CATCH  
	  
		-- TODO: Better error messaging here  
		SET @finalXml = '<Root><ResponseInfo><Success>false</Success><ErrorMessage>There was an error attempting to upload this data.</ErrorMessage></ResponseInfo></Root>'  
  
	END CATCH  
  
  
	-- Return response  
	SELECT CAST(@finalXml AS XML)  
  
END  
  



GO
