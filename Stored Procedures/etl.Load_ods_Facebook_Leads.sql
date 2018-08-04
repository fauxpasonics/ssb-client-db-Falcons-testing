SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [etl].[Load_ods_Facebook_Leads]

AS 

BEGIN

BEGIN TRY 

DECLARE @RunTime DATETIME = GETDATE()

SELECT  CAST(NULL AS BINARY(32)) ETL_DeltaHashKey ,
        ETL_CreatedDate ,
        [id] ,
        [created_time] ,
        [ad_id] ,
        [ad_name] ,
        [adset_id] ,
        [adset_name] ,
        [campaign_id] ,
        [campaign_name] ,
        [form_id] ,
        [is_organic] ,
        [email] ,
        [full_name] ,
        [zip_code] ,
        [phone_number] ,
		[First_Name] ,
		[Last_Name]
INTO    #SrcData
FROM    ( SELECT    @RunTime ETL_CreatedDate ,
                    CAST(REPLACE(id, 'l:', '') AS NVARCHAR(200)) id ,
                    CAST(REPLACE(REPLACE(created_time, 'T', ' '), '-04:00', '') AS DATETIME) created_time ,
                    [ad_id] ,
                    [ad_name] ,
                    [adset_id] ,
                    [adset_name] ,
                    [campaign_id] ,
                    [campaign_name] ,
                    [form_id] ,
                    [is_organic] ,
                    [email] ,
                    [full_name] ,
                    [zip_code] ,
                    [phone_number] ,
					[First_Name] ,
					[Last_Name] ,
                    ROW_NUMBER() OVER ( ORDER BY email ) RowRank
          FROM      stg.[Facebook_Leads]
		  WHERE Processed = 0
        ) a;



UPDATE  #SrcData
SET     ETL_DeltaHashKey = HASHBYTES('sha2_256',
                                     ISNULL(RTRIM(id), 'DBNULL_TEXT')
                                     + ISNULL(RTRIM(created_time),
                                              'DBNULL_TEXT')
                                     + ISNULL(RTRIM(ad_id), 'DBNULL_TEXT')
                                     + ISNULL(RTRIM(ad_name), 'DBNULL_TEXT')
                                     + ISNULL(RTRIM(adset_id), 'DBNULL_TEXT')
                                     + ISNULL(RTRIM(adset_name), 'DBNULL_TEXT')
                                     + ISNULL(RTRIM(campaign_id),
                                              'DBNULL_TEXT')
                                     + ISNULL(RTRIM(campaign_name),
                                              'DBNULL_TEXT')
                                     + ISNULL(RTRIM(form_id), 'DBNULL_TEXT')
                                     + ISNULL(RTRIM(is_organic), 'DBNULL_TEXT')
                                     + ISNULL(RTRIM(email), 'DBNULL_TEXT')
                                     + ISNULL(RTRIM(full_name), 'DBNULL_TEXT')
                                     + ISNULL(RTRIM(zip_code), 'DBNULL_TEXT')
                                     + ISNULL(RTRIM(phone_number),
                                              'DBNULL_TEXT')
									 + ISNULL(RTRIM(first_Name), 'DBNULL_TEXT')
									 + ISNULL(RTRIM(Last_Name), 'DBNULL_TEXT'))

MERGE ods.Facebook_Leads AS myTarget
USING #SrcData AS mySource
	ON myTarget.id = mySource.id
	AND myTarget.email = mySource.email


WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 )

THEN UPDATE SET
	 myTarget.[ETL_UpdatedDate] = @RunTime
	,myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
	,myTarget.[id]			  = mySource.[id]
	,myTarget.[created_time]  = mySource.[created_time]  
	,myTarget.[ad_id]		  = mySource.[ad_id]		  
	,myTarget.[ad_name]		  = mySource.[ad_name]		  
	,myTarget.[adset_id]	  = mySource.[adset_id]	  
	,myTarget.[adset_name]	  = mySource.[adset_name]	  
	,myTarget.[campaign_id]	  = mySource.[campaign_id]	  
	,myTarget.[campaign_name] = mySource.[campaign_name] 
	,myTarget.[form_id]		  = mySource.[form_id]		  
	,myTarget.[is_organic]	  = mySource.[is_organic]	  
	,myTarget.[email]		  = mySource.[email]		  
	,myTarget.[full_name]	  = mySource.[full_name]	  
	,myTarget.[zip_code]	  = mySource.[zip_code]	  
	,myTarget.[phone_number]  = mySource.[phone_number] 
	,myTarget.[First_Name]	  = mySource.[First_Name]
	,myTarget.[Last_Name]	  = mySource.[Last_Name]

WHEN NOT MATCHED BY TARGET
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_DeltaHashKey]
     ,[id]
	 ,[created_time]  
	 ,[ad_id]		  
	 ,[ad_name]		  
	 ,[adset_id]	  
	 ,[adset_name]	  
	 ,[campaign_id]	  
	 ,[campaign_name] 
	 ,[form_id]		  
	 ,[is_organic]	  
	 ,[email]		  
	 ,[full_name]	  
	 ,[zip_code]	  
	 ,[phone_number]
	 ,[First_Name]
	 ,[Last_Name] )
	 VALUES
	 (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,mySource.[ETL_DeltaHashKey]	 
     ,mySource.[id]
     ,mySource.[created_time] 
     ,mySource.[ad_id]		 
     ,mySource.[ad_name]		 
	 ,mySource.[adset_id]	 
	 ,mySource.[adset_name]	 
	 ,mySource.[campaign_id]	 
	 ,mySource.[campaign_name]
	 ,mySource.[form_id]		 
	 ,mySource.[is_organic]	 
	 ,mySource.[email]		 
	 ,mySource.[full_name]	 
	 ,mySource.[zip_code]	 
	 ,mySource.[phone_number] 
	 ,mySource.[First_Name]
	 ,mySource.[Last_Name]
	 )
	 ;

UPDATE stg.Facebook_Leads
SET Processed = 1
WHERE id IN (SELECT id FROM #SrcData)


	 
END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH


END
GO
