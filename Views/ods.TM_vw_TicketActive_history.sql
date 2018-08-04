SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [ods].[TM_vw_TicketActive_history] AS (

SELECT tkt.*, 'tkt' SourceTable
FROM ods.tm_tkt_history (NOLOCK) tkt
WHERE tkt.ticket_status <> 'R'

)




GO
