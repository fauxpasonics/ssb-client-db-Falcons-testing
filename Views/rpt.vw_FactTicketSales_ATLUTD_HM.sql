SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [rpt].[vw_FactTicketSales_ATLUTD_HM] AS (


--SELECT * FROM dbo.DimArena


--SELECT * FROM [rpt].[vw_FactTicketSales_ATLUTD_HM]

SELECT 
ds.DimSeatId, 
ds.DimArenaId,
ds.ManifestId,
ds.DefaultPriceCode,
ds.SourceSystem,
 
hm.saledate,hm.saletime,hm.saledatetime,hm.accountid,
hm.seasonyear, 
--eventcode, eventname, eventdate, 
hm.PlanCode,hm.PlanName,

ds.SectionName,
ds.RowName,
ds.seat,

hm.pc1,hm.pc2,hm.pc3,hm.pc4,hm.isavailable,hm.issold,hm.iscomp,
hm.TotalRevenue,
hm.QtyFSE, 
hm.TotalPaidAmount, 
hm.TotalOwedAmount, 
hs.*,
 (CAST(LEFT(ds.SectionName,1)+'_'+CONVERT(VARCHAR,ds.SectionName)+'_'+CONVERT(VARCHAR,ds.RowName)+'_'+CONVERT(VARCHAR,ds.seat) AS VARCHAR(25))) AS [SeatKey],
 (CASE DefaultPriceCode
WHEN 'A' THEN 'Suites'
WHEN 'B' THEN 'Lower VIP ($225/$175)'
WHEN 'C' THEN 'Lower Club ($60)'
WHEN 'D' THEN 'Lower Club ($50)'
WHEN 'E' THEN 'Mezz Club ($50)'
WHEN 'F' THEN 'Lower Front-Rows ($45)'
WHEN 'G' THEN 'Lower Sides ($35)'
WHEN 'H' THEN 'Lower Corners ($30)'
WHEN 'I' THEN 'Lower Goal ($20)'
WHEN 'J' THEN 'Supporters ($20)'
WHEN 'K' THEN 'Mezz Sides ($35)'
WHEN 'L' THEN 'Mezz Corners ($30)'
WHEN 'M' THEN 'Mezz Goal ($20)'
WHEN 'N' THEN '300 Level'
ELSE 'FIX ME'
END
) AS [PriceCodeDescription] 
FROM dbo.DimSeat ds  WITH (NOLOCK)
LEFT JOIN  
(SELECT
saledate,saletime,saledatetime,accountid,
seasonyear, 
--eventcode, eventname, eventdate, 
PlanCode,PlanName,pc1,pc2,pc3,pc4,SectionName, RowName,seat,isavailable,issold,iscomp,
SUM(TotalRevenue) AS TotalRevenue,
COUNT(issold)/planeventcnt AS QtyFSE, 
SUM(PaidAmount) AS TotalPaidAmount, 
SUM(OwedAmount) AS TotalOwedAmount
FROM rpt.vw_FactTicketSeat_ATLUTD WITH (NOLOCK)
WHERE plancode = '17AUFS'
--ISsold = 1 --AND Plancode IS NOT NULL	
GROUP BY saledate,saletime,saledatetime,accountid,
seasonyear, 
--eventcode, eventname, eventdate, 
PlanCode,PlanName,pc1,pc2,pc3,pc4,SectionName, RowName,seat,isavailable,issold,iscomp,planeventcnt) AS hm 
ON ds.SectionName = hm.sectionname AND ds.RowName = hm.rowname AND ds.seat = hm.seat

LEFT JOIN (
SELECT --de.DimEventId --, dSeat.DimSeatId
ISNULL(dpc.DimPriceCodeId, -1) HeldDimPriceCodeId, ISNULL(dctm.DimClassTMId, -1) HeldDimClassTMId, hs.block_purchase_price HeldSeatValue
, CAST(CASE WHEN hs.reserved_ind = 'Y' THEN 1 ELSE 0 END AS BIT) IsReserved, hs.usr, hs.datetime, hs.hours_held, hs.plan_datetime, hs.invoice_id, hs.invoice_date
, slo.sell_location_code, slo.sell_location_name, dseat.SectionName sn, dseat.RowName rn, dseat.seat s
FROM ods.TM_HeldSeats hs WITH (NOLOCK)
--INNER JOIN dbo.DimEvent de ON hs.event_id = de.SSID_event_id AND de.SourceSystem = 'TM'
LEFT OUTER JOIN dbo.DimClassTM dctm WITH (NOLOCK) ON dctm.ETL_SSID_class_id = hs.class_id --AND de.SourceSystem = (SELECT etl.fnGetClientSetting('TM-SourceStyem'))
LEFT OUTER JOIN dbo.DimPriceCode dpc WITH (NOLOCK) ON hs.price_code = dpc.PriceCode AND hs.event_id = dpc.SSID_event_id AND dpc.SourceSystem = 'TM'
INNER LOOP JOIN dbo.Lkp_SeatList sl WITH (NOLOCK) ON sl.seat BETWEEN hs.seat_num AND (hs.seat_num + hs.num_seats - 1)
INNER JOIN dbo.DimSeat dSeat WITH (NOLOCK) ON --ds.ManifestId = dSeat.ManifestId and 
	hs.section_id = dSeat.ssid_section_id 
	AND hs.row_id = dSeat.ssid_row_id 
	AND sl.seat = dSeat.Seat
	AND dSeat.SourceSystem = 'TM'
LEFT JOIN ods.tm_selllocation slo ON hs.sell_location = slo.sell_location_code
WHERE 1=1 
--de.IsInventoryEligible = 1
AND hs.season_id IN ('153','154')
) hs ON ds.SectionName = hs.sn AND ds.RowName = hs.rn AND ds.seat = hs.s

WHERE ds.DimArenaId = 25


)




GO
