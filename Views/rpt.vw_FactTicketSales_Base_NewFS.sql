SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [rpt].[vw_FactTicketSales_Base_NewFS] AS (


SELECT 

	--(SELECT * FROM master.[dbo].[GetMaxDateValue] (f.UpdatedDate, ds.UpdatedDate, dpc.UpdatedDate, di.UpdatedDate, dpl.UpdatedDate, dc.UpdatedDate, dst.UpdatedDate, dctm.ETL_UpdatedDate, dsc.UpdatedDate, pt.UpdatedDate, tt.UpdatedDate, dstp.UpdatedDate, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)) ETL_UpdatedDate
   	
	( CAST(dd.CalDate AS DATETIME) + CAST(dt.Time24 AS DATETIME) ) SaleDateTime,
    dc.AccountId Archtics_acct_id, dc.FirstName, dc.LastName, dc.AccountRep,
	--, deh.EventName EventHeaderName
    de.EventCode, de.EventName, de.EventDate, dpl.PlanCode, dpl.PlanName, dpc.PriceCode,
	dst.SectionName, dst.RowName, dst.Seat, dstp.SeatTypeCode,
    CASE WHEN tt.TicketTypeCode = 'FS' THEN tt.TicketTypeName + ' ' + pt.PlanTypeName
         ELSE tt.TicketTypeName
    END TicketClass, f.QtySeat, f.QtySeatFSE, f.TotalRevenue,
     f.PaidAmount, f.OwedAmount, f.CompCode, f.CompName, f.IsComp, f.IsHost, f.IsPremium, f.IsSingleEvent, f.IsPlan, f.IsPartial,
    f.IsGroup, f.IsRenewal
	

--SELECT count(*)

FROM
    rpt.vw_FactTicketSales f
    INNER JOIN rpt.vw_DimSeason ds ON ds.DimSeasonId = f.DimSeasonId
    INNER JOIN rpt.vw_DimEvent de ON de.DimEventId = f.DimEventId
    INNER JOIN rpt.vw_DimPriceCode dpc ON dpc.DimPriceCodeId = f.DimPriceCodeId
    INNER JOIN rpt.vw_DimItem di ON di.DimItemId = f.DimItemId
    INNER JOIN rpt.vw_DimPlan dpl ON dpl.DimPlanId = f.DimPlanId
    INNER JOIN rpt.vw_DimCustomer dc ON dc.DimCustomerId = f.DimCustomerId
    INNER JOIN rpt.vw_DimSeat dst ON dst.DimSeatId = f.DimSeatIdStart
    INNER JOIN rpt.vw_DimDate dd ON dd.DimDateId = f.DimDateId
    INNER JOIN rpt.vw_DimTime dt ON dt.DimTimeId = f.DimTimeId
    INNER JOIN rpt.vw_DimPlanType pt ON pt.DimPlanTypeId = f.DimPlanTypeId
    INNER JOIN rpt.vw_DimTicketType tt ON tt.DimTicketTypeId = f.DimTicketTypeId
    INNER JOIN rpt.vw_DimSeatType dstp ON dstp.DimSeatTypeId = f.DimSeatTypeId
	where seasonname = '2015 falcons season' and tickettypename = 'Full season' and pt.PlanTypeCode = 'New'
	--WHERE f.DimSeasonId IN (2,49)

)
GO
