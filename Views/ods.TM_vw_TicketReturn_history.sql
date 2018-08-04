SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [ods].[TM_vw_TicketReturn_history] as (

	select *
	from ods.tm_tkt_history (nolock)
	where ticket_status = 'R'

)

GO
