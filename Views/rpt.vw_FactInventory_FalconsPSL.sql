SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [rpt].[vw_FactInventory_FalconsPSL]

AS 

SELECT 
	f.FactTicketSalesId
	, f.DimEventId
	, dst.DimSeatId
	, f.DimCustomerId SoldDimCustomerId
	, f.DimDateId SoldDimDateId
	, f.DimTimeId SoldDimTimeId
	, f.DimItemId SoldDimItemId
	, f.DimPlanId SoldDimPlanId
	, f.DimPriceCodeId SoldDimPriceCodeId
	, f.DimSalesCodeId SoldDimSalesCodeId
	, f.DimPromoId SoldDimPromoId
	, f.DimTicketClassId SoldDimTicketClassId
	, f.DimLedgerId SoldDimLedgerId

	, CAST(dd.CalDate AS DATETIME) + CAST(dt.Time24 AS DATETIME) SoldDateTime
	, f.DimClassTMId SoldDimClassTMId

	, 0 IsAvailable
	, 1 IsSold
	, 0 IsHeld
	, f.IsComp

	, f.PurchasePrice TotalRevenue
	, (f.TicketRevenue / CAST(f.QtySeat as decimal(18,6))) TicketRevenue 
	, (f.PcTicket / CAST(f.QtySeat as decimal(18,6))) PcTicketValue
	, f.FullPrice FullPrice
	, (f.Discount / CAST(f.QtySeat as decimal(18,6))) Discount
	, (f.Surcharge / CAST(f.QtySeat as decimal(18,6))) Surcharge
	, f.PurchasePrice PurchasePrice
	, (f.PcPrice / CAST(f.QtySeat as decimal(18,6))) PcPrice
	, (f.PcPrintedPrice / CAST(f.QtySeat as decimal(18,6))) PcPrintedPrice
	, (f.PcTicket / CAST(f.QtySeat as decimal(18,6))) PcTicket
	, (f.PcTax / CAST(f.QtySeat as decimal(18,6))) PcTax
	, (f.PcLicenseFee / CAST(f.QtySeat as decimal(18,6))) PcLicenseFee
	, (f.PcOther1 / CAST(f.QtySeat as decimal(18,6))) PcOther1
	, (f.PcOther2 / CAST(f.QtySeat as decimal(18,6))) PcOther2
	, f.QtySeat SeatBlockSize
	, f.OrderNum SoldOrderNum
	, f.OrderLineItem SoldOrderLineItem
	, f.IsHost
	, ISNULL(dpc_st.DimPriceCodeId, -1) ManifestDimPriceCodeId
	, ISNULL(dctm.DimClassTMId, -1) ManifestDimClassTMId
	, ISNULL(dpc_st.Price, 0) ManifestSeatValue
	, ISNULL(de.DimArenaId, -1) DimArenaId, ISNULL(de.DimSeasonId, -1) DimSeasonId


	FROM dbo.FactTicketSales (NOLOCK) f
	INNER JOIN dbo.DimEvent de on f.DimEventId = de.DimEventId
	INNER JOIN dbo.DimDate dd ON dd.DimDateId = f.DimDateId
	INNER JOIN dbo.DimTime dt ON dt.DimTimeId = f.DimTimeId
	INNER JOIN dbo.DimPriceCode dpc on f.DimPriceCodeId = dpc.DimPriceCodeId
	INNER JOIN dbo.DimSeat (NOLOCK) dst 
		ON f.SSID_section_id = dst.SSID_section_id 
		AND f.SSID_row_id = dst.SSID_row_id 
		AND dst.Seat between f.SSID_seat_num and (f.SSID_seat_num + f.QtySeat - 1)
		AND f.SourceSystem = dst.SourceSystem
	LEFT OUTER JOIN dbo.DimPriceCode dpc_st ON dpc_st.SSID_event_id = de.SSID_event_id AND dpc_st.SSID_price_code = dst.DefaultPriceCode
	LEFT OUTER JOIN dbo.DimClassTM dctm ON dctm.ETL_SSID_class_id = dst.DefaultClass
	WHERE f. DimSeasonId=153 AND f.DimArenaId=34
GO
