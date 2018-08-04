SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [ods].[TM_vw_TicketActive_zzz] AS (

SELECT tkt.*, 'tkt' SourceTable
FROM zzz.ods__TM_Tkt_bkp_700Rollout (NOLOCK) tkt
WHERE tkt.ticket_status = 'A'
AND tkt.plan_event_id <> event_id

	UNION ALL

SELECT plans.*, 'plan' SourceTable
FROM zzz.ods__TM_Plans_bkp_700Rollout (NOLOCK) plans 
LEFT OUTER JOIN (SELECT * FROM zzz.ods__TM_Tkt_bkp_700Rollout (NOLOCK) WHERE plan_event_id <> event_id) tkt
	ON plans.acct_id = tkt.acct_id 
	AND plans.ticket_status = tkt.ticket_status
	AND plans.plan_event_id = tkt.plan_event_id
	AND plans.section_id = tkt.section_id
	AND plans.row_id = tkt.row_id
	AND plans.seat_num = tkt.seat_num
	AND plans.num_seats = tkt.num_seats
WHERE tkt.id IS NULL AND plans.ticket_status = 'A'


)
GO
