SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE view [rpt].[vw_DimCustomer_Base] as (select DimCustomerId,
SourceDB,
SourceSystem,
CustomerType,
CustomerStatus,
AccountType,
AccountRep,
CompanyName,
SalutationName,
DonorMailName,
DonorFormalName,
Birthday,
Gender,
Prefix,
FirstName,
MiddleName,
LastName,
Suffix,
AddressPrimaryStreet,
AddressPrimaryCity,
AddressPrimaryState,
AddressPrimaryZip,
AddressPrimaryCounty,
AddressPrimaryCountry,
AddressOneStreet,
AddressOneCity,
AddressOneState,
AddressOneZip,
AddressOneCounty,
AddressOneCountry,
PhonePrimary,
PhoneHome,
PhoneCell,
PhoneBusiness,
PhoneFax,
PhoneOther,
EmailPrimary,
EmailOne,
EmailTwo,
SSCreatedBy,
SSUpdatedBy,
SSCreatedDate,
SSUpdatedDate,
AccountId,
AddressPrimaryNCOAStatus,
AddressOneStreetNCOAStatus,
AddressTwoStreetNCOAStatus,
AddressThreeStreetNCOAStatus,
AddressFourStreetNCOAStatus from dbo.DimCustomer (nolock) where IsDeleted = 0)


GO
