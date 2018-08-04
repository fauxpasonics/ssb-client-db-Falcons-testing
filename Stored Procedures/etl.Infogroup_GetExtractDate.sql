SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/*****

@ExtractDate is the prior day and formatted as DDMMMYYYY where MMM is alpha.  If the day is a single digit, append a '0' to the beginning.

*****/


CREATE PROCEDURE [etl].[Infogroup_GetExtractDate] (

	@ExtractDate	nvarchar(9) OUTPUT

)
AS
BEGIN


SELECT @ExtractDate =
						CONCAT(
							DATEPART(DAY,DATEADD(DAY,-1,GETDATE())),						--	numeric day of the prior day
							UPPER(LEFT(DATENAME(MONTH,DATEADD(DAY,-1,GETDATE())),3)),		--	left 3 alpha characters of the month of the prior day
							DATEPART(YEAR,DATEADD(DAY,-1,GETDATE()))						--	numeric year of the prior day
							);

SELECT @ExtractDate = CASE WHEN LEN(@ExtractDate) < 9 THEN CONCAT('0',@ExtractDate) ELSE @ExtractDate END;


END






GO
