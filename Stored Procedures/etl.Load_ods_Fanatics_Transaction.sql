SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_ods_Fanatics_Transaction]
(
	@BatchId INT = 0,
	@Options NVARCHAR(MAX) = null
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     SSBCLOUD\dhorstman
Date:     01/27/2017
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName NVARCHAR(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount INT = ISNULL((SELECT CONVERT(VARCHAR, COUNT(*)) FROM stg.Fanatics_Transaction),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey, ETL_FileName, OrderId, OrderType, OrderFirstName, OrderLastName, OrderEmail, EmailOptIn, ClientId, OrderDate, ProductCategory, ProductSubCategory, ProductId,
	ProductDescription, QuantitySold, UnitPrice, ExtendedPrice, OrderDiscountTotal, OrderSubTotal, OrderTaxableSubTotal, OrderNonTaxableSubTotal, OrderTaxTotal, OrderTotal, OrderShipTotal,
	OrderTotalPaidByAccount, OrderTotalPaidByFanCash, ShipAddress0, ShipAddress1, ShipAddress2, ShipAddressCity, ShipAddressState, ShipAddressCountry, ShipAddressZip, ShipAddressTel, ShipAddressAttention,
	BillAddress0, BillAddress1, BillAddress2, BillAddressCity, BillAddressState, BillAddressCountry, BillAddressZip
INTO #SrcData
FROM (
	SELECT ETL_FileName, OrderId, OrderType, OrderFirstName, OrderLastName, OrderEmail, EmailOptIn, ClientId, OrderDate, ProductCategory, ProductSubCategory, ProductId,
		ProductDescription, QuantitySold, UnitPrice, ExtendedPrice, OrderDiscountTotal, OrderSubTotal, OrderTaxableSubTotal, OrderNonTaxableSubTotal, OrderTaxTotal, OrderTotal, OrderShipTotal,
		OrderTotalPaidByAccount, OrderTotalPaidByFanCash, ShipAddress0, ShipAddress1, ShipAddress2, ShipAddressCity, ShipAddressState, ShipAddressCountry, ShipAddressZip, ShipAddressTel, ShipAddressAttention,
		BillAddress0, BillAddress1, BillAddress2, BillAddressCity, BillAddressState, BillAddressCountry, BillAddressZip,
		ROW_NUMBER() OVER (Partition By ClientId, OrderId, ProductId, QuantitySold Order By ProductSubCategory) RowNum
	FROM stg.Fanatics_Transaction
) x
WHERE RowNum = 1
;

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(BillAddress0),'DBNULL_TEXT') + ISNULL(RTRIM(BillAddress1),'DBNULL_TEXT') + ISNULL(RTRIM(BillAddress2),'DBNULL_TEXT') + ISNULL(RTRIM(BillAddressCity),'DBNULL_TEXT') + ISNULL(RTRIM(BillAddressCountry),'DBNULL_TEXT') + ISNULL(RTRIM(BillAddressState),'DBNULL_TEXT') + ISNULL(RTRIM(BillAddressZip),'DBNULL_TEXT') + ISNULL(RTRIM(ClientId),'DBNULL_TEXT') + ISNULL(RTRIM(EmailOptIn),'DBNULL_TEXT') + ISNULL(RTRIM(ETL_FileName),'DBNULL_TEXT') + ISNULL(RTRIM(ExtendedPrice),'DBNULL_TEXT') + ISNULL(RTRIM(CONVERT(varchar(25),OrderDate)),'DBNULL_DATETIME') + ISNULL(RTRIM(OrderDiscountTotal),'DBNULL_TEXT') + ISNULL(RTRIM(OrderEmail),'DBNULL_TEXT') + ISNULL(RTRIM(OrderFirstName),'DBNULL_TEXT') + ISNULL(RTRIM(OrderId),'DBNULL_TEXT') + ISNULL(RTRIM(OrderLastName),'DBNULL_TEXT') + ISNULL(RTRIM(OrderNonTaxableSubTotal),'DBNULL_TEXT') + ISNULL(RTRIM(OrderShipTotal),'DBNULL_TEXT') + ISNULL(RTRIM(OrderSubTotal),'DBNULL_TEXT') + ISNULL(RTRIM(OrderTaxableSubTotal),'DBNULL_TEXT') + ISNULL(RTRIM(OrderTaxTotal),'DBNULL_TEXT') + ISNULL(RTRIM(OrderTotal),'DBNULL_TEXT') + ISNULL(RTRIM(OrderTotalPaidByAccount),'DBNULL_TEXT') + ISNULL(RTRIM(OrderTotalPaidByFanCash),'DBNULL_TEXT') + ISNULL(RTRIM(OrderType),'DBNULL_TEXT') + ISNULL(RTRIM(ProductCategory),'DBNULL_TEXT') + ISNULL(RTRIM(ProductDescription),'DBNULL_TEXT') + ISNULL(RTRIM(ProductId),'DBNULL_TEXT') + ISNULL(RTRIM(ProductSubCategory),'DBNULL_TEXT') + ISNULL(RTRIM(QuantitySold),'DBNULL_TEXT') + ISNULL(RTRIM(ShipAddress0),'DBNULL_TEXT') + ISNULL(RTRIM(ShipAddress1),'DBNULL_TEXT') + ISNULL(RTRIM(ShipAddress2),'DBNULL_TEXT') + ISNULL(RTRIM(ShipAddressAttention),'DBNULL_TEXT') + ISNULL(RTRIM(ShipAddressCity),'DBNULL_TEXT') + ISNULL(RTRIM(ShipAddressCountry),'DBNULL_TEXT') + ISNULL(RTRIM(ShipAddressState),'DBNULL_TEXT') + ISNULL(RTRIM(ShipAddressTel),'DBNULL_TEXT') + ISNULL(RTRIM(ShipAddressZip),'DBNULL_TEXT') + ISNULL(RTRIM(UnitPrice),'DBNULL_TEXT'))


CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (ClientId, OrderId, ProductId, QuantitySold)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

MERGE ods.Fanatics_Transaction AS myTarget
USING #SrcData AS mySource
	ON myTarget.ClientId = mySource.ClientId
	AND myTarget.OrderId = mySource.OrderId
	AND myTarget.ProductId = mySource.ProductId
	AND myTarget.QuantitySold = mySource.QuantitySold

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL_DeltaHashKey, -1)
	 
)
THEN UPDATE SET
      myTarget.[ETL_UpdatedDate] = @RunTime
     ,myTarget.[ETL_DeltaHashKey] = mySource.[ETL_DeltaHashKey]
	 ,myTarget.[ETL_FileName] = mySource.[ETL_FileName]
     ,myTarget.[OrderId] = mySource.[OrderId]
     ,myTarget.[OrderType] = mySource.[OrderType]
     ,myTarget.[OrderFirstName] = mySource.[OrderFirstName]
     ,myTarget.[OrderLastName] = mySource.[OrderLastName]
     ,myTarget.[OrderEmail] = mySource.[OrderEmail]
     ,myTarget.[EmailOptIn] = mySource.[EmailOptIn]
     ,myTarget.[ClientId] = mySource.[ClientId]
     ,myTarget.[OrderDate] = mySource.[OrderDate]
     ,myTarget.[ProductCategory] = mySource.[ProductCategory]
     ,myTarget.[ProductSubCategory] = mySource.[ProductSubCategory]
     ,myTarget.[ProductId] = mySource.[ProductId]
     ,myTarget.[ProductDescription] = mySource.[ProductDescription]
     ,myTarget.[QuantitySold] = mySource.[QuantitySold]
     ,myTarget.[UnitPrice] = mySource.[UnitPrice]
     ,myTarget.[ExtendedPrice] = mySource.[ExtendedPrice]
     ,myTarget.[OrderDiscountTotal] = mySource.[OrderDiscountTotal]
     ,myTarget.[OrderSubTotal] = mySource.[OrderSubTotal]
     ,myTarget.[OrderTaxableSubTotal] = mySource.[OrderTaxableSubTotal]
     ,myTarget.[OrderNonTaxableSubTotal] = mySource.[OrderNonTaxableSubTotal]
     ,myTarget.[OrderTaxTotal] = mySource.[OrderTaxTotal]
     ,myTarget.[OrderTotal] = mySource.[OrderTotal]
     ,myTarget.[OrderShipTotal] = mySource.[OrderShipTotal]
     ,myTarget.[OrderTotalPaidByAccount] = mySource.[OrderTotalPaidByAccount]
     ,myTarget.[OrderTotalPaidByFanCash] = mySource.[OrderTotalPaidByFanCash]
     ,myTarget.[ShipAddress0] = mySource.[ShipAddress0]
     ,myTarget.[ShipAddress1] = mySource.[ShipAddress1]
     ,myTarget.[ShipAddress2] = mySource.[ShipAddress2]
     ,myTarget.[ShipAddressCity] = mySource.[ShipAddressCity]
     ,myTarget.[ShipAddressState] = mySource.[ShipAddressState]
     ,myTarget.[ShipAddressCountry] = mySource.[ShipAddressCountry]
     ,myTarget.[ShipAddressZip] = mySource.[ShipAddressZip]
     ,myTarget.[ShipAddressTel] = mySource.[ShipAddressTel]
     ,myTarget.[ShipAddressAttention] = mySource.[ShipAddressAttention]
     ,myTarget.[BillAddress0] = mySource.[BillAddress0]
     ,myTarget.[BillAddress1] = mySource.[BillAddress1]
     ,myTarget.[BillAddress2] = mySource.[BillAddress2]
     ,myTarget.[BillAddressCity] = mySource.[BillAddressCity]
     ,myTarget.[BillAddressState] = mySource.[BillAddressState]
     ,myTarget.[BillAddressCountry] = mySource.[BillAddressCountry]
     ,myTarget.[BillAddressZip] = mySource.[BillAddressZip]
     
WHEN NOT MATCHED BY TARGET
THEN INSERT
     ([ETL_CreatedDate]
     ,[ETL_UpdatedDate]
     ,[ETL_DeltaHashKey]
     ,[ETL_FileName]
     ,[OrderId]
     ,[OrderType]
     ,[OrderFirstName]
     ,[OrderLastName]
     ,[OrderEmail]
     ,[EmailOptIn]
     ,[ClientId]
     ,[OrderDate]
     ,[ProductCategory]
     ,[ProductSubCategory]
     ,[ProductId]
     ,[ProductDescription]
     ,[QuantitySold]
     ,[UnitPrice]
     ,[ExtendedPrice]
     ,[OrderDiscountTotal]
     ,[OrderSubTotal]
     ,[OrderTaxableSubTotal]
     ,[OrderNonTaxableSubTotal]
     ,[OrderTaxTotal]
     ,[OrderTotal]
     ,[OrderShipTotal]
     ,[OrderTotalPaidByAccount]
     ,[OrderTotalPaidByFanCash]
     ,[ShipAddress0]
     ,[ShipAddress1]
     ,[ShipAddress2]
     ,[ShipAddressCity]
     ,[ShipAddressState]
     ,[ShipAddressCountry]
     ,[ShipAddressZip]
     ,[ShipAddressTel]
     ,[ShipAddressAttention]
     ,[BillAddress0]
     ,[BillAddress1]
     ,[BillAddress2]
     ,[BillAddressCity]
     ,[BillAddressState]
     ,[BillAddressCountry]
     ,[BillAddressZip]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,mySource.[ETL_DeltaHashKey]
	 ,mySource.[ETL_FileName]
     ,mySource.[OrderId]
     ,mySource.[OrderType]
     ,mySource.[OrderFirstName]
     ,mySource.[OrderLastName]
     ,mySource.[OrderEmail]
     ,mySource.[EmailOptIn]
     ,mySource.[ClientId]
     ,mySource.[OrderDate]
     ,mySource.[ProductCategory]
     ,mySource.[ProductSubCategory]
     ,mySource.[ProductId]
     ,mySource.[ProductDescription]
     ,mySource.[QuantitySold]
     ,mySource.[UnitPrice]
     ,mySource.[ExtendedPrice]
     ,mySource.[OrderDiscountTotal]
     ,mySource.[OrderSubTotal]
     ,mySource.[OrderTaxableSubTotal]
     ,mySource.[OrderNonTaxableSubTotal]
     ,mySource.[OrderTaxTotal]
     ,mySource.[OrderTotal]
     ,mySource.[OrderShipTotal]
     ,mySource.[OrderTotalPaidByAccount]
     ,mySource.[OrderTotalPaidByFanCash]
     ,mySource.[ShipAddress0]
     ,mySource.[ShipAddress1]
     ,mySource.[ShipAddress2]
     ,mySource.[ShipAddressCity]
     ,mySource.[ShipAddressState]
     ,mySource.[ShipAddressCountry]
     ,mySource.[ShipAddressZip]
     ,mySource.[ShipAddressTel]
     ,mySource.[ShipAddressAttention]
     ,mySource.[BillAddress0]
     ,mySource.[BillAddress1]
     ,mySource.[BillAddress2]
     ,mySource.[BillAddressCity]
     ,mySource.[BillAddressState]
     ,mySource.[BillAddressCountry]
     ,mySource.[BillAddressZip]
     )
;



DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Fanatics_Transaction WHERE ETL_CreatedDate >= @RunTime AND ETL_UpdatedDate = ETL_CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Fanatics_Transaction WHERE ETL_UpdatedDate >= @RunTime AND ETL_UpdatedDate > ETL_CreatedDate),'0');	


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
