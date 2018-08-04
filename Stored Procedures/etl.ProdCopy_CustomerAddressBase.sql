SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[ProdCopy_CustomerAddressBase]
(
	@BatchId INT = 0,
	@Options NVARCHAR(MAX) = null
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     dbo
Date:     12/16/2015
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName NVARCHAR(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM ProdCopyStg.CustomerAddressBase),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey, ETL_UpdatedDate, ETL_IsDeleted, ETL_DeletedDate, ParentId, CustomerAddressId, AddressNumber, ObjectTypeCode, AddressTypeCode, Name, PrimaryContactName, Line1, Line2, Line3, City, StateOrProvince, County, Country, PostOfficeBox, PostalCode, UTCOffset, FreightTermsCode, UPSZone, Latitude, Telephone1, Longitude, ShippingMethodCode, Telephone2, Telephone3, Fax, VersionNumber, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn, TimeZoneRuleVersionNumber, OverriddenCreatedOn, UTCConversionTimeZoneCode, ImportSequenceNumber, CreatedOnBehalfBy, TransactionCurrencyId, ExchangeRate, ModifiedOnBehalfBy, ParentIdTypeCode
INTO #SrcData
FROM ProdCopyStg.CustomerAddressBase

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),AddressNumber)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),AddressTypeCode)),'DBNULL_INT') + ISNULL(RTRIM(City),'DBNULL_TEXT') + ISNULL(RTRIM(Country),'DBNULL_TEXT') + ISNULL(RTRIM(County),'DBNULL_TEXT') + ISNULL(RTRIM(CreatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),CreatedOn)),'DBNULL_DATETIME') + ISNULL(RTRIM(CreatedOnBehalfBy),'DBNULL_TEXT') + ISNULL(RTRIM(CustomerAddressId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),ETL_DeletedDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(ETL_DeltaHashKey),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ETL_IsDeleted)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(25),ETL_UpdatedDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),ExchangeRate)),'DBNULL_NUMBER') + ISNULL(RTRIM(Fax),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),FreightTermsCode)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),ImportSequenceNumber)),'DBNULL_INT') + ISNULL(RTRIM(Latitude),'DBNULL_TEXT') + ISNULL(RTRIM(Line1),'DBNULL_TEXT') + ISNULL(RTRIM(Line2),'DBNULL_TEXT') + ISNULL(RTRIM(Line3),'DBNULL_TEXT') + ISNULL(RTRIM(Longitude),'DBNULL_TEXT') + ISNULL(RTRIM(ModifiedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),ModifiedOn)),'DBNULL_DATETIME') + ISNULL(RTRIM(ModifiedOnBehalfBy),'DBNULL_TEXT') + ISNULL(RTRIM(Name),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ObjectTypeCode)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(25),OverriddenCreatedOn)),'DBNULL_DATETIME') + ISNULL(RTRIM(ParentId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ParentIdTypeCode)),'DBNULL_INT') + ISNULL(RTRIM(PostalCode),'DBNULL_TEXT') + ISNULL(RTRIM(PostOfficeBox),'DBNULL_TEXT') + ISNULL(RTRIM(PrimaryContactName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ShippingMethodCode)),'DBNULL_INT') + ISNULL(RTRIM(StateOrProvince),'DBNULL_TEXT') + ISNULL(RTRIM(Telephone1),'DBNULL_TEXT') + ISNULL(RTRIM(Telephone2),'DBNULL_TEXT') + ISNULL(RTRIM(Telephone3),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),TimeZoneRuleVersionNumber)),'DBNULL_INT') + ISNULL(RTRIM(TransactionCurrencyId),'DBNULL_TEXT') + ISNULL(RTRIM(UPSZone),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),UTCConversionTimeZoneCode)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),UTCOffset)),'DBNULL_INT') + ISNULL(RTRIM(VersionNumber),'DBNULL_TEXT'))


CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (ParentId)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)



MERGE ProdCopy.CustomerAddressBase AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.CustomerAddressId = mySource.CustomerAddressId

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
      myTarget.[ETL_UpdatedDate] = @RunTime
     ,myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     ,myTarget.[ParentId] = mySource.[ParentId]
     ,myTarget.[CustomerAddressId] = mySource.[CustomerAddressId]
     ,myTarget.[AddressNumber] = mySource.[AddressNumber]
     ,myTarget.[ObjectTypeCode] = mySource.[ObjectTypeCode]
     ,myTarget.[AddressTypeCode] = mySource.[AddressTypeCode]
     ,myTarget.[Name] = mySource.[Name]
     ,myTarget.[PrimaryContactName] = mySource.[PrimaryContactName]
     ,myTarget.[Line1] = mySource.[Line1]
     ,myTarget.[Line2] = mySource.[Line2]
     ,myTarget.[Line3] = mySource.[Line3]
     ,myTarget.[City] = mySource.[City]
     ,myTarget.[StateOrProvince] = mySource.[StateOrProvince]
     ,myTarget.[County] = mySource.[County]
     ,myTarget.[Country] = mySource.[Country]
     ,myTarget.[PostOfficeBox] = mySource.[PostOfficeBox]
     ,myTarget.[PostalCode] = mySource.[PostalCode]
     ,myTarget.[UTCOffset] = mySource.[UTCOffset]
     ,myTarget.[FreightTermsCode] = mySource.[FreightTermsCode]
     ,myTarget.[UPSZone] = mySource.[UPSZone]
     ,myTarget.[Latitude] = mySource.[Latitude]
     ,myTarget.[Telephone1] = mySource.[Telephone1]
     ,myTarget.[Longitude] = mySource.[Longitude]
     ,myTarget.[ShippingMethodCode] = mySource.[ShippingMethodCode]
     ,myTarget.[Telephone2] = mySource.[Telephone2]
     ,myTarget.[Telephone3] = mySource.[Telephone3]
     ,myTarget.[Fax] = mySource.[Fax]
     ,myTarget.[VersionNumber] = mySource.[VersionNumber]
     ,myTarget.[CreatedBy] = mySource.[CreatedBy]
     ,myTarget.[CreatedOn] = mySource.[CreatedOn]
     ,myTarget.[ModifiedBy] = mySource.[ModifiedBy]
     ,myTarget.[ModifiedOn] = mySource.[ModifiedOn]
     ,myTarget.[TimeZoneRuleVersionNumber] = mySource.[TimeZoneRuleVersionNumber]
     ,myTarget.[OverriddenCreatedOn] = mySource.[OverriddenCreatedOn]
     ,myTarget.[UTCConversionTimeZoneCode] = mySource.[UTCConversionTimeZoneCode]
     ,myTarget.[ImportSequenceNumber] = mySource.[ImportSequenceNumber]
     ,myTarget.[CreatedOnBehalfBy] = mySource.[CreatedOnBehalfBy]
     ,myTarget.[TransactionCurrencyId] = mySource.[TransactionCurrencyId]
     ,myTarget.[ExchangeRate] = mySource.[ExchangeRate]
     ,myTarget.[ModifiedOnBehalfBy] = mySource.[ModifiedOnBehalfBy]
     ,myTarget.[ParentIdTypeCode] = mySource.[ParentIdTypeCode]
     
WHEN NOT MATCHED BY TARGET
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[ParentId]
     ,[CustomerAddressId]
     ,[AddressNumber]
     ,[ObjectTypeCode]
     ,[AddressTypeCode]
     ,[Name]
     ,[PrimaryContactName]
     ,[Line1]
     ,[Line2]
     ,[Line3]
     ,[City]
     ,[StateOrProvince]
     ,[County]
     ,[Country]
     ,[PostOfficeBox]
     ,[PostalCode]
     ,[UTCOffset]
     ,[FreightTermsCode]
     ,[UPSZone]
     ,[Latitude]
     ,[Telephone1]
     ,[Longitude]
     ,[ShippingMethodCode]
     ,[Telephone2]
     ,[Telephone3]
     ,[Fax]
     ,[VersionNumber]
     ,[CreatedBy]
     ,[CreatedOn]
     ,[ModifiedBy]
     ,[ModifiedOn]
     ,[TimeZoneRuleVersionNumber]
     ,[OverriddenCreatedOn]
     ,[UTCConversionTimeZoneCode]
     ,[ImportSequenceNumber]
     ,[CreatedOnBehalfBy]
     ,[TransactionCurrencyId]
     ,[ExchangeRate]
     ,[ModifiedOnBehalfBy]
     ,[ParentIdTypeCode]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[ParentId]
     ,mySource.[CustomerAddressId]
     ,mySource.[AddressNumber]
     ,mySource.[ObjectTypeCode]
     ,mySource.[AddressTypeCode]
     ,mySource.[Name]
     ,mySource.[PrimaryContactName]
     ,mySource.[Line1]
     ,mySource.[Line2]
     ,mySource.[Line3]
     ,mySource.[City]
     ,mySource.[StateOrProvince]
     ,mySource.[County]
     ,mySource.[Country]
     ,mySource.[PostOfficeBox]
     ,mySource.[PostalCode]
     ,mySource.[UTCOffset]
     ,mySource.[FreightTermsCode]
     ,mySource.[UPSZone]
     ,mySource.[Latitude]
     ,mySource.[Telephone1]
     ,mySource.[Longitude]
     ,mySource.[ShippingMethodCode]
     ,mySource.[Telephone2]
     ,mySource.[Telephone3]
     ,mySource.[Fax]
     ,mySource.[VersionNumber]
     ,mySource.[CreatedBy]
     ,mySource.[CreatedOn]
     ,mySource.[ModifiedBy]
     ,mySource.[ModifiedOn]
     ,mySource.[TimeZoneRuleVersionNumber]
     ,mySource.[OverriddenCreatedOn]
     ,mySource.[UTCConversionTimeZoneCode]
     ,mySource.[ImportSequenceNumber]
     ,mySource.[CreatedOnBehalfBy]
     ,mySource.[TransactionCurrencyId]
     ,mySource.[ExchangeRate]
     ,mySource.[ModifiedOnBehalfBy]
     ,mySource.[ParentIdTypeCode]
     )
;



DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ProdCopy.CustomerAddressBase WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ProdCopy.CustomerAddressBase WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	


END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH


END


GO
