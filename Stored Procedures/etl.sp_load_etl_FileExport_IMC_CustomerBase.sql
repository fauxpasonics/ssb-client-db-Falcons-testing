SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[sp_load_etl_FileExport_IMC_CustomerBase]
(
	@BatchId NVARCHAR(50) = '00000000-0000-0000-0000-000000000000',
	@Options NVARCHAR(MAX) = NULL
)
AS

BEGIN 


--IF OBJECT_ID('tempdb..#OptInDetails') IS NOT NULL
--	DROP TABLE #OptInDetails
--SELECT Email, MAX([Opt In Details]) details
--INTO #OptInDetails
--FROM ods.IMC_ProductionCopy_MasterDB
--GROUP BY Email

TRUNCATE TABLE etl.FileExport_IMC_CustomerBase

--DECLARE @UpdatedDate DATETIME
--SET @UpdatedDate= (SELECT MAX(ETL__UpdatedDate) FROM ods.IMC_SourceData_Customer (NOLOCK))

INSERT INTO etl.FileExport_IMC_CustomerBase
(
    EMAIL,
    Address1_City,
    Address1_Country,
    Address1_County,
    Address1_Line1,
    Address1_Line2,
    Address1_Line3,
    Address1_PostalCode,
    Address1_StateOrProvince,
    BirthDate,
    FirstName,
    FullName,
    GenderCode,
    LastName,
    MiddleName,
    MobilePhone,
    Suffix,
    Telephone1,
    Telephone2,
    [Opt In Details]
)
SELECT i.EMAIL,
       ISNULL(i.Address1_City,' '),
       ISNULL(i.Address1_Country,' '),
       ISNULL(i.Address1_County,' '),
       ISNULL(i.Address1_Line1,' '),
       ISNULL(i.Address1_Line2,' '),
       ISNULL(i.Address1_Line3,' '),
       ISNULL(i.Address1_PostalCode,' '),
       ISNULL(i.Address1_StateOrProvince,' '),
       ISNULL(i.BirthDate,' '),
       ISNULL(i.FirstName,' '),
       ISNULL(i.FullName,' '),
       ISNULL(i.GenderCode,' '),
       ISNULL(i.LastName,' '),
       ISNULL(i.MiddleName,' '),
       ISNULL(i.MobilePhone,' '),
       ISNULL(i.Suffix,' '),
       ISNULL(i.Telephone1,' '),
       ISNULL(i.Telephone2,' '),
	   --CASE WHEN o.details IS NOT NULL THEN o.details ELSE 
	   --'Added Via SSB API' 
	   --END 
	   NULL
	   AS [Opt In Details]
FROM ods.IMC_SourceData_Customer i (NOLOCK)
--LEFT JOIN #OptInDetails o ON o.Email = i.EMAIL
LEFT JOIN ods.IMC_ProductionCopy_MasterDB imc ON imc.Email = i.EMAIL
WHERE imc.Email IS NULL
OR i.ETL__UpdatedDate = DATEADD(HOUR, -24, GETDATE())

END

GO
