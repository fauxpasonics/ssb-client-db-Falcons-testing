SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[ProdCopy_ContactBase]
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
DECLARE @SrcRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM ProdCopyStg.ContactBase),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey, ETL_UpdatedDate, ETL_IsDeleted, ETL_DeletedDate, ContactId, DefaultPriceLevelId, CustomerSizeCode, CustomerTypeCode, PreferredContactMethodCode, LeadSourceCode, OriginatingLeadId, OwningBusinessUnit, PaymentTermsCode, ShippingMethodCode, ParticipatesInWorkflow, IsBackofficeCustomer, Salutation, JobTitle, FirstName, Department, NickName, MiddleName, LastName, Suffix, YomiFirstName, FullName, YomiMiddleName, YomiLastName, Anniversary, BirthDate, GovernmentId, YomiFullName, Description, EmployeeId, GenderCode, AnnualIncome, HasChildrenCode, EducationCode, WebSiteUrl, FamilyStatusCode, FtpSiteUrl, EMailAddress1, SpousesName, AssistantName, EMailAddress2, AssistantPhone, EMailAddress3, DoNotPhone, ManagerName, ManagerPhone, DoNotFax, DoNotEMail, DoNotPostalMail, DoNotBulkEMail, DoNotBulkPostalMail, AccountRoleCode, TerritoryCode, IsPrivate, CreditLimit, CreatedOn, CreditOnHold, CreatedBy, ModifiedOn, ModifiedBy, NumberOfChildren, ChildrensNames, VersionNumber, MobilePhone, Pager, Telephone1, Telephone2, Telephone3, Fax, Aging30, StateCode, Aging60, StatusCode, Aging90, PreferredSystemUserId, PreferredServiceId, MasterId, PreferredAppointmentDayCode, PreferredAppointmentTimeCode, DoNotSendMM, Merged, ExternalUserIdentifier, SubscriptionId, PreferredEquipmentId, LastUsedInCampaign, TransactionCurrencyId, OverriddenCreatedOn, ExchangeRate, ImportSequenceNumber, TimeZoneRuleVersionNumber, UTCConversionTimeZoneCode, AnnualIncome_Base, CreditLimit_Base, Aging60_Base, Aging90_Base, Aging30_Base, OwnerId, CreatedOnBehalfBy, IsAutoCreate, ModifiedOnBehalfBy, ParentCustomerId, ParentCustomerIdType, ParentCustomerIdName, OwnerIdType, ParentCustomerIdYomiName
INTO #SrcData
FROM ProdCopyStg.ContactBase

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(CONVERT(varchar(10),AccountRoleCode)),'DBNULL_INT') + ISNULL(RTRIM(Aging30),'DBNULL_TEXT') + ISNULL(RTRIM(Aging30_Base),'DBNULL_TEXT') + ISNULL(RTRIM(Aging60),'DBNULL_TEXT') + ISNULL(RTRIM(Aging60_Base),'DBNULL_TEXT') + ISNULL(RTRIM(Aging90),'DBNULL_TEXT') + ISNULL(RTRIM(Aging90_Base),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),Anniversary)),'DBNULL_DATETIME') + ISNULL(RTRIM(AnnualIncome),'DBNULL_TEXT') + ISNULL(RTRIM(AnnualIncome_Base),'DBNULL_TEXT') + ISNULL(RTRIM(AssistantName),'DBNULL_TEXT') + ISNULL(RTRIM(AssistantPhone),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),BirthDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(ChildrensNames),'DBNULL_TEXT') + ISNULL(RTRIM(ContactId),'DBNULL_TEXT') + ISNULL(RTRIM(CreatedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),CreatedOn)),'DBNULL_DATETIME') + ISNULL(RTRIM(CreatedOnBehalfBy),'DBNULL_TEXT') + ISNULL(RTRIM(CreditLimit),'DBNULL_TEXT') + ISNULL(RTRIM(CreditLimit_Base),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),CreditOnHold)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),CustomerSizeCode)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),CustomerTypeCode)),'DBNULL_INT') + ISNULL(RTRIM(DefaultPriceLevelId),'DBNULL_TEXT') + ISNULL(RTRIM(Department),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),DoNotBulkEMail)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),DoNotBulkPostalMail)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),DoNotEMail)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),DoNotFax)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),DoNotPhone)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),DoNotPostalMail)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),DoNotSendMM)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),EducationCode)),'DBNULL_INT') + ISNULL(RTRIM(EMailAddress1),'DBNULL_TEXT') + ISNULL(RTRIM(EMailAddress2),'DBNULL_TEXT') + ISNULL(RTRIM(EMailAddress3),'DBNULL_TEXT') + ISNULL(RTRIM(EmployeeId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),ETL_DeletedDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(ETL_DeltaHashKey),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ETL_IsDeleted)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(25),ETL_UpdatedDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(25),ExchangeRate)),'DBNULL_NUMBER') + ISNULL(RTRIM(ExternalUserIdentifier),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),FamilyStatusCode)),'DBNULL_INT') + ISNULL(RTRIM(Fax),'DBNULL_TEXT') + ISNULL(RTRIM(FirstName),'DBNULL_TEXT') + ISNULL(RTRIM(FtpSiteUrl),'DBNULL_TEXT') + ISNULL(RTRIM(FullName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),GenderCode)),'DBNULL_INT') + ISNULL(RTRIM(GovernmentId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),HasChildrenCode)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),ImportSequenceNumber)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),IsAutoCreate)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsBackofficeCustomer)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),IsPrivate)),'DBNULL_BIT') + ISNULL(RTRIM(JobTitle),'DBNULL_TEXT') + ISNULL(RTRIM(LastName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),LastUsedInCampaign)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(10),LeadSourceCode)),'DBNULL_INT') + ISNULL(RTRIM(ManagerName),'DBNULL_TEXT') + ISNULL(RTRIM(ManagerPhone),'DBNULL_TEXT') + ISNULL(RTRIM(MasterId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),Merged)),'DBNULL_BIT') + ISNULL(RTRIM(MiddleName),'DBNULL_TEXT') + ISNULL(RTRIM(MobilePhone),'DBNULL_TEXT') + ISNULL(RTRIM(ModifiedBy),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),ModifiedOn)),'DBNULL_DATETIME') + ISNULL(RTRIM(ModifiedOnBehalfBy),'DBNULL_TEXT') + ISNULL(RTRIM(NickName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),NumberOfChildren)),'DBNULL_INT') + ISNULL(RTRIM(OriginatingLeadId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),OverriddenCreatedOn)),'DBNULL_DATETIME') + ISNULL(RTRIM(OwnerId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),OwnerIdType)),'DBNULL_INT') + ISNULL(RTRIM(OwningBusinessUnit),'DBNULL_TEXT') + ISNULL(RTRIM(Pager),'DBNULL_TEXT') + ISNULL(RTRIM(ParentCustomerId),'DBNULL_TEXT') + ISNULL(RTRIM(ParentCustomerIdName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ParentCustomerIdType)),'DBNULL_INT') + ISNULL(RTRIM(ParentCustomerIdYomiName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ParticipatesInWorkflow)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),PaymentTermsCode)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),PreferredAppointmentDayCode)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),PreferredAppointmentTimeCode)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),PreferredContactMethodCode)),'DBNULL_INT') + ISNULL(RTRIM(PreferredEquipmentId),'DBNULL_TEXT') + ISNULL(RTRIM(PreferredServiceId),'DBNULL_TEXT') + ISNULL(RTRIM(PreferredSystemUserId),'DBNULL_TEXT') + ISNULL(RTRIM(Salutation),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ShippingMethodCode)),'DBNULL_INT') + ISNULL(RTRIM(SpousesName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),StateCode)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),StatusCode)),'DBNULL_INT') + ISNULL(RTRIM(SubscriptionId),'DBNULL_TEXT') + ISNULL(RTRIM(Suffix),'DBNULL_TEXT') + ISNULL(RTRIM(Telephone1),'DBNULL_TEXT') + ISNULL(RTRIM(Telephone2),'DBNULL_TEXT') + ISNULL(RTRIM(Telephone3),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),TerritoryCode)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),TimeZoneRuleVersionNumber)),'DBNULL_INT') + ISNULL(RTRIM(TransactionCurrencyId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),UTCConversionTimeZoneCode)),'DBNULL_INT') + ISNULL(RTRIM(VersionNumber),'DBNULL_TEXT') + ISNULL(RTRIM(WebSiteUrl),'DBNULL_TEXT') + ISNULL(RTRIM(YomiFirstName),'DBNULL_TEXT') + ISNULL(RTRIM(YomiFullName),'DBNULL_TEXT') + ISNULL(RTRIM(YomiLastName),'DBNULL_TEXT') + ISNULL(RTRIM(YomiMiddleName),'DBNULL_TEXT'))


CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (ContactId)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)



MERGE ProdCopy.ContactBase AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.ContactId = mySource.ContactId

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 OR ISNULL(mySource.Description,'') <> ISNULL(myTarget.Description,'') 
)
THEN UPDATE SET
      myTarget.[ETL_UpdatedDate] = @RunTime
     ,myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     ,myTarget.[ContactId] = mySource.[ContactId]
     ,myTarget.[DefaultPriceLevelId] = mySource.[DefaultPriceLevelId]
     ,myTarget.[CustomerSizeCode] = mySource.[CustomerSizeCode]
     ,myTarget.[CustomerTypeCode] = mySource.[CustomerTypeCode]
     ,myTarget.[PreferredContactMethodCode] = mySource.[PreferredContactMethodCode]
     ,myTarget.[LeadSourceCode] = mySource.[LeadSourceCode]
     ,myTarget.[OriginatingLeadId] = mySource.[OriginatingLeadId]
     ,myTarget.[OwningBusinessUnit] = mySource.[OwningBusinessUnit]
     ,myTarget.[PaymentTermsCode] = mySource.[PaymentTermsCode]
     ,myTarget.[ShippingMethodCode] = mySource.[ShippingMethodCode]
     ,myTarget.[ParticipatesInWorkflow] = mySource.[ParticipatesInWorkflow]
     ,myTarget.[IsBackofficeCustomer] = mySource.[IsBackofficeCustomer]
     ,myTarget.[Salutation] = mySource.[Salutation]
     ,myTarget.[JobTitle] = mySource.[JobTitle]
     ,myTarget.[FirstName] = mySource.[FirstName]
     ,myTarget.[Department] = mySource.[Department]
     ,myTarget.[NickName] = mySource.[NickName]
     ,myTarget.[MiddleName] = mySource.[MiddleName]
     ,myTarget.[LastName] = mySource.[LastName]
     ,myTarget.[Suffix] = mySource.[Suffix]
     ,myTarget.[YomiFirstName] = mySource.[YomiFirstName]
     ,myTarget.[FullName] = mySource.[FullName]
     ,myTarget.[YomiMiddleName] = mySource.[YomiMiddleName]
     ,myTarget.[YomiLastName] = mySource.[YomiLastName]
     ,myTarget.[Anniversary] = mySource.[Anniversary]
     ,myTarget.[BirthDate] = mySource.[BirthDate]
     ,myTarget.[GovernmentId] = mySource.[GovernmentId]
     ,myTarget.[YomiFullName] = mySource.[YomiFullName]
     ,myTarget.[Description] = mySource.[Description]
     ,myTarget.[EmployeeId] = mySource.[EmployeeId]
     ,myTarget.[GenderCode] = mySource.[GenderCode]
     ,myTarget.[AnnualIncome] = mySource.[AnnualIncome]
     ,myTarget.[HasChildrenCode] = mySource.[HasChildrenCode]
     ,myTarget.[EducationCode] = mySource.[EducationCode]
     ,myTarget.[WebSiteUrl] = mySource.[WebSiteUrl]
     ,myTarget.[FamilyStatusCode] = mySource.[FamilyStatusCode]
     ,myTarget.[FtpSiteUrl] = mySource.[FtpSiteUrl]
     ,myTarget.[EMailAddress1] = mySource.[EMailAddress1]
     ,myTarget.[SpousesName] = mySource.[SpousesName]
     ,myTarget.[AssistantName] = mySource.[AssistantName]
     ,myTarget.[EMailAddress2] = mySource.[EMailAddress2]
     ,myTarget.[AssistantPhone] = mySource.[AssistantPhone]
     ,myTarget.[EMailAddress3] = mySource.[EMailAddress3]
     ,myTarget.[DoNotPhone] = mySource.[DoNotPhone]
     ,myTarget.[ManagerName] = mySource.[ManagerName]
     ,myTarget.[ManagerPhone] = mySource.[ManagerPhone]
     ,myTarget.[DoNotFax] = mySource.[DoNotFax]
     ,myTarget.[DoNotEMail] = mySource.[DoNotEMail]
     ,myTarget.[DoNotPostalMail] = mySource.[DoNotPostalMail]
     ,myTarget.[DoNotBulkEMail] = mySource.[DoNotBulkEMail]
     ,myTarget.[DoNotBulkPostalMail] = mySource.[DoNotBulkPostalMail]
     ,myTarget.[AccountRoleCode] = mySource.[AccountRoleCode]
     ,myTarget.[TerritoryCode] = mySource.[TerritoryCode]
     ,myTarget.[IsPrivate] = mySource.[IsPrivate]
     ,myTarget.[CreditLimit] = mySource.[CreditLimit]
     ,myTarget.[CreatedOn] = mySource.[CreatedOn]
     ,myTarget.[CreditOnHold] = mySource.[CreditOnHold]
     ,myTarget.[CreatedBy] = mySource.[CreatedBy]
     ,myTarget.[ModifiedOn] = mySource.[ModifiedOn]
     ,myTarget.[ModifiedBy] = mySource.[ModifiedBy]
     ,myTarget.[NumberOfChildren] = mySource.[NumberOfChildren]
     ,myTarget.[ChildrensNames] = mySource.[ChildrensNames]
     ,myTarget.[VersionNumber] = mySource.[VersionNumber]
     ,myTarget.[MobilePhone] = mySource.[MobilePhone]
     ,myTarget.[Pager] = mySource.[Pager]
     ,myTarget.[Telephone1] = mySource.[Telephone1]
     ,myTarget.[Telephone2] = mySource.[Telephone2]
     ,myTarget.[Telephone3] = mySource.[Telephone3]
     ,myTarget.[Fax] = mySource.[Fax]
     ,myTarget.[Aging30] = mySource.[Aging30]
     ,myTarget.[StateCode] = mySource.[StateCode]
     ,myTarget.[Aging60] = mySource.[Aging60]
     ,myTarget.[StatusCode] = mySource.[StatusCode]
     ,myTarget.[Aging90] = mySource.[Aging90]
     ,myTarget.[PreferredSystemUserId] = mySource.[PreferredSystemUserId]
     ,myTarget.[PreferredServiceId] = mySource.[PreferredServiceId]
     ,myTarget.[MasterId] = mySource.[MasterId]
     ,myTarget.[PreferredAppointmentDayCode] = mySource.[PreferredAppointmentDayCode]
     ,myTarget.[PreferredAppointmentTimeCode] = mySource.[PreferredAppointmentTimeCode]
     ,myTarget.[DoNotSendMM] = mySource.[DoNotSendMM]
     ,myTarget.[Merged] = mySource.[Merged]
     ,myTarget.[ExternalUserIdentifier] = mySource.[ExternalUserIdentifier]
     ,myTarget.[SubscriptionId] = mySource.[SubscriptionId]
     ,myTarget.[PreferredEquipmentId] = mySource.[PreferredEquipmentId]
     ,myTarget.[LastUsedInCampaign] = mySource.[LastUsedInCampaign]
     ,myTarget.[TransactionCurrencyId] = mySource.[TransactionCurrencyId]
     ,myTarget.[OverriddenCreatedOn] = mySource.[OverriddenCreatedOn]
     ,myTarget.[ExchangeRate] = mySource.[ExchangeRate]
     ,myTarget.[ImportSequenceNumber] = mySource.[ImportSequenceNumber]
     ,myTarget.[TimeZoneRuleVersionNumber] = mySource.[TimeZoneRuleVersionNumber]
     ,myTarget.[UTCConversionTimeZoneCode] = mySource.[UTCConversionTimeZoneCode]
     ,myTarget.[AnnualIncome_Base] = mySource.[AnnualIncome_Base]
     ,myTarget.[CreditLimit_Base] = mySource.[CreditLimit_Base]
     ,myTarget.[Aging60_Base] = mySource.[Aging60_Base]
     ,myTarget.[Aging90_Base] = mySource.[Aging90_Base]
     ,myTarget.[Aging30_Base] = mySource.[Aging30_Base]
     ,myTarget.[OwnerId] = mySource.[OwnerId]
     ,myTarget.[CreatedOnBehalfBy] = mySource.[CreatedOnBehalfBy]
     ,myTarget.[IsAutoCreate] = mySource.[IsAutoCreate]
     ,myTarget.[ModifiedOnBehalfBy] = mySource.[ModifiedOnBehalfBy]
     ,myTarget.[ParentCustomerId] = mySource.[ParentCustomerId]
     ,myTarget.[ParentCustomerIdType] = mySource.[ParentCustomerIdType]
     ,myTarget.[ParentCustomerIdName] = mySource.[ParentCustomerIdName]
     ,myTarget.[OwnerIdType] = mySource.[OwnerIdType]
     ,myTarget.[ParentCustomerIdYomiName] = mySource.[ParentCustomerIdYomiName]
     
WHEN NOT MATCHED BY TARGET
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[ContactId]
     ,[DefaultPriceLevelId]
     ,[CustomerSizeCode]
     ,[CustomerTypeCode]
     ,[PreferredContactMethodCode]
     ,[LeadSourceCode]
     ,[OriginatingLeadId]
     ,[OwningBusinessUnit]
     ,[PaymentTermsCode]
     ,[ShippingMethodCode]
     ,[ParticipatesInWorkflow]
     ,[IsBackofficeCustomer]
     ,[Salutation]
     ,[JobTitle]
     ,[FirstName]
     ,[Department]
     ,[NickName]
     ,[MiddleName]
     ,[LastName]
     ,[Suffix]
     ,[YomiFirstName]
     ,[FullName]
     ,[YomiMiddleName]
     ,[YomiLastName]
     ,[Anniversary]
     ,[BirthDate]
     ,[GovernmentId]
     ,[YomiFullName]
     ,[Description]
     ,[EmployeeId]
     ,[GenderCode]
     ,[AnnualIncome]
     ,[HasChildrenCode]
     ,[EducationCode]
     ,[WebSiteUrl]
     ,[FamilyStatusCode]
     ,[FtpSiteUrl]
     ,[EMailAddress1]
     ,[SpousesName]
     ,[AssistantName]
     ,[EMailAddress2]
     ,[AssistantPhone]
     ,[EMailAddress3]
     ,[DoNotPhone]
     ,[ManagerName]
     ,[ManagerPhone]
     ,[DoNotFax]
     ,[DoNotEMail]
     ,[DoNotPostalMail]
     ,[DoNotBulkEMail]
     ,[DoNotBulkPostalMail]
     ,[AccountRoleCode]
     ,[TerritoryCode]
     ,[IsPrivate]
     ,[CreditLimit]
     ,[CreatedOn]
     ,[CreditOnHold]
     ,[CreatedBy]
     ,[ModifiedOn]
     ,[ModifiedBy]
     ,[NumberOfChildren]
     ,[ChildrensNames]
     ,[VersionNumber]
     ,[MobilePhone]
     ,[Pager]
     ,[Telephone1]
     ,[Telephone2]
     ,[Telephone3]
     ,[Fax]
     ,[Aging30]
     ,[StateCode]
     ,[Aging60]
     ,[StatusCode]
     ,[Aging90]
     ,[PreferredSystemUserId]
     ,[PreferredServiceId]
     ,[MasterId]
     ,[PreferredAppointmentDayCode]
     ,[PreferredAppointmentTimeCode]
     ,[DoNotSendMM]
     ,[Merged]
     ,[ExternalUserIdentifier]
     ,[SubscriptionId]
     ,[PreferredEquipmentId]
     ,[LastUsedInCampaign]
     ,[TransactionCurrencyId]
     ,[OverriddenCreatedOn]
     ,[ExchangeRate]
     ,[ImportSequenceNumber]
     ,[TimeZoneRuleVersionNumber]
     ,[UTCConversionTimeZoneCode]
     ,[AnnualIncome_Base]
     ,[CreditLimit_Base]
     ,[Aging60_Base]
     ,[Aging90_Base]
     ,[Aging30_Base]
     ,[OwnerId]
     ,[CreatedOnBehalfBy]
     ,[IsAutoCreate]
     ,[ModifiedOnBehalfBy]
     ,[ParentCustomerId]
     ,[ParentCustomerIdType]
     ,[ParentCustomerIdName]
     ,[OwnerIdType]
     ,[ParentCustomerIdYomiName]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[ContactId]
     ,mySource.[DefaultPriceLevelId]
     ,mySource.[CustomerSizeCode]
     ,mySource.[CustomerTypeCode]
     ,mySource.[PreferredContactMethodCode]
     ,mySource.[LeadSourceCode]
     ,mySource.[OriginatingLeadId]
     ,mySource.[OwningBusinessUnit]
     ,mySource.[PaymentTermsCode]
     ,mySource.[ShippingMethodCode]
     ,mySource.[ParticipatesInWorkflow]
     ,mySource.[IsBackofficeCustomer]
     ,mySource.[Salutation]
     ,mySource.[JobTitle]
     ,mySource.[FirstName]
     ,mySource.[Department]
     ,mySource.[NickName]
     ,mySource.[MiddleName]
     ,mySource.[LastName]
     ,mySource.[Suffix]
     ,mySource.[YomiFirstName]
     ,mySource.[FullName]
     ,mySource.[YomiMiddleName]
     ,mySource.[YomiLastName]
     ,mySource.[Anniversary]
     ,mySource.[BirthDate]
     ,mySource.[GovernmentId]
     ,mySource.[YomiFullName]
     ,mySource.[Description]
     ,mySource.[EmployeeId]
     ,mySource.[GenderCode]
     ,mySource.[AnnualIncome]
     ,mySource.[HasChildrenCode]
     ,mySource.[EducationCode]
     ,mySource.[WebSiteUrl]
     ,mySource.[FamilyStatusCode]
     ,mySource.[FtpSiteUrl]
     ,mySource.[EMailAddress1]
     ,mySource.[SpousesName]
     ,mySource.[AssistantName]
     ,mySource.[EMailAddress2]
     ,mySource.[AssistantPhone]
     ,mySource.[EMailAddress3]
     ,mySource.[DoNotPhone]
     ,mySource.[ManagerName]
     ,mySource.[ManagerPhone]
     ,mySource.[DoNotFax]
     ,mySource.[DoNotEMail]
     ,mySource.[DoNotPostalMail]
     ,mySource.[DoNotBulkEMail]
     ,mySource.[DoNotBulkPostalMail]
     ,mySource.[AccountRoleCode]
     ,mySource.[TerritoryCode]
     ,mySource.[IsPrivate]
     ,mySource.[CreditLimit]
     ,mySource.[CreatedOn]
     ,mySource.[CreditOnHold]
     ,mySource.[CreatedBy]
     ,mySource.[ModifiedOn]
     ,mySource.[ModifiedBy]
     ,mySource.[NumberOfChildren]
     ,mySource.[ChildrensNames]
     ,mySource.[VersionNumber]
     ,mySource.[MobilePhone]
     ,mySource.[Pager]
     ,mySource.[Telephone1]
     ,mySource.[Telephone2]
     ,mySource.[Telephone3]
     ,mySource.[Fax]
     ,mySource.[Aging30]
     ,mySource.[StateCode]
     ,mySource.[Aging60]
     ,mySource.[StatusCode]
     ,mySource.[Aging90]
     ,mySource.[PreferredSystemUserId]
     ,mySource.[PreferredServiceId]
     ,mySource.[MasterId]
     ,mySource.[PreferredAppointmentDayCode]
     ,mySource.[PreferredAppointmentTimeCode]
     ,mySource.[DoNotSendMM]
     ,mySource.[Merged]
     ,mySource.[ExternalUserIdentifier]
     ,mySource.[SubscriptionId]
     ,mySource.[PreferredEquipmentId]
     ,mySource.[LastUsedInCampaign]
     ,mySource.[TransactionCurrencyId]
     ,mySource.[OverriddenCreatedOn]
     ,mySource.[ExchangeRate]
     ,mySource.[ImportSequenceNumber]
     ,mySource.[TimeZoneRuleVersionNumber]
     ,mySource.[UTCConversionTimeZoneCode]
     ,mySource.[AnnualIncome_Base]
     ,mySource.[CreditLimit_Base]
     ,mySource.[Aging60_Base]
     ,mySource.[Aging90_Base]
     ,mySource.[Aging30_Base]
     ,mySource.[OwnerId]
     ,mySource.[CreatedOnBehalfBy]
     ,mySource.[IsAutoCreate]
     ,mySource.[ModifiedOnBehalfBy]
     ,mySource.[ParentCustomerId]
     ,mySource.[ParentCustomerIdType]
     ,mySource.[ParentCustomerIdName]
     ,mySource.[OwnerIdType]
     ,mySource.[ParentCustomerIdYomiName]
     )
;



DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ProdCopy.ContactBase WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ProdCopy.ContactBase WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	


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
