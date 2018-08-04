SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/******************************************************************************************************************
Created by CTW 1/16/2018 
Updated by Bulent Gucuk 3/06/2018
*******************************************************************************************************************/

CREATE PROCEDURE [etl].[sp_Load_ods_IMC_SourceData_Customer]
AS
SET NOCOUNT ON;
IF OBJECT_ID('tempdb..#AllEmails') IS NOT NULL
    DROP TABLE #AllEmails;

SELECT DISTINCT
        dc.EmailPrimary ,
        ssbid.SSB_CRMSYSTEM_CONTACT_ID 
		--,ROW_NUMBER() OVER (PARTITION BY dc.EmailPrimary ORDER BY ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG DESC) EmailRank 
INTO    #AllEmails
FROM    dbo.DimCustomer dc ( NOLOCK )
        JOIN dbo.dimcustomerssbid ssbid ON ssbid.DimCustomerId = dc.DimCustomerId
WHERE   dc.EmailPrimary IS NOT NULL
AND		dc.EmailPrimary <> ''
AND		dc.EmailPrimaryIsCleanStatus NOT LIKE 'Invalid%'; 
--GROUP BY dc.EmailPrimary ,
--        ssbid.SSB_CRMSYSTEM_CONTACT_ID 
		 --,ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG
--1310022		 
; 

IF OBJECT_ID('tempdb..#BaseData') IS NOT NULL
    DROP TABLE #BaseData;
SELECT  dcm.DimCustomerId,
		ae.EmailPrimary ,
        ae.SSB_CRMSYSTEM_CONTACT_ID ,
        dcm.FirstName ,
        dcm.LastName ,
		dcm.MiddleName,
		dcm.FullName,
		dcm.Suffix,
        dcm.AddressPrimaryStreet ,
        dcm.AddressPrimarySuite ,
        dcm.AddressPrimaryCity ,
        dcm.AddressPrimaryState ,
        dcm.AddressPrimaryZip ,
        dcm.AddressPrimaryCounty ,
        dcm.AddressPrimaryCountry ,
        dcm.PhonePrimary ,
        dcm.PhoneCell ,
		dcm.PhoneBusiness,
        dcm.Gender ,
        dcm.Birthday
INTO    #BaseData
FROM    dbo.vwCompositeRecord_ModAcctID dcm
        JOIN #AllEmails ae ON ae.SSB_CRMSYSTEM_CONTACT_ID = dcm.SSB_CRMSYSTEM_CONTACT_ID
                              AND ae.EmailPrimary = dcm.EmailPrimary
CREATE NONCLUSTERED INDEX IDX_Dimcustid
ON #BaseData (DimCustomerId);
--SELECT SSB_CRMSYSTEM_CONTACT_ID, COUNT(EmailPrimary) FROM #BaseData
--GROUP BY SSB_CRMSYSTEM_CONTACT_ID
--ORDER BY COUNT(EmailPrimary) DESC

--SELECT * FROM #BaseData WHERE SSB_CRMSYSTEM_CONTACT_ID = '400FF48E-FC90-40C3-A066-BEFF8D16E530'

IF OBJECT_ID('tempdb..#FinalData') IS NOT NULL
    DROP TABLE #FinalData;
SELECT DISTINCT
    bd.*,
	dc.EmailPrimary dcemail,
	dc.CD_Gender,
    dc.CreatedDate,
    dc.UpdatedDate,
    ROW_NUMBER() OVER (PARTITION BY bd.EmailPrimary
                       ORDER BY dc.SSUpdatedDate DESC,
                                dc.AccountId ASC,
                                dc.SSCreatedDate ASC,
								dc.SSID ASC 
								
                      ) EmailRank
INTO #FinalData
FROM #BaseData bd
    LEFT JOIN dbo.DimCustomer dc (NOLOCK)
        ON dc.DimCustomerId = bd.DimCustomerId;
--SELECT * FROM #FinalData WHERE EmailPrimary  IN ( 'luustruck08@yahoo.com',
--'blandatl@comcast.net')
--ORDER BY emailprimary
--TRUNCATE TABLE ods.IMC_SourceData
--SELECT EmailPrimary, COUNT(*) FROM #FinalData
--GROUP BY EmailPrimary
--ORDER BY COUNT(*) DESC



--SELECT * FROM #FinalData WHERE EmailPrimary='ed@southernsprinklers.com'
--ORDER BY EmailRank ASC

IF OBJECT_ID('tempdb..#Staged') IS NOT NULL
    DROP TABLE #Staged;
CREATE TABLE #Staged
    (
      [EMAIL] NVARCHAR(500) ,
      [Address1_City] NVARCHAR(500) ,
      [Address1_Country] NVARCHAR(500) ,
      [Address1_County] NVARCHAR(500) ,
      [Address1_Line1] NVARCHAR(500) ,
      [Address1_Line2] NVARCHAR(500) ,
      [Address1_Line3] NVARCHAR(500) ,
      [Address1_PostalCode] NVARCHAR(500) ,
      [Address1_StateOrProvince] NVARCHAR(500) ,
      [BirthDate] VARCHAR(25) ,
      [FirstName] NVARCHAR(500) ,
      [FullName] NVARCHAR(500) ,
	  [GenderCode] NVARCHAR(500),
      LastName NVARCHAR(500) ,
      MiddleName NVARCHAR(500) ,
      MobilePhone NVARCHAR(500) ,
      [Suffix] NVARCHAR(500) ,
      [Telephone1] NVARCHAR(500) ,
      [Telephone2] NVARCHAR(500) 
    );
INSERT  INTO #Staged
        ( 
          EMAIL ,
          Address1_City ,
          Address1_Country ,
          Address1_County ,
          Address1_Line1 ,
          Address1_Line2 ,
          Address1_Line3 ,
          Address1_PostalCode ,
          Address1_StateOrProvince ,
          BirthDate ,
          FirstName ,
          FullName ,
          GenderCode ,
          LastName ,
          MiddleName ,
          MobilePhone ,
          Suffix ,
          Telephone1 ,
          Telephone2 
        )
        SELECT 
                dc.EmailPrimary Email ,
                CASE WHEN ISNULL(dc.AddressPrimaryCity, '') <> ''
                     THEN dc.AddressPrimaryCity
                     ELSE ''
                END AS Address1_city ,
                CASE WHEN ISNULL(dc.AddressPrimaryCountry, '') <> ''
                     THEN dc.AddressPrimaryCountry
                     ELSE ''
                END AS Address1_Country ,
                CASE WHEN ISNULL(dc.AddressPrimaryCounty, '') <> ''
                     THEN dc.AddressPrimaryCounty
                     ELSE ''
                END AS Address1_County ,
                CASE WHEN ISNULL(dc.AddressPrimaryStreet, '') <> ''
                     THEN dc.AddressPrimaryStreet
                     ELSE ''
                END AS Address1_Line1 ,
                CASE WHEN ISNULL(dc.AddressPrimarySuite, '') <> ''
                     THEN dc.AddressPrimarySuite
                     ELSE ''
                END AS Address1_Line2 ,
				'' AS Address1_Line3 ,
                CASE WHEN ISNULL(dc.AddressPrimaryZip, '') <> ''
                     THEN dc.AddressPrimaryZip
                     ELSE ''
                END AS Address1_PostalCode ,
                CASE WHEN ISNULL(dc.AddressPrimaryState, '') <> ''
                     THEN dc.AddressPrimaryState
                     ELSE ''
                END AS Address1_StateorProvince ,
                CASE WHEN ISNULL(dc.Birthday, '') <> ''
                     THEN CONVERT(VARCHAR(10), dc.Birthday, 101)
                     ELSE NULL
                END AS Birthdate ,
                CASE WHEN ISNULL(dc.FirstName, '') <> '' THEN dc.FirstName
                     ELSE ''
                END AS FirstName ,
                dc.FullName ,
                dc.CD_Gender ,
                CASE WHEN ISNULL(dc.LastName, '') <> '' THEN dc.LastName
                     ELSE ''
                END AS LastName ,
                dc.MiddleName ,
                CASE WHEN ISNULL(dc.PhoneCell, '') <> '' THEN dc.PhoneCell
                     ELSE NULL
                END AS mobilephone ,
                dc.Suffix ,
                CASE WHEN ISNULL(dc.PhonePrimary, '') <> ''
                     THEN dc.PhonePrimary
                     ELSE NULL
                END AS telephone1 ,
                CASE WHEN ISNULL(dc.PhoneBusiness,'') <>''
					THEN dc.PhoneBusiness
					ELSE NULL
				END AS telephone2 
        FROM    #FinalData dc
			LEFT OUTER JOIN ods.IMC_ProductionCopy_MasterDB AS IMC ON dc.EmailPrimary = imc.Email
        WHERE   (dc.EmailRank = 1
                AND (  dc.CreatedDate >= DATEADD(HOUR, -5, GETDATE())
                    OR dc.UpdatedDate >= DATEADD(HOUR, -5, GETDATE())
                    ))
				OR (dc.EmailRank=1
				AND IMC.Email IS NULL);
				;
--SELECT * FROM #Staged WHERE Email IN ( 'ty.sowell@gmail.com','blandatl@comcast.net')
--SELECT EMAIL, COUNT(*) totals FROM #Staged
--GROUP BY EMAIL
--HAVING COUNT(*)>1

--SELECT * FROM #FinalData WHERE EmailPrimary IN ( 'ed@southernsprinklers.com','klattin@holderproperties.com')
--ORDER BY EmailPrimary, SSB_CRMSYSTEM_CONTACT_ID, EmailRank


UPDATE myTarget 
SET myTarget.[Address1_City] = mySource.[Address1_City] ,
	myTarget.[Address1_Country] = mySource.[Address1_Country] ,
	myTarget.[Address1_County] = mySource.[Address1_County] ,
	myTarget.[Address1_Line1] = mySource.[Address1_Line1] ,
	myTarget.[Address1_Line2] = mySource.[Address1_Line2] ,
	myTarget.[Address1_Line3] = mySource.[Address1_Line3] ,
	myTarget.[Address1_PostalCode] = mySource.[Address1_PostalCode] ,
	myTarget.[Address1_StateOrProvince] = mySource.[Address1_StateOrProvince] ,
	myTarget.[BirthDate] = mySource.[BirthDate] ,
	myTarget.[FirstName] = mySource.[FirstName] ,
	myTarget.[FullName] = mySource.[FullName] ,
	myTarget.[GenderCode] = mySource.[GenderCode] ,
	myTarget.[LastName] = mySource.[LastName] ,
	myTarget.[MiddleName] = mySource.[MiddleName] ,
	myTarget.[MobilePhone] = mySource.[MobilePhone] ,
	myTarget.[Suffix] = mySource.[Suffix] ,
	myTarget.[Telephone1] = mySource.[Telephone1] ,
	myTarget.[Telephone2] = mySource.[Telephone2],
	myTarget.ETL__UpdatedDate = GETDATE()
FROM	[ods].[IMC_SourceData_Customer] AS myTarget
	INNER JOIN #Staged AS mySource ON myTarget.EMAIL = mySource.EMAIL;

INSERT INTO [ods].[IMC_SourceData_Customer] (
	EMAIL ,
	Address1_City ,
	Address1_Country ,
	Address1_County ,
	Address1_Line1 ,
	Address1_Line2 ,
	Address1_Line3 ,
	Address1_PostalCode ,
	Address1_StateOrProvince ,
	BirthDate ,
	FirstName ,
	FullName ,
	GenderCode ,
	LastName ,
	MiddleName ,
	MobilePhone ,
	Suffix ,
	Telephone1 ,
	Telephone2 ,
	ETL__CreatedDate,
	ETL__UpdatedDate)
SELECT
	mysource.EMAIL ,
	mysource.Address1_City ,
	mysource.Address1_Country ,
	mysource.Address1_County ,
	mysource.Address1_Line1 ,
	mysource.Address1_Line2 ,
	mysource.Address1_Line3 ,
	mysource.Address1_PostalCode ,
	mysource.Address1_StateOrProvince ,
	mysource.BirthDate ,
	mysource.FirstName ,
	mysource.FullName ,
	mysource.GenderCode ,
	mysource.LastName ,
	mysource.MiddleName ,
	mysource.MobilePhone ,
	mysource.Suffix ,
	mysource.Telephone1 ,
	mysource.Telephone2 ,
	GETDATE(),
	GETDATE()
FROM #Staged AS mySource
	LEFT OUTER JOIN [ods].[IMC_SourceData_Customer] AS myTarget ON myTarget.EMAIL = mySource.EMAIL
WHERE	myTarget.EMAIL IS NULL
ORDER BY mySource.EMAIL;

GO
