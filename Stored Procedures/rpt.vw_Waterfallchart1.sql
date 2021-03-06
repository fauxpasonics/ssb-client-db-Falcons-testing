SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<JT Louviere>
-- Create date: <10/12/2015>
-- Description:	<Create Procedure of Falcons Waterfall Chart>
-- =============================================
CREATE PROCEDURE [rpt].[vw_Waterfallchart1] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select [season year] SeasonYear, [game number] GameNumber, [season year]+'_'+[Game Number] AS SeasonGame, [Day of Week] DOW,[Month], opponent, Daysout, [Remaining Inventory] RemainingInventory FROM adhoc.waterfalldata1
	
	UNPIVOT
	([Remaining Inventory] For DaysOut In 
	([99],	[98],	[97],	[96],	[95],	[94],	[93],	[92],	[91],	
	[90],	[89],	[88],	[87],	[86],	[85],	[84],	[83],	[82],	[81],	
	[80],	[79],	[78],	[77],	[76],	[75],	[74],	[73],	[72],	[71],	
	[70],	[69],	[68],	[67],	[66],	[65],	[64],	[63],	[62],	[61],	
	[60],	[59],	[58],	[57],	[56],	[55],	[54],	[53],	[52],	[51],	
	[50],	[49],	[48],	[47],	[46],	[45],	[44],	[43],	[42],	[41],	
	[40],	[39],	[38],	[37],	[36],	[35],	[34],	[33],	[32],	[31],	
	[30],	[29],	[28],	[27],	[26],	[25],	[24],	[23],	[22],	[21],	
	[20],	[19],	[18],	[17],	[16],	[15],	[14],	[13],	[12],	[11],	
	[10],	[9],	[8],	[7],	[6],	[5],	[4],	[3],	[2],	[1],	[0])) p
	--WHERE [Season Year] = '2010' AND [Game Number]='1'
	ORDER BY daysout DESC
    
END

GO
