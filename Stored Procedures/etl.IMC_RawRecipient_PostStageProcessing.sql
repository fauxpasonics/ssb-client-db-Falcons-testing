SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[IMC_RawRecipient_PostStageProcessing]
(
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@Options NVARCHAR(MAX) = NULL
)

AS 
BEGIN


/*
	Set fields in Key to be blank and not null for proper merge processing
*/


UPDATE stg.IMC_RawRecipient
SET Body_Type = ''
WHERE Body_Type IS NULL

UPDATE stg.IMC_RawRecipient
SET Click_Name = ''
WHERE Click_Name IS NULL


END



GO
