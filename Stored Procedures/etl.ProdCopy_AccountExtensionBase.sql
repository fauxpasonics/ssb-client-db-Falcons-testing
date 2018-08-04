SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[ProdCopy_AccountExtensionBase]
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
DECLARE @SrcRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM ProdCopyStg.AccountExtensionBase),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey, ETL_UpdatedDate, ETL_IsDeleted, ETL_DeletedDate, AccountId, KORE_address1_telephone1dncstatus, KORE_address1_telephone2dncstatus, KORE_address1_telephone3dncstatus, KORE_address2_telephone1dncstatus, KORE_address2_telephone2dncstatus, KORE_address2_telephone3dncstatus, KORE_LastContacted, KORE_lastcontactedactivityid, KORE_LastSync, KORE_LegalName, KORE_NextContact, KORE_nextcontactactivityid, kore_StrippedName, KORE_telephone1dncstatus, KORE_telephone2dncstatus, KORE_telephone3dncstatus, KORE_Type, kore_billingcontactid, kore_countryid, kore_stateorprovinceid, kore_sourcemarketinglistid, kore_coordinatorid, kore_CreatedByAccountAlias, kore_CurrentlyBeingWorked, kore_HasCheckedOutContact, kore_BusinessWiseID, kore_BWBuildingType, kore_BWEmployeesAtAllSites, kore_BWEmployeesAtSite, kore_BWEstimatedSales, kore_BWExactSize, kore_BWInternationalBusiness, kore_BWOwnBuilding, kore_BWSector, kore_BWSICDescription, kore_BWSiteType, kore_BWStartYear, kore_BWTotalSites, cdi_allowtextmessages, new_MetroArea, new_GeoGroup, new_ZipcodeId, new_ExternalCoordinator, kore_industryid, new_SponsorshipRep, kore_ExternalAccountID, li_CompanyId, kore_TaxExemptStatus, KORE_Agency, KORE_AuthorizedSignor, kore_Headquarters, KORE_SponsorAccountNumber, KORE_StateofIncorporation, kore_USOffice, KORE_AgencyId, kore_authorizedsignorid, kore_externalreportingpartnerid, kore_NBACategoryId, kore_NBASponsorId, KORE_StateofIncorporationId, kore_salespersonid, client_gpaccountnumber, client_GPCustomerClass, client_syncedwithgp, client_triggergp
INTO #SrcData
FROM ProdCopyStg.AccountExtensionBase

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(AccountId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),cdi_allowtextmessages)),'DBNULL_BIT') + ISNULL(RTRIM(client_gpaccountnumber),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),client_GPCustomerClass)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),client_syncedwithgp)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),client_triggergp)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(25),ETL_DeletedDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(ETL_DeltaHashKey),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),ETL_IsDeleted)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(25),ETL_UpdatedDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(CONVERT(varchar(10),KORE_address1_telephone1dncstatus)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),KORE_address1_telephone2dncstatus)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),KORE_address1_telephone3dncstatus)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),KORE_address2_telephone1dncstatus)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),KORE_address2_telephone2dncstatus)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),KORE_address2_telephone3dncstatus)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),KORE_Agency)),'DBNULL_INT') + ISNULL(RTRIM(KORE_AgencyId),'DBNULL_TEXT') + ISNULL(RTRIM(KORE_AuthorizedSignor),'DBNULL_TEXT') + ISNULL(RTRIM(kore_authorizedsignorid),'DBNULL_TEXT') + ISNULL(RTRIM(kore_billingcontactid),'DBNULL_TEXT') + ISNULL(RTRIM(kore_BusinessWiseID),'DBNULL_TEXT') + ISNULL(RTRIM(kore_BWBuildingType),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),kore_BWEmployeesAtAllSites)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),kore_BWEmployeesAtSite)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),kore_BWEstimatedSales)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),kore_BWExactSize)),'DBNULL_INT') + ISNULL(RTRIM(CONVERT(varchar(10),kore_BWInternationalBusiness)),'DBNULL_BIT') + ISNULL(RTRIM(kore_BWOwnBuilding),'DBNULL_TEXT') + ISNULL(RTRIM(kore_BWSector),'DBNULL_TEXT') + ISNULL(RTRIM(kore_BWSICDescription),'DBNULL_TEXT') + ISNULL(RTRIM(kore_BWSiteType),'DBNULL_TEXT') + ISNULL(RTRIM(kore_BWStartYear),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),kore_BWTotalSites)),'DBNULL_INT') + ISNULL(RTRIM(kore_coordinatorid),'DBNULL_TEXT') + ISNULL(RTRIM(kore_countryid),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),kore_CreatedByAccountAlias)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),kore_CurrentlyBeingWorked)),'DBNULL_BIT') + ISNULL(RTRIM(kore_ExternalAccountID),'DBNULL_TEXT') + ISNULL(RTRIM(kore_externalreportingpartnerid),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),kore_HasCheckedOutContact)),'DBNULL_BIT') + ISNULL(RTRIM(kore_Headquarters),'DBNULL_TEXT') + ISNULL(RTRIM(kore_industryid),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),KORE_LastContacted)),'DBNULL_DATETIME') + ISNULL(RTRIM(KORE_lastcontactedactivityid),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),KORE_LastSync)),'DBNULL_DATETIME') + ISNULL(RTRIM(KORE_LegalName),'DBNULL_TEXT') + ISNULL(RTRIM(kore_NBACategoryId),'DBNULL_TEXT') + ISNULL(RTRIM(kore_NBASponsorId),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),KORE_NextContact)),'DBNULL_DATETIME') + ISNULL(RTRIM(KORE_nextcontactactivityid),'DBNULL_TEXT') + ISNULL(RTRIM(kore_salespersonid),'DBNULL_TEXT') + ISNULL(RTRIM(kore_sourcemarketinglistid),'DBNULL_TEXT') + ISNULL(RTRIM(KORE_SponsorAccountNumber),'DBNULL_TEXT') + ISNULL(RTRIM(KORE_StateofIncorporation),'DBNULL_TEXT') + ISNULL(RTRIM(KORE_StateofIncorporationId),'DBNULL_TEXT') + ISNULL(RTRIM(kore_stateorprovinceid),'DBNULL_TEXT') + ISNULL(RTRIM(kore_StrippedName),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),kore_TaxExemptStatus)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),KORE_telephone1dncstatus)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),KORE_telephone2dncstatus)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),KORE_telephone3dncstatus)),'DBNULL_BIT') + ISNULL(RTRIM(CONVERT(varchar(10),KORE_Type)),'DBNULL_INT') + ISNULL(RTRIM(kore_USOffice),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(10),li_CompanyId)),'DBNULL_INT') + ISNULL(RTRIM(new_ExternalCoordinator),'DBNULL_TEXT') + ISNULL(RTRIM(new_GeoGroup),'DBNULL_TEXT') + ISNULL(RTRIM(new_MetroArea),'DBNULL_TEXT') + ISNULL(RTRIM(new_SponsorshipRep),'DBNULL_TEXT') + ISNULL(RTRIM(new_ZipcodeId),'DBNULL_TEXT'))


CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (AccountId)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)



MERGE ProdCopy.AccountExtensionBase AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON myTarget.AccountId = mySource.AccountId

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
      myTarget.[ETL_UpdatedDate] = @RunTime
     ,myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
     ,myTarget.[AccountId] = mySource.[AccountId]
     ,myTarget.[KORE_address1_telephone1dncstatus] = mySource.[KORE_address1_telephone1dncstatus]
     ,myTarget.[KORE_address1_telephone2dncstatus] = mySource.[KORE_address1_telephone2dncstatus]
     ,myTarget.[KORE_address1_telephone3dncstatus] = mySource.[KORE_address1_telephone3dncstatus]
     ,myTarget.[KORE_address2_telephone1dncstatus] = mySource.[KORE_address2_telephone1dncstatus]
     ,myTarget.[KORE_address2_telephone2dncstatus] = mySource.[KORE_address2_telephone2dncstatus]
     ,myTarget.[KORE_address2_telephone3dncstatus] = mySource.[KORE_address2_telephone3dncstatus]
     ,myTarget.[KORE_LastContacted] = mySource.[KORE_LastContacted]
     ,myTarget.[KORE_lastcontactedactivityid] = mySource.[KORE_lastcontactedactivityid]
     ,myTarget.[KORE_LastSync] = mySource.[KORE_LastSync]
     ,myTarget.[KORE_LegalName] = mySource.[KORE_LegalName]
     ,myTarget.[KORE_NextContact] = mySource.[KORE_NextContact]
     ,myTarget.[KORE_nextcontactactivityid] = mySource.[KORE_nextcontactactivityid]
     ,myTarget.[kore_StrippedName] = mySource.[kore_StrippedName]
     ,myTarget.[KORE_telephone1dncstatus] = mySource.[KORE_telephone1dncstatus]
     ,myTarget.[KORE_telephone2dncstatus] = mySource.[KORE_telephone2dncstatus]
     ,myTarget.[KORE_telephone3dncstatus] = mySource.[KORE_telephone3dncstatus]
     ,myTarget.[KORE_Type] = mySource.[KORE_Type]
     ,myTarget.[kore_billingcontactid] = mySource.[kore_billingcontactid]
     ,myTarget.[kore_countryid] = mySource.[kore_countryid]
     ,myTarget.[kore_stateorprovinceid] = mySource.[kore_stateorprovinceid]
     ,myTarget.[kore_sourcemarketinglistid] = mySource.[kore_sourcemarketinglistid]
     ,myTarget.[kore_coordinatorid] = mySource.[kore_coordinatorid]
     ,myTarget.[kore_CreatedByAccountAlias] = mySource.[kore_CreatedByAccountAlias]
     ,myTarget.[kore_CurrentlyBeingWorked] = mySource.[kore_CurrentlyBeingWorked]
     ,myTarget.[kore_HasCheckedOutContact] = mySource.[kore_HasCheckedOutContact]
     ,myTarget.[kore_BusinessWiseID] = mySource.[kore_BusinessWiseID]
     ,myTarget.[kore_BWBuildingType] = mySource.[kore_BWBuildingType]
     ,myTarget.[kore_BWEmployeesAtAllSites] = mySource.[kore_BWEmployeesAtAllSites]
     ,myTarget.[kore_BWEmployeesAtSite] = mySource.[kore_BWEmployeesAtSite]
     ,myTarget.[kore_BWEstimatedSales] = mySource.[kore_BWEstimatedSales]
     ,myTarget.[kore_BWExactSize] = mySource.[kore_BWExactSize]
     ,myTarget.[kore_BWInternationalBusiness] = mySource.[kore_BWInternationalBusiness]
     ,myTarget.[kore_BWOwnBuilding] = mySource.[kore_BWOwnBuilding]
     ,myTarget.[kore_BWSector] = mySource.[kore_BWSector]
     ,myTarget.[kore_BWSICDescription] = mySource.[kore_BWSICDescription]
     ,myTarget.[kore_BWSiteType] = mySource.[kore_BWSiteType]
     ,myTarget.[kore_BWStartYear] = mySource.[kore_BWStartYear]
     ,myTarget.[kore_BWTotalSites] = mySource.[kore_BWTotalSites]
     ,myTarget.[cdi_allowtextmessages] = mySource.[cdi_allowtextmessages]
     ,myTarget.[new_MetroArea] = mySource.[new_MetroArea]
     ,myTarget.[new_GeoGroup] = mySource.[new_GeoGroup]
     ,myTarget.[new_ZipcodeId] = mySource.[new_ZipcodeId]
     ,myTarget.[new_ExternalCoordinator] = mySource.[new_ExternalCoordinator]
     ,myTarget.[kore_industryid] = mySource.[kore_industryid]
     ,myTarget.[new_SponsorshipRep] = mySource.[new_SponsorshipRep]
     ,myTarget.[kore_ExternalAccountID] = mySource.[kore_ExternalAccountID]
     ,myTarget.[li_CompanyId] = mySource.[li_CompanyId]
     ,myTarget.[kore_TaxExemptStatus] = mySource.[kore_TaxExemptStatus]
     ,myTarget.[KORE_Agency] = mySource.[KORE_Agency]
     ,myTarget.[KORE_AuthorizedSignor] = mySource.[KORE_AuthorizedSignor]
     ,myTarget.[kore_Headquarters] = mySource.[kore_Headquarters]
     ,myTarget.[KORE_SponsorAccountNumber] = mySource.[KORE_SponsorAccountNumber]
     ,myTarget.[KORE_StateofIncorporation] = mySource.[KORE_StateofIncorporation]
     ,myTarget.[kore_USOffice] = mySource.[kore_USOffice]
     ,myTarget.[KORE_AgencyId] = mySource.[KORE_AgencyId]
     ,myTarget.[kore_authorizedsignorid] = mySource.[kore_authorizedsignorid]
     ,myTarget.[kore_externalreportingpartnerid] = mySource.[kore_externalreportingpartnerid]
     ,myTarget.[kore_NBACategoryId] = mySource.[kore_NBACategoryId]
     ,myTarget.[kore_NBASponsorId] = mySource.[kore_NBASponsorId]
     ,myTarget.[KORE_StateofIncorporationId] = mySource.[KORE_StateofIncorporationId]
     ,myTarget.[kore_salespersonid] = mySource.[kore_salespersonid]
     ,myTarget.[client_gpaccountnumber] = mySource.[client_gpaccountnumber]
     ,myTarget.[client_GPCustomerClass] = mySource.[client_GPCustomerClass]
     ,myTarget.[client_syncedwithgp] = mySource.[client_syncedwithgp]
     ,myTarget.[client_triggergp] = mySource.[client_triggergp]
     
WHEN NOT MATCHED BY TARGET
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_IsDeleted]
     ,[ETL_DeletedDate]
     ,[ETL_DeltaHashKey]
     ,[AccountId]
     ,[KORE_address1_telephone1dncstatus]
     ,[KORE_address1_telephone2dncstatus]
     ,[KORE_address1_telephone3dncstatus]
     ,[KORE_address2_telephone1dncstatus]
     ,[KORE_address2_telephone2dncstatus]
     ,[KORE_address2_telephone3dncstatus]
     ,[KORE_LastContacted]
     ,[KORE_lastcontactedactivityid]
     ,[KORE_LastSync]
     ,[KORE_LegalName]
     ,[KORE_NextContact]
     ,[KORE_nextcontactactivityid]
     ,[kore_StrippedName]
     ,[KORE_telephone1dncstatus]
     ,[KORE_telephone2dncstatus]
     ,[KORE_telephone3dncstatus]
     ,[KORE_Type]
     ,[kore_billingcontactid]
     ,[kore_countryid]
     ,[kore_stateorprovinceid]
     ,[kore_sourcemarketinglistid]
     ,[kore_coordinatorid]
     ,[kore_CreatedByAccountAlias]
     ,[kore_CurrentlyBeingWorked]
     ,[kore_HasCheckedOutContact]
     ,[kore_BusinessWiseID]
     ,[kore_BWBuildingType]
     ,[kore_BWEmployeesAtAllSites]
     ,[kore_BWEmployeesAtSite]
     ,[kore_BWEstimatedSales]
     ,[kore_BWExactSize]
     ,[kore_BWInternationalBusiness]
     ,[kore_BWOwnBuilding]
     ,[kore_BWSector]
     ,[kore_BWSICDescription]
     ,[kore_BWSiteType]
     ,[kore_BWStartYear]
     ,[kore_BWTotalSites]
     ,[cdi_allowtextmessages]
     ,[new_MetroArea]
     ,[new_GeoGroup]
     ,[new_ZipcodeId]
     ,[new_ExternalCoordinator]
     ,[kore_industryid]
     ,[new_SponsorshipRep]
     ,[kore_ExternalAccountID]
     ,[li_CompanyId]
     ,[kore_TaxExemptStatus]
     ,[KORE_Agency]
     ,[KORE_AuthorizedSignor]
     ,[kore_Headquarters]
     ,[KORE_SponsorAccountNumber]
     ,[KORE_StateofIncorporation]
     ,[kore_USOffice]
     ,[KORE_AgencyId]
     ,[kore_authorizedsignorid]
     ,[kore_externalreportingpartnerid]
     ,[kore_NBACategoryId]
     ,[kore_NBASponsorId]
     ,[KORE_StateofIncorporationId]
     ,[kore_salespersonid]
     ,[client_gpaccountnumber]
     ,[client_GPCustomerClass]
     ,[client_syncedwithgp]
     ,[client_triggergp]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,0 --ETL_DeletedDate
     ,NULL --ETL_DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[AccountId]
     ,mySource.[KORE_address1_telephone1dncstatus]
     ,mySource.[KORE_address1_telephone2dncstatus]
     ,mySource.[KORE_address1_telephone3dncstatus]
     ,mySource.[KORE_address2_telephone1dncstatus]
     ,mySource.[KORE_address2_telephone2dncstatus]
     ,mySource.[KORE_address2_telephone3dncstatus]
     ,mySource.[KORE_LastContacted]
     ,mySource.[KORE_lastcontactedactivityid]
     ,mySource.[KORE_LastSync]
     ,mySource.[KORE_LegalName]
     ,mySource.[KORE_NextContact]
     ,mySource.[KORE_nextcontactactivityid]
     ,mySource.[kore_StrippedName]
     ,mySource.[KORE_telephone1dncstatus]
     ,mySource.[KORE_telephone2dncstatus]
     ,mySource.[KORE_telephone3dncstatus]
     ,mySource.[KORE_Type]
     ,mySource.[kore_billingcontactid]
     ,mySource.[kore_countryid]
     ,mySource.[kore_stateorprovinceid]
     ,mySource.[kore_sourcemarketinglistid]
     ,mySource.[kore_coordinatorid]
     ,mySource.[kore_CreatedByAccountAlias]
     ,mySource.[kore_CurrentlyBeingWorked]
     ,mySource.[kore_HasCheckedOutContact]
     ,mySource.[kore_BusinessWiseID]
     ,mySource.[kore_BWBuildingType]
     ,mySource.[kore_BWEmployeesAtAllSites]
     ,mySource.[kore_BWEmployeesAtSite]
     ,mySource.[kore_BWEstimatedSales]
     ,mySource.[kore_BWExactSize]
     ,mySource.[kore_BWInternationalBusiness]
     ,mySource.[kore_BWOwnBuilding]
     ,mySource.[kore_BWSector]
     ,mySource.[kore_BWSICDescription]
     ,mySource.[kore_BWSiteType]
     ,mySource.[kore_BWStartYear]
     ,mySource.[kore_BWTotalSites]
     ,mySource.[cdi_allowtextmessages]
     ,mySource.[new_MetroArea]
     ,mySource.[new_GeoGroup]
     ,mySource.[new_ZipcodeId]
     ,mySource.[new_ExternalCoordinator]
     ,mySource.[kore_industryid]
     ,mySource.[new_SponsorshipRep]
     ,mySource.[kore_ExternalAccountID]
     ,mySource.[li_CompanyId]
     ,mySource.[kore_TaxExemptStatus]
     ,mySource.[KORE_Agency]
     ,mySource.[KORE_AuthorizedSignor]
     ,mySource.[kore_Headquarters]
     ,mySource.[KORE_SponsorAccountNumber]
     ,mySource.[KORE_StateofIncorporation]
     ,mySource.[kore_USOffice]
     ,mySource.[KORE_AgencyId]
     ,mySource.[kore_authorizedsignorid]
     ,mySource.[kore_externalreportingpartnerid]
     ,mySource.[kore_NBACategoryId]
     ,mySource.[kore_NBASponsorId]
     ,mySource.[KORE_StateofIncorporationId]
     ,mySource.[kore_salespersonid]
     ,mySource.[client_gpaccountnumber]
     ,mySource.[client_GPCustomerClass]
     ,mySource.[client_syncedwithgp]
     ,mySource.[client_triggergp]
     )
;



DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ProdCopy.AccountExtensionBase WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ProdCopy.AccountExtensionBase WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	


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
