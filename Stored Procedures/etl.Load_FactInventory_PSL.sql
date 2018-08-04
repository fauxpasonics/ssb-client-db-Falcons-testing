SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_FactInventory_PSL]

AS
/*
------------------------------------------------- Load New Seat Inventory -------------------------------------------------
*/
INSERT  INTO dbo.FactInventory_PSL
        ( ETL_CreatedDate ,
          ETL_UpdatedDate ,
          DimArenaId ,
          DimSeasonId ,
          DimEventId ,
          DimSeatId ,
          ManifestDimPriceCodeId ,
          ManifestDimClassTMId ,
          ManifestSeatValue ,
          IsAvailable ,
          IsSaleable ,
          IsSold ,
          IsHeld ,
          IsComp ,
          IsAttended --9
          ,
          TotalRevenue ,
          TicketRevenue ,
          PcTicketValue ,
          FullPrice ,
          Discount ,
          Surcharge ,
          PurchasePrice ,
          PcPrice ,
          PcPrintedPrice ,
          PcTicket ,
          PcTax ,
          PcLicenseFee ,
          PcOther1 ,
          PcOther2 ,
          SeatBlockSize ,
          EventDateTime --16
          ,
          IsReserved
	    )
        SELECT  GETDATE() ETL_CreatedDate ,
                GETDATE() ETL_UpdatedDate ,
                ISNULL(de.DimArenaId, -1) DimArenaId ,
                ISNULL(de.DimSeasonId, -1) DimSeasonId ,
                ISNULL(de.DimEventId, -1) DimEventId ,
                ISNULL(dst.DimSeatId, -1) DimSeatId ,
                ISNULL(dpc_st.DimPriceCodeId, -1) ManifestDimPriceCodeId ,
                ISNULL(dctm.DimClassTMId, -1) ManifestDimClassTMId ,
                ISNULL(dpc_st.Price, 0) ManifestSeatValue ,
                CASE WHEN dctm.IsKill = 1 THEN 0
                     ELSE 1
                END [IsAvailable] ,
                CASE WHEN dctm.IsKill = 1 THEN 0
                     ELSE 1
                END [IsSaleable] ,
                0 [IsSold] ,
                0 [IsHeld] ,
                0 [IsComp] ,
                0 [IsAttended] ,
                0 [TotalRevenue] ,
                0 [TicketRevenue] ,
                0 [PcTicketValue] ,
                0 [FullPrice] ,
                0 [Discount] ,
                0 [Surcharge] ,
                0 [PurchasePrice] ,
                0 [PcPrice] ,
                0 [PcPrintedPrice] ,
                0 [PcTicket] ,
                0 [PcTax] ,
                0 [PcLicenseFee] ,
                0 [PcOther1] ,
                0 [PcOther2] ,
                0 [SeatBlockQty] ,
                de.EventDateTime [EventDateTime] ,
                0 IsReserved
	
	--SELECT COUNT(*)
        FROM    dbo.DimEvent de
                INNER JOIN dbo.DimSeat dst ON dst.ManifestId = de.ManifestId
                                              AND de.SourceSystem = dst.SourceSystem
                LEFT OUTER JOIN dbo.FactInventory_PSL fi ON fi.DimEventId = de.DimEventId
                                                        AND fi.DimSeatId = dst.DimSeatId
                LEFT OUTER JOIN dbo.DimPriceCode dpc_st ON dpc_st.SSID_event_id = de.SSID_event_id
                                                           AND dpc_st.SSID_price_code = dst.DefaultPriceCode
                LEFT OUTER JOIN dbo.DimClassTM dctm ON dctm.ETL_SSID_class_id = dst.DefaultClass
        WHERE   fi.FactInventoryId IS NULL
                AND de.IsClosed = 0
                AND de.DimArenaId = 34
                AND de.SourceSystem = 'TM-Falcons_PSL'
        ORDER BY de.DimEventId ,
                dst.DimSeatId;

/*
------------------------------------------------- Avail Seats -------------------------------------------------
*/



SELECT  *
INTO    #stgAvailSeats
FROM    (
	
		--Single Game Postings
          SELECT    de.DimEventId ,
                    dSeat.DimSeatId ,
                    ISNULL(dctm.DimClassTMId, -1) DimClassTMId ,
                    ISNULL(dpc.DimPriceCodeId, -1) DimPriceCodeId ,
                    ISNULL(avail.price, 0) PostedSeatValue
          FROM      Falcons_PSL.ods.TM_AvailSeats avail
                    INNER JOIN dbo.DimEvent de ON avail.event_id = de.SSID_event_id
                                                  AND de.SourceSystem = 'TM-Falcons_PSL'
                    LEFT OUTER JOIN dbo.DimClassTM dctm ON dctm.ETL_SSID_class_id = avail.class_id --AND dctm.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
                    LEFT OUTER JOIN dbo.DimPriceCode dpc ON avail.price_code = dpc.PriceCode
                                                            AND avail.event_id = dpc.SSID_event_id
                                                            AND dpc.SourceSystem = 'TM-Falcons_PSL'
                    INNER LOOP JOIN dbo.Lkp_SeatList sl ON sl.Seat BETWEEN avail.seat_num
                                                              AND
                                                              ( avail.seat_num
                                                              + avail.num_seats
                                                              - 1 )
                    INNER JOIN dbo.DimSeat dSeat ON avail.section_id = dSeat.SSID_section_id
                                                    AND avail.row_id = dSeat.SSID_row_id
                                                    AND sl.Seat = dSeat.Seat
                                                    AND dSeat.SourceSystem = 'TM-Falcons_PSL'
          WHERE     de.DimArenaId = 34
          UNION

		--Plan Postings by Event
          SELECT    de.DimEventId ,
                    dSeat.DimSeatId ,
                    ISNULL(dctm.DimClassTMId, -1) DimClassTMId ,
                    ISNULL(dpc.DimPriceCodeId, -1) DimPriceCodeId ,
                    ISNULL(dpc.Price, 0) PostedSeatValue
          FROM      Falcons_PSL.ods.TM_AvailSeats avail
                    INNER JOIN ( SELECT DISTINCT
                                        plan_event_id ,
                                        event_id
                                 FROM   Falcons_PSL.ods.TM_EventsInPlan
                               ) eip ON avail.event_id = eip.plan_event_id
                    INNER JOIN dbo.DimEvent de ON eip.event_id = de.SSID_event_id
                                                  AND de.SourceSystem = 'TM-Falcons_PSL'
                    LEFT OUTER JOIN dbo.DimClassTM dctm ON dctm.ETL_SSID_class_id = avail.class_id --AND dctm.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
                    LEFT OUTER JOIN dbo.DimPriceCode dpc ON avail.price_code = dpc.PriceCode
                                                            AND avail.event_id = dpc.SSID_event_id
                                                            AND dpc.SourceSystem = 'TM-Falcons_PSL'
                    INNER LOOP JOIN dbo.Lkp_SeatList sl ON sl.Seat BETWEEN avail.seat_num
                                                              AND
                                                              ( avail.seat_num
                                                              + avail.num_seats
                                                              - 1 )
                    INNER JOIN dbo.DimSeat dSeat ON avail.section_id = dSeat.SSID_section_id
                                                    AND avail.row_id = dSeat.SSID_row_id
                                                    AND sl.Seat = dSeat.Seat
                                                    AND dSeat.SourceSystem = 'TM-Falcons_PSL'
          WHERE     de.DimArenaId = 34
        ) a;

CREATE NONCLUSTERED INDEX [IDX_BusinessKey] ON #stgAvailSeats (DimEventId, DimSeatId);

UPDATE  f
SET     f.ETL_UpdatedDate = GETDATE() ,
        f.PostedDimPriceCodeId = NULL ,
        f.PostedDimClassTMId = NULL ,
        f.PostedSeatValue = NULL
FROM    dbo.FactInventory_PSL f
        LEFT OUTER JOIN #stgAvailSeats sas ON sas.DimEventId = f.DimEventId
                                              AND sas.DimSeatId = f.DimSeatId
WHERE   f.PostedDimPriceCodeId IS NOT NULL
        AND sas.DimSeatId IS NULL; 


UPDATE  f
SET     f.ETL_UpdatedDate = GETDATE() ,
        f.PostedDimPriceCodeId = sas.DimPriceCodeId ,
        f.PostedDimClassTMId = sas.DimClassTMId ,
        f.PostedSeatValue = sas.PostedSeatValue ,
        f.IsAvailable = 1
FROM    #stgAvailSeats sas
        INNER JOIN dbo.FactInventory_PSL f ON sas.DimEventId = f.DimEventId
                                          AND sas.DimSeatId = f.DimSeatId
WHERE   ISNULL(f.PostedDimPriceCodeId, -987) <> ISNULL(sas.DimPriceCodeId,
                                                       -987)
        OR ISNULL(f.PostedDimClassTMId, -987) <> ISNULL(sas.DimClassTMId, -987)
        OR ISNULL(f.PostedSeatValue, -987) <> ISNULL(sas.PostedSeatValue, -987)
        OR f.IsAvailable = 0;


/*
------------------------------------------------- Held Seats -------------------------------------------------
*/

SELECT  DimEventId ,
        DimSeatId ,
        HeldDimPriceCodeId ,
        HeldDimClassTMId ,
        HeldSeatValue ,
        IsReserved
INTO    #StgHeldSeats
FROM    ( SELECT    de.DimEventId ,
                    dSeat.DimSeatId ,
                    ISNULL(dpc.DimPriceCodeId, -1) HeldDimPriceCodeId ,
                    ISNULL(dctm.DimClassTMId, -1) HeldDimClassTMId ,
                    hs.block_purchase_price HeldSeatValue ,
                    CAST(CASE WHEN hs.reserved_ind = 'Y' THEN 1
                              ELSE 0
                         END AS BIT) IsReserved
          FROM      Falcons_PSL.ods.TM_HeldSeats hs
                    INNER JOIN dbo.DimEvent de ON hs.event_id = de.SSID_event_id
                                                  AND de.SourceSystem = 'TM-Falcons_PSL'
                    LEFT OUTER JOIN dbo.DimClassTM dctm ON dctm.ETL_SSID_class_id = hs.class_id --AND de.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
                    LEFT OUTER JOIN dbo.DimPriceCode dpc ON hs.price_code = dpc.PriceCode
                                                            AND hs.event_id = dpc.SSID_event_id
                                                            AND dpc.SourceSystem = 'TM-Falcons_PSL'
                    INNER LOOP JOIN dbo.Lkp_SeatList sl ON sl.Seat BETWEEN hs.seat_num
                                                              AND
                                                              ( hs.seat_num
                                                              + hs.num_seats
                                                              - 1 )
                    INNER JOIN dbo.DimSeat dSeat ON --ds.ManifestId = dSeat.ManifestId and 
			hs.section_id = dSeat.SSID_section_id
                                                    AND hs.row_id = dSeat.SSID_row_id
                                                    AND sl.Seat = dSeat.Seat
                                                    AND dSeat.SourceSystem = 'TM-Falcons_PSL'
          WHERE     de.DimArenaId=34
          UNION
          SELECT    de.DimEventId ,
                    dSeat.DimSeatId ,
                    ISNULL(dpc.DimPriceCodeId, -1) HeldDimPriceCodeId ,
                    ISNULL(dctm.DimClassTMId, -1) HeldDimClassTMId ,
                    hs.block_purchase_price HeldSeatValue ,
                    CAST(CASE WHEN hs.reserved_ind = 'Y' THEN 1
                              ELSE 0
                         END AS BIT) IsReserved
          FROM      Falcons_PSL.ods.TM_HeldSeats hs
                    INNER JOIN ( SELECT DISTINCT
                                        plan_event_id ,
                                        event_id
                                 FROM   ods.TM_EventsInPlan
                               ) eip ON hs.event_id = eip.plan_event_id
                    INNER JOIN dbo.DimEvent de ON hs.event_id = de.SSID_event_id
                                                  AND de.SourceSystem = 'TM-Falcons_PSL'
                    LEFT OUTER JOIN dbo.DimClassTM dctm ON dctm.ETL_SSID_class_id = hs.class_id --AND dctm.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
                    LEFT OUTER JOIN dbo.DimPriceCode dpc ON hs.price_code = dpc.PriceCode
                                                            AND hs.event_id = dpc.SSID_event_id
                                                            AND dpc.SourceSystem = 'TM-Falcons_PSL'
                    INNER LOOP JOIN dbo.Lkp_SeatList sl ON sl.Seat BETWEEN hs.seat_num
                                                              AND
                                                              ( hs.seat_num
                                                              + hs.num_seats
                                                              - 1 )
                    INNER JOIN dbo.DimSeat dSeat ON --ds.ManifestId = dSeat.ManifestId and 
			hs.section_id = dSeat.SSID_section_id
                                                    AND hs.row_id = dSeat.SSID_row_id
                                                    AND sl.Seat = dSeat.Seat
                                                    AND dSeat.SourceSystem = 'TM-Falcons_PSL'
          WHERE     de.DimArenaId=34
        ) a;

CREATE NONCLUSTERED INDEX [IDX_BusinessKey] ON #StgHeldSeats (DimEventId, DimSeatId);


UPDATE  f
SET     f.ETL_UpdatedDate = GETDATE() ,
        f.IsHeld = 0 ,
        f.IsReserved = 0 ,
        f.HeldDimPriceCodeId = NULL ,
        f.HeldDimClassTMId = NULL ,
        f.HeldSeatValue = NULL
FROM    dbo.FactInventory_PSL f
        LEFT OUTER JOIN #StgHeldSeats shs ON shs.DimEventId = f.DimEventId
                                             AND shs.DimSeatId = f.DimSeatId
WHERE   f.IsHeld = 1
        AND shs.DimSeatId IS NULL; 

UPDATE  f
SET     f.ETL_UpdatedDate = GETDATE() ,
        f.IsHeld = 1 ,
        f.IsReserved = shs.IsReserved ,
        f.HeldDimPriceCodeId = shs.HeldDimPriceCodeId ,
        f.HeldDimClassTMId = shs.HeldDimClassTMId ,
        f.HeldSeatValue = shs.HeldSeatValue
FROM    #StgHeldSeats shs
        INNER JOIN dbo.FactInventory_PSL f ON shs.DimEventId = f.DimEventId
                                          AND shs.DimSeatId = f.DimSeatId
WHERE   f.IsHeld = 0
        OR ISNULL(f.HeldDimPriceCodeId, -987) <> ISNULL(shs.HeldDimPriceCodeId,
                                                        -987)
        OR ISNULL(f.HeldDimClassTMId, -987) <> ISNULL(shs.HeldDimClassTMId,
                                                      -987)
        OR ISNULL(f.HeldSeatValue, -987) <> ISNULL(shs.HeldSeatValue, -987)
        OR f.IsReserved <> shs.IsReserved;

/*
------------------------------------------------- Sold Seats -------------------------------------------------
*/

SELECT  f.FactTicketSalesId ,
        f.DimEventId ,
        dst.DimSeatId ,
        f.DimCustomerId SoldDimCustomerId ,
        f.DimDateId SoldDimDateId ,
        f.DimTimeId SoldDimTimeId ,
        f.DimItemId SoldDimItemId ,
        f.DimPlanId SoldDimPlanId ,
        f.DimPriceCodeId SoldDimPriceCodeId ,
        f.DimSalesCodeId SoldDimSalesCodeId ,
        f.DimPromoId SoldDimPromoId ,
        f.DimTicketClassId SoldDimTicketClassId ,
        f.DimLedgerId SoldDimLedgerId ,
        CAST(dd.CalDate AS DATETIME) + CAST(dt.Time24 AS DATETIME) SoldDateTime ,
        f.DimClassTMId SoldDimClassTMId ,
        0 IsAvailable ,
        1 IsSold ,
        0 IsHeld ,
        f.IsComp ,
        f.PurchasePrice TotalRevenue ,
        ( f.TicketRevenue / CAST(f.QtySeat AS DECIMAL(18, 6)) ) TicketRevenue ,
        ( f.PcTicket / CAST(f.QtySeat AS DECIMAL(18, 6)) ) PcTicketValue ,
        f.FullPrice FullPrice ,
        ( f.Discount / CAST(f.QtySeat AS DECIMAL(18, 6)) ) Discount ,
        ( f.Surcharge / CAST(f.QtySeat AS DECIMAL(18, 6)) ) Surcharge ,
        f.PurchasePrice PurchasePrice ,
        ( f.PcPrice / CAST(f.QtySeat AS DECIMAL(18, 6)) ) PcPrice ,
        ( f.PcPrintedPrice / CAST(f.QtySeat AS DECIMAL(18, 6)) ) PcPrintedPrice ,
        ( f.PcTicket / CAST(f.QtySeat AS DECIMAL(18, 6)) ) PcTicket ,
        ( f.PcTax / CAST(f.QtySeat AS DECIMAL(18, 6)) ) PcTax ,
        ( f.PcLicenseFee / CAST(f.QtySeat AS DECIMAL(18, 6)) ) PcLicenseFee ,
        ( f.PcOther1 / CAST(f.QtySeat AS DECIMAL(18, 6)) ) PcOther1 ,
        ( f.PcOther2 / CAST(f.QtySeat AS DECIMAL(18, 6)) ) PcOther2 ,
        f.QtySeat SeatBlockSize ,
        f.OrderNum SoldOrderNum ,
        f.OrderLineItem SoldOrderLineItem ,
        f.IsHost
INTO    #StgSeatSales
FROM    dbo.FactTicketSales (NOLOCK) f
        INNER JOIN dbo.DimEvent de ON f.DimEventId = de.DimEventId
        INNER JOIN dbo.DimDate dd ON dd.DimDateId = f.DimDateId
        INNER JOIN dbo.DimTime dt ON dt.DimTimeId = f.DimTimeId
        INNER JOIN dbo.DimPriceCode dpc ON f.DimPriceCodeId = dpc.DimPriceCodeId
        INNER JOIN dbo.DimSeat (NOLOCK) dst ON f.SSID_section_id = dst.SSID_section_id
                                               AND f.SSID_row_id = dst.SSID_row_id
                                               AND dst.Seat BETWEEN f.SSID_seat_num
                                                            AND
                                                              ( f.SSID_seat_num
                                                              + f.QtySeat - 1 )
                                               AND f.SourceSystem = dst.SourceSystem;

	--WHERE de.IsInventoryEligible = 1

	
CREATE NONCLUSTERED INDEX [IDX_BusinessKey] ON #StgSeatSales (DimEventId, DimSeatId);


/*
------------------------------------------------- Returned Seats -------------------------------------------------
*/


UPDATE  f
SET     f.ETL_UpdatedDate = GETDATE() ,
        f.FactTicketSalesId = NULL ,
        f.SoldDimCustomerId = NULL ,
        f.SoldDimDateId = NULL ,
        f.SoldDimTimeId = NULL ,
        f.SoldDimItemId = NULL ,
        f.SoldDimPlanId = NULL ,
        f.SoldDimPriceCodeId = NULL ,
        f.SoldDimSalesCodeId = NULL ,
        f.SoldDimPromoId = NULL ,
        f.SoldDimTicketClassId = NULL ,
        f.SoldDimLedgerId = NULL ,
        f.SoldDateTime = NULL ,
        f.SoldDimClassTMId = NULL ,
        f.IsAvailable = 1 ,
        f.IsSold = 0 ,
        f.IsHeld = 0 ,
        f.IsComp = 0 ,
        f.TotalRevenue = 0 ,
        f.TicketRevenue = 0 ,
        f.PcTicketValue = 0 ,
        f.FullPrice = 0 ,
        f.Discount = 0 ,
        f.Surcharge = 0 ,
        f.PurchasePrice = 0 ,
        f.PcPrice = 0 ,
        f.PcPrintedPrice = 0 ,
        f.PcTicket = 0 ,
        f.PcTax = 0 ,
        f.PcLicenseFee = 0 ,
        f.PcOther1 = 0 ,
        f.PcOther2 = 0 ,
        f.SeatBlockSize = 0 ,
        f.SoldOrderNum = 0 ,
        f.SoldOrderLineItem = 0 ,
        f.IsHost = NULL
FROM    dbo.FactInventory_PSL (NOLOCK) f
        LEFT OUTER JOIN #StgSeatSales sales ON sales.DimEventId = f.DimEventId
                                               AND sales.DimSeatId = f.DimSeatId
WHERE   f.IsSold = 1
        AND sales.DimEventId IS NULL;



UPDATE  f
SET     f.ETL_UpdatedDate = GETDATE() ,
        f.FactTicketSalesId = sales.FactTicketSalesId ,
        f.SoldDimCustomerId = sales.SoldDimCustomerId ,
        f.SoldDimDateId = sales.SoldDimDateId ,
        f.SoldDimTimeId = sales.SoldDimTimeId ,
        f.SoldDimItemId = sales.SoldDimItemId ,
        f.SoldDimPlanId = sales.SoldDimPlanId ,
        f.SoldDimPriceCodeId = sales.SoldDimPriceCodeId ,
        f.SoldDimSalesCodeId = sales.SoldDimSalesCodeId ,
        f.SoldDimPromoId = sales.SoldDimPromoId ,
        f.SoldDimTicketClassId = sales.SoldDimTicketClassId ,
        f.SoldDimLedgerId = sales.SoldDimLedgerId ,
        f.SoldDateTime = sales.SoldDateTime ,
        f.SoldDimClassTMId = sales.SoldDimClassTMId ,
        f.IsAvailable = sales.IsAvailable ,
        f.IsSold = sales.IsSold ,
        f.IsHeld = sales.IsAvailable ,
        f.IsComp = sales.IsComp ,
        f.TotalRevenue = sales.TotalRevenue ,
        f.TicketRevenue = sales.TicketRevenue ,
        f.PcTicketValue = sales.PcTicketValue ,
        f.FullPrice = sales.FullPrice ,
        f.Discount = sales.Discount ,
        f.Surcharge = sales.Surcharge ,
        f.PurchasePrice = sales.PurchasePrice ,
        f.PcPrice = sales.PcPrice ,
        f.PcPrintedPrice = sales.PcPrintedPrice ,
        f.PcTicket = sales.PcTicket ,
        f.PcTax = sales.PcTax ,
        f.PcLicenseFee = sales.PcLicenseFee ,
        f.PcOther1 = sales.PcOther1 ,
        f.PcOther2 = sales.PcOther2 ,
        f.SeatBlockSize = sales.SeatBlockSize ,
        f.SoldOrderNum = sales.SoldOrderNum ,
        f.SoldOrderLineItem = sales.SoldOrderLineItem ,
        f.IsHost = sales.IsHost
FROM    dbo.FactInventory_PSL f
        INNER JOIN #StgSeatSales sales ON sales.DimEventId = f.DimEventId
                                          AND sales.DimSeatId = f.DimSeatId;



UPDATE  dbo.FactInventory_PSL
SET     IsAvailable = 0
WHERE   IsAvailable = 1
        AND IsSaleable = 0;
GO
