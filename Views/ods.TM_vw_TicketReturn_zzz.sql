SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [ods].[TM_vw_TicketReturn_zzz] as (

	select *
	from zzz.ods__TM_Tkt_bkp_700Rollout (nolock)
	where ticket_status = 'R'

	union 

	select *
	from zzz.ods__TM_Plans_bkp_700Rollout (nolock)
	where ticket_status = 'R'

)




GO
