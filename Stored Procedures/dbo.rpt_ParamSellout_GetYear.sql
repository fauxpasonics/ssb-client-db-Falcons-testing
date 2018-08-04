SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create PROCEDURE [dbo].[rpt_ParamSellout_GetYear] 
AS


/*Before adding year, ensure new procs have been created.  
Once year is added here the drop down in the report will be updated.*/

SELECT '2015' YearVal, '2015' YearLabel
UNION ALL
SELECT '2016' YearVal, '2016' YearLabel


 
GO
