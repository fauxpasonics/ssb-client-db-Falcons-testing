SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [rpt].[vw_MV_FactTicketSales_ATLUTD_HM] AS (
	SELECT DimSeatId, SeatKey, DefaultPriceCode, PriceCodeDescription, saledate, accountid, PlanCode, SectionName, RowName, seat, pc1, pc2, pc3, pc4, isavailable,
           issold, iscomp, TotalRevenue, QtyFSE, TotalPaidAmount, TotalOwedAmount, HeldDimPriceCodeId, HeldDimClassTMId, HeldSeatValue, IsReserved, usr, invoice_id,
           hours_held, plan_datetime, invoice_date, sell_location_code, sell_location_name 
	FROM rpt.MV_FactTicketSales_ATLUTD_HM (NOLOCK)
)
GO
