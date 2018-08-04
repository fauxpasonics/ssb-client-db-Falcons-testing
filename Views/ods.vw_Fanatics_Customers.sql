SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [ods].[vw_Fanatics_Customers]
AS

WITH CTE_Base (SourceDB,Client_ID,Client_First_Name,Client_Last_Name,Client_Email
			   ,ShipAddress1,ShipAddress2,ShipAddressCity,ShipAddressState
			   ,ShipAddressZip,ShipAddressCounty,BillAddress1,BillAddress2,BillAddressCity
			   ,BillAddressState,BillAddressZip,BilAddressCountry,ShipAddressTel,OrderDate
			   ,ETL_CreatedDate,ETL_UpdatedDate,ETL_IsDeleted,NewRank,OldRank)
AS (
	SELECT  CASE WHEN ETL_FileName LIKE 'NFL_Falcons%' THEN 'Falcons' WHEN ETL_FileName LIKE 'MLS_United%' THEN 'United' END AS SourceDB
		  , Client_ID                                                                                                                                                                                      
		  , Client_First_Name                                                                                                                                                                  
		  , Client_Last_Name  
		  , Client_Email
		  , ShipAddress1                                                                                                                                                                              
		  , ShipAddress2
		  , ShipAddressCity                                                                              
		  , ShipAddressState	                                                                         
		  , ShipAddressZip                                                                               
		  , ShipAddressCounty                                                                            			
		  , BillAddress1
		  , BillAddress2
		  , BillAddressCity                                                                              
		  , BillAddressState                                                                             
		  , BillAddressZip                                                                               
		  , BilAddressCountry                                                                            
		  , ShipAddressTel                                                                     
		  , OrderDate                                                            
		  , ETL_CreatedDate                                                                              
		  , ETL_UpdatedDate                                                                              
		  , ETL_IsDeleted    
		  , RANK() OVER(PARTITION BY Client_ID ORDER BY OrderDate DESC, NEWID()) AS NewRank
		  , RANK() OVER(PARTITION BY Client_ID ORDER BY OrderDate, NEWID() )	  AS OldRank
	FROM ods.Fanatics_Orders 
	)

SELECT newest.SourceDB
	  ,newest.Client_ID           
	  ,newest.Client_First_Name   
	  ,newest.Client_Last_Name  
	  ,newest.Client_Email
	  ,newest.ShipAddress1                                                                                                                                                                              
	  ,newest.ShipAddress2	    
	  ,newest.ShipAddressCity     
	  ,newest.ShipAddressState	
	  ,newest.ShipAddressZip      
	  ,newest.ShipAddressCounty   
	  ,newest.BillAddress1
	  ,newest.BillAddress2
	  ,newest.BillAddressCity     
	  ,newest.BillAddressState    
	  ,newest.BillAddressZip      
	  ,newest.BilAddressCountry   
	  ,newest.ShipAddressTel      
	  ,TRY_CAST(oldest.OrderDate  AS DATETIME)		SSCreatedDate     
	  ,TRY_CAST(newest.OrderDate  AS DATETIME)		SSUpdatedDate
	  ,TRY_CAST(oldest.ETL_CreatedDate AS DATETIME) ETL_CreatedDate
	  ,TRY_CAST(newest.ETL_UpdatedDate AS DATETIME)	ETL_UpdatedDate
	  ,newest.ETL_IsDeleted    
FROM CTE_Base newest
	JOIN cte_base oldest ON oldest.Client_ID = newest.Client_ID
WHERE newest.NewRank = 1
	  AND oldest.OldRank = 1


GO
