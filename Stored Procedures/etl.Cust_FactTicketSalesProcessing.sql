SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




 CREATE PROCEDURE [etl].[Cust_FactTicketSalesProcessing]
(
	@BatchId INT = 0,
	@LoadDate DATETIME = NULL,
	@Options NVARCHAR(MAX) = NULL
)

AS
BEGIN



UPDATE f
SET f.DimPlanTypeId = 1
, f.DimTicketTypeId = 1
FROM #stgFactTicketSales f
INNER JOIN dbo.DimPriceCodeMaster dpcm ON f.DimPriceCodeMasterId = dpcm.DimPriceCodeMasterId
WHERE dpcm.PriceCode LIKE '_S_%'

/*Renewal FS*/
UPDATE f
SET f.DimPlanTypeId = 2
, f.DimTicketTypeId = 1
FROM #stgFactTicketSales f
INNER JOIN dbo.DimPriceCodeMaster dpcm ON f.DimPriceCodeMasterId = dpcm.DimPriceCodeMasterId
WHERE dpcm.PriceCode like '_S'



UPDATE f
SET f.DimPlanTypeId = 1
, f.DimTicketTypeId = 2
FROM #stgFactTicketSales f
INNER JOIN dbo.DimPriceCodeMaster dpcm ON f.DimPriceCodeMasterId = dpcm.DimPriceCodeMasterId
WHERE dpcm.PC2 = 'P'


UPDATE f
SET f.DimPlanTypeId = 7
, f.DimTicketTypeId = 3
FROM #stgFactTicketSales f
INNER JOIN dbo.DimPriceCodeMaster dpcm ON f.DimPriceCodeMasterId = dpcm.DimPriceCodeMasterId
WHERE dpcm.PC2 = 'G'


UPDATE f
SET f.DimPlanTypeId = 7
FROM #stgFactTicketSales f
WHERE f.DimPlanTypeId = -1


UPDATE f
SET f.DimTicketTypeId = 4
FROM #stgFactTicketSales f
WHERE f.DimTicketTypeId = -1


/****************************************** Fact Tags ****************************************************************/

--Removed by CTW 04/26/17 after discussions with the Falcons
--UPDATE f
--SET f.IsComp = 1
--FROM #stgFactTicketSales f
--WHERE f.TotalRevenue = 0 AND f.IsComp = 0

--Removed by CTW 04/26/17 after discussions with the Falcons
--UPDATE f
--SET f.IsComp = 0
--FROM #stgFactTicketSales f
--WHERE f.TotalRevenue <> 0 AND f.IsComp = 1



UPDATE f
SET f.IsPlan = 1
, f.IsPartial = 0
, f.IsSingleEvent = 0
, f.IsGroup = 0
FROM #stgFactTicketSales f
INNER JOIN dbo.DimTicketType dtt ON f.DimTicketTypeId = dtt.DimTicketTypeId
WHERE dtt.TicketTypeCode = 'FS'


UPDATE f
SET f.IsPlan = 1
, f.IsPartial = 1
, f.IsSingleEvent = 0
, f.IsGroup = 0
FROM #stgFactTicketSales f
INNER JOIN dbo.DimTicketType dtt ON f.DimTicketTypeId = dtt.DimTicketTypeId
WHERE dtt.TicketTypeCode IN ('PS')



UPDATE f
SET f.IsPlan = 0
, f.IsPartial = 0
, f.IsSingleEvent = 1
, f.IsGroup = 0
FROM #stgFactTicketSales f
INNER JOIN dbo.DimTicketType dtt ON f.DimTicketTypeId = dtt.DimTicketTypeId
WHERE dtt.TicketTypeCode = 'SG'


UPDATE f
SET f.IsPlan = 0
, f.IsPartial = 0
, f.IsSingleEvent = 1
, f.IsGroup = 1
FROM #stgFactTicketSales f
INNER JOIN dbo.DimTicketType dtt ON f.DimTicketTypeId = dtt.DimTicketTypeId
WHERE dtt.TicketTypeCode = 'Group'



UPDATE f
SET f.IsPremium = 0
FROM #stgFactTicketSales f
INNER JOIN dbo.DimTicketType dtt ON f.DimTicketTypeId = dtt.DimTicketTypeId
INNER JOIN dbo.DimSeatType dst ON f.DimSeatTypeId = dst.DimSeatTypeId
WHERE dst.SeatTypeCode = 'GA'


UPDATE f
SET f.IsPremium = 1
FROM #stgFactTicketSales f
INNER JOIN dbo.DimSeatType dst ON f.DimSeatTypeId = dst.DimSeatTypeId
WHERE dst.SeatTypeCode <> 'GA'


UPDATE f
SET f.IsPremium = 0
FROM #stgFactTicketSales f
INNER JOIN dbo.DimSeatType dst ON f.DimSeatTypeId = dst.DimSeatTypeId
WHERE dst.SeatTypeCode = 'GA'


UPDATE f
SET f.IsRenewal = 1
FROM #stgFactTicketSales f
INNER JOIN dbo.DimPlanType dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
WHERE dpt.PlanTypeCode = 'RENEW'


UPDATE f
SET f.IsRenewal = 0
FROM #stgFactTicketSales f
INNER JOIN dbo.DimPlanType dpt ON f.DimPlanTypeId = dpt.DimPlanTypeId
WHERE dpt.PlanTypeCode <> 'RENEW'

/****************************************** Seat Type ****************************************************************/

UPDATE dbo.DimSeat
SET Config_Location = '100 Level'
WHERE ManifestId = 64
AND SectionName LIKE '1__%'

UPDATE dbo.DimSeat
SET Config_Location = '200 Level'
WHERE ManifestId = 64
AND SectionName LIKE '2__%'

UPDATE dbo.DimSeat
SET Config_Location = '300 Level'
WHERE ManifestId = 64
AND SectionName LIKE '3__%'



/****************************************** QtySeatFSE ****************************************************************/

UPDATE f
SET f.QtySeatFSE = f.QtySeat / 10.0
FROM #stgFactTicketSales f
INNER JOIN dbo.DimTicketType dtt ON f.DimTicketTypeId = dtt.DimTicketTypeId
WHERE dtt.TicketTypeClass = 'Plan'
AND f.DimSeasonId = 72

UPDATE f
SET f.QtySeatFSE = f.QtySeat / 18.0
--FROM #stgFactTicketSales f
FROM dbo.factticketsales f
INNER JOIN dbo.DimTicketType dtt ON f.DimTicketTypeId = dtt.DimTicketTypeId
--WHERE dtt.TicketTypeClass = 'Plan'
AND f.DimSeasonId = 144

/****************************************** Find Active Season ****************************************************************/


UPDATE dsh --clear current column
SET Active = 0
FROM dbo.dimseasonheader dsh


UPDATE dsh
SET Active = 1
--FROM #stgFactTicketSales f
FROM dbo.dimseasonheader dsh
WHERE 
SeasonYear = 
CASE 
WHEN MONTH(CURRENT_TIMESTAMP) = 1 OR MONTH(CURRENT_TIMESTAMP) = 2 THEN YEAR(CURRENT_TIMESTAMP) -1
ELSE YEAR(CURRENT_TIMESTAMP) END


END


GO
