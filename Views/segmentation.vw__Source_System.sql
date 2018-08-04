SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [segmentation].[vw__Source_System] AS (

SELECT  dc.SSB_CRMSYSTEM_CONTACT_ID
		, dc.SourceSystem CustomerSourceSystem

FROM    [dbo].[vwDimCustomer_ModAcctId] dc

WHERE dc.SourceSystem NOT IN ('TM-Falcons_Dome', 'CRM_Account'
, 'CRM_Contact', 'TM-Falcons_PSL', 'TM', 'Legacy_Dynamics_Contact' 
,  'Legacy_Dynamics_Account', 'IBM_Email')

																									 
) 
































GO
