SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vw_sync_FactInventory] AS (

	SELECT FactInventoryId, ETL_CreatedDate, ETL_UpdatedDate, DimArenaId, DimSeasonId, DimEventId, DimSeatId, SoldDimCustomerId, SoldDimDateId, SoldDimTimeId,
           SoldDimItemId, SoldDimPlanId, SoldDimPriceCodeId, SoldDimSalesCodeId, SoldDimPromoId, SoldDimTicketClassId, SoldDateTime, SoldDimClassTMId,
           ManifestDimPriceCodeId, ManifestDimClassTMId, ManifestSeatValue, PostedDimPriceCodeId, PostedDimClassTMId, PostedSeatValue, SeatStatus, IsAvailable,
           IsSaleable, IsSold, IsHeld, IsComp, IsAttended, ScanDateTime, ScanGate, TotalRevenue, TicketRevenue, PcTicketValue, FullPrice, Discount, Surcharge,
           PurchasePrice, PcPrice, PcPrintedPrice, PcTicket, PcTax, PcLicenseFee, PcOther1, PcOther2, SeatBlockSize, SoldOrderNum, SoldOrderLineItem, EventDateTime,
           IsResold, ResoldDimCustomerId, ResoldDimDateId, ResoldDimTimeId, ResoldDateTime, ResoldPurchasePrice, ResoldFees, ResoldTotalAmount, IsHost, IsReserved,
           HeldDimPriceCodeId, HeldDimClassTMId, HeldSeatValue, SoldDimLedgerId, FactTicketSalesId
	FROM dbo.FactInventory (NOLOCK)

)
GO
