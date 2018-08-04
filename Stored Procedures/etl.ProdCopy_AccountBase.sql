SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[ProdCopy_AccountBase]
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
DECLARE @SrcRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM ProdCopyStg.AccountBase),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey, ETL_UpdatedDate, ETL_IsDeleted, ETL_DeletedDate, AccountId, AccountCategoryCode, TerritoryId, DefaultPriceLevelId, CustomerSizeCode, PreferredContactMethodCode, CustomerTypeCode, AccountRatingCode, IndustryCode, TerritoryCode, AccountClassificationCode, BusinessTypeCode, OwningBusinessUnit, OriginatingLeadId, PaymentTermsCode, ShippingMethodCode, PrimaryContactId, ParticipatesInWorkflow, Name, AccountNumber, Revenue, NumberOfEmployees, Description, SIC, OwnershipCode, MarketCap, SharesOutstanding, TickerSymbol, StockExchange, WebSiteURL, FtpSiteURL, EMailAddress1, EMailAddress2, EMailAddress3, DoNotPhone, DoNotFax, Telephone1, DoNotEMail, Telephone2, Fax, Telephone3, DoNotPostalMail, DoNotBulkEMail, DoNotBulkPostalMail, CreditLimit, CreditOnHold, IsPrivate, CreatedOn, CreatedBy, ModifiedOn, ModifiedBy, VersionNumber, ParentAccountId, Aging30, StateCode, Aging60, StatusCode, Aging90, PreferredAppointmentDayCode, PreferredSystemUserId, PreferredAppointmentTimeCode, Merged, DoNotSendMM, MasterId, LastUsedInCampaign, PreferredServiceId, PreferredEquipmentId, ExchangeRate, UTCConversionTimeZoneCode, OverriddenCreatedOn, TimeZoneRuleVersionNumber, ImportSequenceNumber, TransactionCurrencyId, CreditLimit_Base, Aging30_Base, Revenue_Base, Aging90_Base, MarketCap_Base, Aging60_Base, YomiName, OwnerId, ModifiedOnBehalfBy, CreatedOnBehalfBy, OwnerIdType
INTO #SrcData
FROM ProdCopyStg.AccountBase

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),AccountCategoryCode)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),AccountClassificationCode)),'DBNULL_INT') + ISNULL(RTRIM(AccountId),'DBNULL_TEXT') + ISNULL(RTRIM(AccountNumber),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),AccountRatingCode)),'DBNULL_INT') + ISNULL(RTRIM(Aging30),'DBNULL_TEXT') + ISNULL(RTRIM(Aging30_Base),'DBNULL_TEXT') + ISNULL(RTRIM(Aging60),'DBNULL_TEXT') + ISNULL(RTRIM(Aging60_Base),'DBNULL_TEXT') + ISNULL(RTRIM(Aging90),'DBNULL_TEXT') + ISNULL(RTRIM(Aging90_Base),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),BusinessTypeCode)),'DBNULL_INT') + ISNULL(RTRIM(CreatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),CreatedOn)),'DBNULL_DATETIME') + ISNULL(RTRIM(CreatedOnBehalfBy),'DBNULL_TEXT') + ISNULL(RTRIM(CreditLimit),'DBNULL_TEXT') + ISNULL(RTRIM(CreditLimit_Base),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),CreditOnHold)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),CustomerSizeCode)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),CustomerTypeCode)),'DBNULL_INT') + ISNULL(RTRIM(DefaultPriceLevelId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),DoNotBulkEMail)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),DoNotBulkPostalMail)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),DoNotEMail)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),DoNotFax)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),DoNotPhone)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),DoNotPostalMail)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),DoNotSendMM)),'DBNULL_BIT') + ISNULL(RTRIM(EMailAddress1),'DBNULL_TEXT') + ISNULL(RTRIM(EMailAddress2),'DBNULL_TEXT') + ISNULL(RTRIM(EMailAddress3),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),ETL_DeletedDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(ETL_DeltaHashKey),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ETL_IsDeleted)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(25),ETL_UpdatedDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),ExchangeRate)),'DBNULL_NUMBER') + ISNULL(RTRIM(Fax),'DBNULL_TEXT') + ISNULL(RTRIM(FtpSiteURL),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ImportSequenceNumber)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),IndustryCode)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),IsPrivate)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(25),LastUsedInCampaign)),'DBNULL_DATETIME') + ISNULL(RTRIM(MarketCap),'DBNULL_TEXT') + ISNULL(RTRIM(MarketCap_Base),'DBNULL_TEXT') + ISNULL(RTRIM(MasterId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),Merged)),'DBNULL_BIT') + ISNULL(RTRIM(ModifiedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),ModifiedOn)),'DBNULL_DATETIME') + ISNULL(RTRIM(ModifiedOnBehalfBy),'DBNULL_TEXT') + ISNULL(RTRIM(Name),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),NumberOfEmployees)),'DBNULL_INT') + ISNULL(RTRIM(OriginatingLeadId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),OverriddenCreatedOn)),'DBNULL_DATETIME') + ISNULL(RTRIM(OwnerId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),OwnerIdType)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),OwnershipCode)),'DBNULL_INT') + ISNULL(RTRIM(OwningBusinessUnit),'DBNULL_TEXT') + ISNULL(RTRIM(ParentAccountId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ParticipatesInWorkflow)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),PaymentTermsCode)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),PreferredAppointmentDayCode)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),PreferredAppointmentTimeCode)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),PreferredContactMethodCode)),'DBNULL_INT') + ISNULL(RTRIM(PreferredEquipmentId),'DBNULL_TEXT') + ISNULL(RTRIM(PreferredServiceId),'DBNULL_TEXT') + ISNULL(RTRIM(PreferredSystemUserId),'DBNULL_TEXT') + ISNULL(RTRIM(PrimaryContactId),'DBNULL_TEXT') + ISNULL(RTRIM(Revenue),'DBNULL_TEXT') + ISNULL(RTRIM(Revenue_Base),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),SharesOutstanding)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),ShippingMethodCode)),'DBNULL_INT') + ISNULL(RTRIM(SIC),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),StateCode)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),StatusCode)),'DBNULL_INT') + ISNULL(RTRIM(StockExchange),'DBNULL_TEXT') + ISNULL(RTRIM(Telephone1),'DBNULL_TEXT') + ISNULL(RTRIM(Telephone2),'DBNULL_TEXT') + ISNULL(RTRIM(Telephone3),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),TerritoryCode)),'DBNULL_INT') + ISNULL(RTRIM(TerritoryId),'DBNULL_TEXT') + ISNULL(RTRIM(TickerSymbol),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),TimeZoneRuleVersionNumber)),'DBNULL_INT') + ISNULL(RTRIM(TransactionCurrencyId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),UTCConversionTimeZoneCode)),'DBNULL_INT') + ISNULL(RTRIM(VersionNumber),'DBNULL_TEXT') + ISNULL(RTRIM(WebSiteURL),'DBNULL_TEXT') + ISNULL(RTRIM(YomiName),'DBNULL_TEXT'))


CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (AccountId)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)



MERGE ProdCopy.AccountBase AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.AccountId = mySource.AccountId

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 OR ISNULL(mySource.Description,'') <> ISNULL(myTarget.Description,'') 
)
THEN UPDATE SET
      myTarget.[ETL_UpdatedDate] = @RunTime
     ,myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     ,myTarget.[AccountId] = mySource.[AccountId]
     ,myTarget.[AccountCategoryCode] = mySource.[AccountCategoryCode]
     ,myTarget.[TerritoryId] = mySource.[TerritoryId]
     ,myTarget.[DefaultPriceLevelId] = mySource.[DefaultPriceLevelId]
     ,myTarget.[CustomerSizeCode] = mySource.[CustomerSizeCode]
     ,myTarget.[PreferredContactMethodCode] = mySource.[PreferredContactMethodCode]
     ,myTarget.[CustomerTypeCode] = mySource.[CustomerTypeCode]
     ,myTarget.[AccountRatingCode] = mySource.[AccountRatingCode]
     ,myTarget.[IndustryCode] = mySource.[IndustryCode]
     ,myTarget.[TerritoryCode] = mySource.[TerritoryCode]
     ,myTarget.[AccountClassificationCode] = mySource.[AccountClassificationCode]
     ,myTarget.[BusinessTypeCode] = mySource.[BusinessTypeCode]
     ,myTarget.[OwningBusinessUnit] = mySource.[OwningBusinessUnit]
     ,myTarget.[OriginatingLeadId] = mySource.[OriginatingLeadId]
     ,myTarget.[PaymentTermsCode] = mySource.[PaymentTermsCode]
     ,myTarget.[ShippingMethodCode] = mySource.[ShippingMethodCode]
     ,myTarget.[PrimaryContactId] = mySource.[PrimaryContactId]
     ,myTarget.[ParticipatesInWorkflow] = mySource.[ParticipatesInWorkflow]
     ,myTarget.[Name] = mySource.[Name]
     ,myTarget.[AccountNumber] = mySource.[AccountNumber]
     ,myTarget.[Revenue] = mySource.[Revenue]
     ,myTarget.[NumberOfEmployees] = mySource.[NumberOfEmployees]
     ,myTarget.[Description] = mySource.[Description]
     ,myTarget.[SIC] = mySource.[SIC]
     ,myTarget.[OwnershipCode] = mySource.[OwnershipCode]
     ,myTarget.[MarketCap] = mySource.[MarketCap]
     ,myTarget.[SharesOutstanding] = mySource.[SharesOutstanding]
     ,myTarget.[TickerSymbol] = mySource.[TickerSymbol]
     ,myTarget.[StockExchange] = mySource.[StockExchange]
     ,myTarget.[WebSiteURL] = mySource.[WebSiteURL]
     ,myTarget.[FtpSiteURL] = mySource.[FtpSiteURL]
     ,myTarget.[EMailAddress1] = mySource.[EMailAddress1]
     ,myTarget.[EMailAddress2] = mySource.[EMailAddress2]
     ,myTarget.[EMailAddress3] = mySource.[EMailAddress3]
     ,myTarget.[DoNotPhone] = mySource.[DoNotPhone]
     ,myTarget.[DoNotFax] = mySource.[DoNotFax]
     ,myTarget.[Telephone1] = mySource.[Telephone1]
     ,myTarget.[DoNotEMail] = mySource.[DoNotEMail]
     ,myTarget.[Telephone2] = mySource.[Telephone2]
     ,myTarget.[Fax] = mySource.[Fax]
     ,myTarget.[Telephone3] = mySource.[Telephone3]
     ,myTarget.[DoNotPostalMail] = mySource.[DoNotPostalMail]
     ,myTarget.[DoNotBulkEMail] = mySource.[DoNotBulkEMail]
     ,myTarget.[DoNotBulkPostalMail] = mySource.[DoNotBulkPostalMail]
     ,myTarget.[CreditLimit] = mySource.[CreditLimit]
     ,myTarget.[CreditOnHold] = mySource.[CreditOnHold]
     ,myTarget.[IsPrivate] = mySource.[IsPrivate]
     ,myTarget.[CreatedOn] = mySource.[CreatedOn]
     ,myTarget.[CreatedBy] = mySource.[CreatedBy]
     ,myTarget.[ModifiedOn] = mySource.[ModifiedOn]
     ,myTarget.[ModifiedBy] = mySource.[ModifiedBy]
     ,myTarget.[VersionNumber] = mySource.[VersionNumber]
     ,myTarget.[ParentAccountId] = mySource.[ParentAccountId]
     ,myTarget.[Aging30] = mySource.[Aging30]
     ,myTarget.[StateCode] = mySource.[StateCode]
     ,myTarget.[Aging60] = mySource.[Aging60]
     ,myTarget.[StatusCode] = mySource.[StatusCode]
     ,myTarget.[Aging90] = mySource.[Aging90]
     ,myTarget.[PreferredAppointmentDayCode] = mySource.[PreferredAppointmentDayCode]
     ,myTarget.[PreferredSystemUserId] = mySource.[PreferredSystemUserId]
     ,myTarget.[PreferredAppointmentTimeCode] = mySource.[PreferredAppointmentTimeCode]
     ,myTarget.[Merged] = mySource.[Merged]
     ,myTarget.[DoNotSendMM] = mySource.[DoNotSendMM]
     ,myTarget.[MasterId] = mySource.[MasterId]
     ,myTarget.[LastUsedInCampaign] = mySource.[LastUsedInCampaign]
     ,myTarget.[PreferredServiceId] = mySource.[PreferredServiceId]
     ,myTarget.[PreferredEquipmentId] = mySource.[PreferredEquipmentId]
     ,myTarget.[ExchangeRate] = mySource.[ExchangeRate]
     ,myTarget.[UTCConversionTimeZoneCode] = mySource.[UTCConversionTimeZoneCode]
     ,myTarget.[OverriddenCreatedOn] = mySource.[OverriddenCreatedOn]
     ,myTarget.[TimeZoneRuleVersionNumber] = mySource.[TimeZoneRuleVersionNumber]
     ,myTarget.[ImportSequenceNumber] = mySource.[ImportSequenceNumber]
     ,myTarget.[TransactionCurrencyId] = mySource.[TransactionCurrencyId]
     ,myTarget.[CreditLimit_Base] = mySource.[CreditLimit_Base]
     ,myTarget.[Aging30_Base] = mySource.[Aging30_Base]
     ,myTarget.[Revenue_Base] = mySource.[Revenue_Base]
     ,myTarget.[Aging90_Base] = mySource.[Aging90_Base]
     ,myTarget.[MarketCap_Base] = mySource.[MarketCap_Base]
     ,myTarget.[Aging60_Base] = mySource.[Aging60_Base]
     ,myTarget.[YomiName] = mySource.[YomiName]
     ,myTarget.[OwnerId] = mySource.[OwnerId]
     ,myTarget.[ModifiedOnBehalfBy] = mySource.[ModifiedOnBehalfBy]
     ,myTarget.[CreatedOnBehalfBy] = mySource.[CreatedOnBehalfBy]
     ,myTarget.[OwnerIdType] = mySource.[OwnerIdType]
     
WHEN NOT MATCHED BY TARGET
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[AccountId]
     ,[AccountCategoryCode]
     ,[TerritoryId]
     ,[DefaultPriceLevelId]
     ,[CustomerSizeCode]
     ,[PreferredContactMethodCode]
     ,[CustomerTypeCode]
     ,[AccountRatingCode]
     ,[IndustryCode]
     ,[TerritoryCode]
     ,[AccountClassificationCode]
     ,[BusinessTypeCode]
     ,[OwningBusinessUnit]
     ,[OriginatingLeadId]
     ,[PaymentTermsCode]
     ,[ShippingMethodCode]
     ,[PrimaryContactId]
     ,[ParticipatesInWorkflow]
     ,[Name]
     ,[AccountNumber]
     ,[Revenue]
     ,[NumberOfEmployees]
     ,[Description]
     ,[SIC]
     ,[OwnershipCode]
     ,[MarketCap]
     ,[SharesOutstanding]
     ,[TickerSymbol]
     ,[StockExchange]
     ,[WebSiteURL]
     ,[FtpSiteURL]
     ,[EMailAddress1]
     ,[EMailAddress2]
     ,[EMailAddress3]
     ,[DoNotPhone]
     ,[DoNotFax]
     ,[Telephone1]
     ,[DoNotEMail]
     ,[Telephone2]
     ,[Fax]
     ,[Telephone3]
     ,[DoNotPostalMail]
     ,[DoNotBulkEMail]
     ,[DoNotBulkPostalMail]
     ,[CreditLimit]
     ,[CreditOnHold]
     ,[IsPrivate]
     ,[CreatedOn]
     ,[CreatedBy]
     ,[ModifiedOn]
     ,[ModifiedBy]
     ,[VersionNumber]
     ,[ParentAccountId]
     ,[Aging30]
     ,[StateCode]
     ,[Aging60]
     ,[StatusCode]
     ,[Aging90]
     ,[PreferredAppointmentDayCode]
     ,[PreferredSystemUserId]
     ,[PreferredAppointmentTimeCode]
     ,[Merged]
     ,[DoNotSendMM]
     ,[MasterId]
     ,[LastUsedInCampaign]
     ,[PreferredServiceId]
     ,[PreferredEquipmentId]
     ,[ExchangeRate]
     ,[UTCConversionTimeZoneCode]
     ,[OverriddenCreatedOn]
     ,[TimeZoneRuleVersionNumber]
     ,[ImportSequenceNumber]
     ,[TransactionCurrencyId]
     ,[CreditLimit_Base]
     ,[Aging30_Base]
     ,[Revenue_Base]
     ,[Aging90_Base]
     ,[MarketCap_Base]
     ,[Aging60_Base]
     ,[YomiName]
     ,[OwnerId]
     ,[ModifiedOnBehalfBy]
     ,[CreatedOnBehalfBy]
     ,[OwnerIdType]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[AccountId]
     ,mySource.[AccountCategoryCode]
     ,mySource.[TerritoryId]
     ,mySource.[DefaultPriceLevelId]
     ,mySource.[CustomerSizeCode]
     ,mySource.[PreferredContactMethodCode]
     ,mySource.[CustomerTypeCode]
     ,mySource.[AccountRatingCode]
     ,mySource.[IndustryCode]
     ,mySource.[TerritoryCode]
     ,mySource.[AccountClassificationCode]
     ,mySource.[BusinessTypeCode]
     ,mySource.[OwningBusinessUnit]
     ,mySource.[OriginatingLeadId]
     ,mySource.[PaymentTermsCode]
     ,mySource.[ShippingMethodCode]
     ,mySource.[PrimaryContactId]
     ,mySource.[ParticipatesInWorkflow]
     ,mySource.[Name]
     ,mySource.[AccountNumber]
     ,mySource.[Revenue]
     ,mySource.[NumberOfEmployees]
     ,mySource.[Description]
     ,mySource.[SIC]
     ,mySource.[OwnershipCode]
     ,mySource.[MarketCap]
     ,mySource.[SharesOutstanding]
     ,mySource.[TickerSymbol]
     ,mySource.[StockExchange]
     ,mySource.[WebSiteURL]
     ,mySource.[FtpSiteURL]
     ,mySource.[EMailAddress1]
     ,mySource.[EMailAddress2]
     ,mySource.[EMailAddress3]
     ,mySource.[DoNotPhone]
     ,mySource.[DoNotFax]
     ,mySource.[Telephone1]
     ,mySource.[DoNotEMail]
     ,mySource.[Telephone2]
     ,mySource.[Fax]
     ,mySource.[Telephone3]
     ,mySource.[DoNotPostalMail]
     ,mySource.[DoNotBulkEMail]
     ,mySource.[DoNotBulkPostalMail]
     ,mySource.[CreditLimit]
     ,mySource.[CreditOnHold]
     ,mySource.[IsPrivate]
     ,mySource.[CreatedOn]
     ,mySource.[CreatedBy]
     ,mySource.[ModifiedOn]
     ,mySource.[ModifiedBy]
     ,mySource.[VersionNumber]
     ,mySource.[ParentAccountId]
     ,mySource.[Aging30]
     ,mySource.[StateCode]
     ,mySource.[Aging60]
     ,mySource.[StatusCode]
     ,mySource.[Aging90]
     ,mySource.[PreferredAppointmentDayCode]
     ,mySource.[PreferredSystemUserId]
     ,mySource.[PreferredAppointmentTimeCode]
     ,mySource.[Merged]
     ,mySource.[DoNotSendMM]
     ,mySource.[MasterId]
     ,mySource.[LastUsedInCampaign]
     ,mySource.[PreferredServiceId]
     ,mySource.[PreferredEquipmentId]
     ,mySource.[ExchangeRate]
     ,mySource.[UTCConversionTimeZoneCode]
     ,mySource.[OverriddenCreatedOn]
     ,mySource.[TimeZoneRuleVersionNumber]
     ,mySource.[ImportSequenceNumber]
     ,mySource.[TransactionCurrencyId]
     ,mySource.[CreditLimit_Base]
     ,mySource.[Aging30_Base]
     ,mySource.[Revenue_Base]
     ,mySource.[Aging90_Base]
     ,mySource.[MarketCap_Base]
     ,mySource.[Aging60_Base]
     ,mySource.[YomiName]
     ,mySource.[OwnerId]
     ,mySource.[ModifiedOnBehalfBy]
     ,mySource.[CreatedOnBehalfBy]
     ,mySource.[OwnerIdType]
     )
;



DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ProdCopy.AccountBase WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ProdCopy.AccountBase WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	


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
