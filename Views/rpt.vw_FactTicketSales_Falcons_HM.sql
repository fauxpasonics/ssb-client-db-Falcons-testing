SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [rpt].[vw_FactTicketSales_Falcons_HM] AS (


--SELECT * FROM dbo.DimArena


--SELECT * FROM [rpt].[vw_FactTicketSales_ATLUTD_HM]

SELECT  ds.DimSeatId ,
        ds.DimArenaId ,
        ds.ManifestId ,
        ds.DefaultPriceCode ,
        ds.SourceSystem ,
        hm.SaleDate ,
        hm.SaleTime ,
        hm.SaleDateTime ,
        hm.AccountId ,
        hm.SeasonYear , 
--eventcode, eventname, eventdate, 
        hm.PlanCode ,
        hm.PlanName ,
        ds.SectionName ,
        ds.RowName ,
        ds.Seat ,
        hm.PC1 ,
        hm.PC2 ,
        hm.pc3 ,
        hm.PC4 ,
        hm.IsAvailable ,
        hm.IsSold ,
        hm.IsComp ,
        hm.TotalRevenue ,
        hm.QtyFSE ,
        hm.TotalPaidAmount ,
        hm.TotalOwedAmount ,
        hs.* ,
        ( CAST(LEFT(ds.SectionName, 1) + '_' + CONVERT(VARCHAR, ds.SectionName)
          + '_' + CONVERT(VARCHAR, ds.RowName) + '_'
          + CONVERT(VARCHAR, ds.Seat) AS VARCHAR(25)) ) AS [SeatKey] ,
        ( CASE DefaultPriceCode
            WHEN 'A' THEN 'Lower VVIP Club (50 yd Line)'
            WHEN 'B' THEN 'Lower VIP Lounge 1 (30-50)'
            WHEN 'C' THEN 'Lower VIP Lounge 2 (15-30)'
            WHEN 'D' THEN 'Mezz Piedmont Club'
            WHEN 'E' THEN 'Lower Sideline (EZ-15)'
            WHEN 'F' THEN 'Lower Corner'
            WHEN 'G' THEN 'Lower Corner- Back Rows'
            WHEN 'H' THEN 'Lower EZ'
            WHEN 'I' THEN 'Lower EZ - Back Rows'
            WHEN 'J' THEN 'Mezz Sideline (EZ-30)'
            WHEN 'K' THEN 'Mezz Corner'
            WHEN 'L' THEN 'Mezz End Zone'
            WHEN 'M' THEN 'Upper Sideline - Front Rows'
            WHEN 'N' THEN 'Upper Sideline - Back Rows - Middle'
            WHEN 'O' THEN 'Upper Sideline - Back Rows - End'
            WHEN 'P' THEN 'Upper Corner 1 - Front Rows'
            WHEN 'Q' THEN 'Upper Corner 2- Front Rows'
            WHEN 'R' THEN 'Upper Corner 1 - Back Rows'
            WHEN 'S' THEN 'Upper Corner 2 - Back Rows'
            WHEN 'T' THEN 'Upper Corner 3 - Front Rows'
            WHEN 'U' THEN 'Upper Corner 3 - Back Rows'
            WHEN 'V' THEN 'Upper EZ - Front Rows'
            WHEN 'W' THEN 'Upper EZ - Back Rows'
            ELSE 'FIX ME'
          END ) AS [PriceCodeDescription] ,
        ( CASE ds.DefaultPriceCode
            WHEN 'A' THEN '$45000/$385'
            WHEN 'B' THEN '$20000/$365'
            WHEN 'C' THEN '$15000/$345'
            WHEN 'D' THEN '$10000/$325'
            WHEN 'E' THEN '$5500/$175'
            WHEN 'F' THEN '$3500/$125'
            WHEN 'G' THEN '$3000/$125'
            WHEN 'H' THEN '$3000/$115'
            WHEN 'I' THEN '$2500/$100'
            WHEN 'J' THEN '$5500/$150'
            WHEN 'K' THEN '$2500/$115'
            WHEN 'L' THEN '$2500/$95'
            WHEN 'M' THEN '$2000/$95'
            WHEN 'N' THEN '$1750/$85'
            WHEN 'O' THEN '$1500/$85'
            WHEN 'P' THEN '$1500/$80'
            WHEN 'Q' THEN '$1250/$80'
            WHEN 'R' THEN '$1250/$70'
            WHEN 'S' THEN '$750/$70'
            WHEN 'T' THEN '$500/$80'
            WHEN 'U' THEN '$500/$70'
            WHEN 'V' THEN '$500/$65'
            WHEN 'W' THEN '$500/$55'
            ELSE 'FIX ME'
          END ) AS [PriceCodePSLTicketCost]
FROM    dbo.DimSeat ds WITH ( NOLOCK )
        LEFT JOIN ( SELECT  SaleDate ,
                            SaleTime ,
                            SaleDateTime ,
                            AccountId ,
                            SeasonYear , 
--eventcode, eventname, eventdate, 
                            PlanCode ,
                            PlanName ,
                            PC1 ,
                            PC2 ,
                            pc3 ,
                            PC4 ,
                            SectionName ,
                            RowName ,
                            Seat ,
                            IsAvailable ,
                            IsSold ,
                            IsComp ,
                            SUM(TotalRevenue) AS TotalRevenue ,
                            COUNT(IsSold) / PlanEventCnt AS QtyFSE ,
                            SUM(PaidAmount) AS TotalPaidAmount ,
                            SUM(OwedAmount) AS TotalOwedAmount
                    FROM    rpt.vw_FactTicketSeat_Falcons WITH ( NOLOCK )
                    WHERE   PlanCode = '16FS'
--ISsold = 1 --AND Plancode IS NOT NULL	
GROUP BY                    SaleDate ,
                            SaleTime ,
                            SaleDateTime ,
                            AccountId ,
                            SeasonYear , 
--eventcode, eventname, eventdate, 
                            PlanCode ,
                            PlanName ,
                            PC1 ,
                            PC2 ,
                            pc3 ,
                            PC4 ,
                            SectionName ,
                            RowName ,
                            Seat ,
                            IsAvailable ,
                            IsSold ,
                            IsComp ,
                            PlanEventCnt
                  ) AS hm ON ds.SectionName = hm.SectionName
                             AND ds.RowName = hm.RowName
                             AND ds.Seat = hm.Seat
        LEFT JOIN ( SELECT --de.DimEventId --, dSeat.DimSeatId
                            ISNULL(dpc.DimPriceCodeId, -1) HeldDimPriceCodeId ,
                            ISNULL(dctm.DimClassTMId, -1) HeldDimClassTMId ,
                            hs.block_purchase_price HeldSeatValue ,
                            CAST(CASE WHEN hs.reserved_ind = 'Y' THEN 1
                                      ELSE 0
                                 END AS BIT) IsReserved ,
                            hs.usr ,
                            hs.datetime ,
                            hs.hours_held ,
                            hs.plan_datetime ,
                            hs.invoice_id ,
                            hs.invoice_date ,
                            slo.sell_location_code ,
                            slo.sell_location_name ,
                            dSeat.SectionName sn ,
                            dSeat.RowName rn ,
                            dSeat.Seat s
                    FROM    Falcons_PSL.ods.TM_HeldSeats hs WITH ( NOLOCK ) --INNER JOIN dbo.DimEvent de ON hs.event_id = de.SSID_event_id AND de.SourceSystem = 'TM'
                            LEFT OUTER JOIN dbo.DimClassTM dctm WITH ( NOLOCK ) ON dctm.ETL_SSID_class_id = hs.class_id --AND de.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
                            LEFT OUTER JOIN dbo.DimPriceCode dpc WITH ( NOLOCK ) ON hs.price_code = dpc.PriceCode
                                                              AND hs.event_id = dpc.SSID_event_id
                                                              AND dpc.SourceSystem = 'TM'
                            INNER LOOP JOIN dbo.Lkp_SeatList sl WITH ( NOLOCK ) ON sl.Seat BETWEEN hs.seat_num
                                                              AND
                                                              ( hs.seat_num
                                                              + hs.num_seats
                                                              - 1 )
                            INNER JOIN dbo.DimSeat dSeat WITH ( NOLOCK ) ON --ds.ManifestId = dSeat.ManifestId and 
	hs.section_id = dSeat.SSID_section_id
                                                              AND hs.row_id = dSeat.SSID_row_id
                                                              AND sl.Seat = dSeat.Seat
                                                              AND dSeat.SourceSystem = 'TM'
                            LEFT JOIN ods.TM_SellLocation slo ON hs.sell_location = slo.sell_location_code
                    WHERE   1 = 1 
--de.IsInventoryEligible = 1
                            AND hs.season_id = '6'
                  ) hs ON ds.SectionName = hs.sn
                          AND ds.RowName = hs.rn
                          AND ds.Seat = hs.s
WHERE   ds.DimArenaId = 34 AND ds.ManifestId = 5


)






GO
