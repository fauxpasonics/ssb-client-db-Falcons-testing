SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[Cust_Refresh_MV_FactTicketSales_ATLUTD_HM]

AS
BEGIN

	SELECT [DimSeatId], [SeatKey], [DefaultPriceCode], [PriceCodeDescription], [saledate], [accountid], [PlanCode], [SectionName],   

	[RowName], [seat], [pc1], [pc2], [pc3], [pc4], [isavailable], [issold], [iscomp], [TotalRevenue], [QtyFSE], [TotalPaidAmount], [TotalOwedAmount], 

	[HeldDimPriceCodeId], [HeldDimClassTMId], [HeldSeatValue], [IsReserved], [usr], [invoice_id], 
	[hours_held], [plan_datetime], [invoice_date], [sell_location_code], [sell_location_name] 
	INTO #SrcData
	FROM [rpt].[vw_FactTicketSales_ATLUTD_HM]

	CREATE NONCLUSTERED INDEX IDX_DimSeatId ON #SrcData (DimSeatId)

	MERGE rpt.MV_FactTicketSales_ATLUTD_HM AS myTarget

	USING (
		SELECT * FROM #SrcData
	) AS mySource
    
		ON myTarget.DimSeatId = mySource.DimSeatId

	WHEN MATCHED     

	THEN UPDATE SET

		myTarget.DimSeatId = mySource.DimSeatId
		, myTarget.SeatKey = mySource.SeatKey
		, myTarget.DefaultPriceCode = mySource.DefaultPriceCode
		, myTarget.PriceCodeDescription = mySource.PriceCodeDescription
		, myTarget.saledate = mySource.saledate
		, myTarget.accountid = mySource.accountid
		, myTarget.PlanCode = mySource.PlanCode
		, myTarget.SectionName = mySource.SectionName
		, myTarget.RowName = mySource.RowName
		, myTarget.seat = mySource.seat
		, myTarget.pc1 = mySource.pc1
		, myTarget.pc2 = mySource.pc2
		, myTarget.pc3 = mySource.pc3
		, myTarget.pc4 = mySource.pc4
		, myTarget.isavailable = mySource.isavailable
		, myTarget.issold = mySource.issold
		, myTarget.iscomp = mySource.iscomp
		, myTarget.TotalRevenue = mySource.TotalRevenue
		, myTarget.QtyFSE = mySource.QtyFSE
		, myTarget.TotalPaidAmount = mySource.TotalPaidAmount
		, myTarget.TotalOwedAmount = mySource.TotalOwedAmount
		, myTarget.HeldDimPriceCodeId = mySource.HeldDimPriceCodeId
		, myTarget.HeldDimClassTMId = mySource.HeldDimClassTMId
		, myTarget.HeldSeatValue = mySource.HeldSeatValue
		, myTarget.IsReserved = mySource.IsReserved
		, myTarget.usr = mySource.usr
		, myTarget.invoice_id = mySource.invoice_id
		, myTarget.hours_held = mySource.hours_held
		, myTarget.plan_datetime = mySource.plan_datetime
		, myTarget.invoice_date = mySource.invoice_date
		, myTarget.sell_location_code = mySource.sell_location_code
		, myTarget.sell_location_name = mySource.sell_location_name
    
	WHEN NOT MATCHED BY SOURCE THEN DELETE

	WHEN NOT MATCHED BY TARGET
	THEN INSERT
		 ( DimSeatId, SeatKey, DefaultPriceCode, PriceCodeDescription, saledate, accountid, PlanCode, SectionName, RowName, seat, pc1, pc2, pc3, pc4, isavailable, issold, iscomp, TotalRevenue, QtyFSE, TotalPaidAmount, TotalOwedAmount, HeldDimPriceCodeId, HeldDimClassTMId, HeldSeatValue, IsReserved, usr, invoice_id, hours_held, plan_datetime, invoice_date, sell_location_code, sell_location_name )
	VALUES
		 (
			mySource.DimSeatId
			, mySource.SeatKey
			, mySource.DefaultPriceCode
			, mySource.PriceCodeDescription
			, mySource.saledate
			, mySource.accountid
			, mySource.PlanCode
			, mySource.SectionName
			, mySource.RowName
			, mySource.seat
			, mySource.pc1
			, mySource.pc2
			, mySource.pc3
			, mySource.pc4
			, mySource.isavailable
			, mySource.issold
			, mySource.iscomp
			, mySource.TotalRevenue
			, mySource.QtyFSE
			, mySource.TotalPaidAmount
			, mySource.TotalOwedAmount
			, mySource.HeldDimPriceCodeId
			, mySource.HeldDimClassTMId
			, mySource.HeldSeatValue
			, mySource.IsReserved
			, mySource.usr
			, mySource.invoice_id
			, mySource.hours_held
			, mySource.plan_datetime
			, mySource.invoice_date
			, mySource.sell_location_code
			, mySource.sell_location_name
		 )
	;


	EXECUTE dbo.IndexOptimize
	@Databases = 'AMBSE',
	@FragmentationLow = NULL,
	@FragmentationMedium = 'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
	@FragmentationHigh = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
	@FragmentationLevel1 = 10,
	@FragmentationLevel2 = 40	


END




GO
