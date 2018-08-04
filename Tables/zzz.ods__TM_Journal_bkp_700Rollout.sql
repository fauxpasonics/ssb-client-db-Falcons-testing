CREATE TABLE [zzz].[ods__TM_Journal_bkp_700Rollout]
(
[id] [bigint] NOT NULL IDENTITY(1, 1),
[acct_id] [bigint] NULL,
[stamp] [datetime] NULL,
[seq] [bigint] NULL,
[type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type_desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[debit] [decimal] (18, 6) NULL,
[credit] [decimal] (18, 6) NULL,
[invoice_amount] [decimal] (18, 6) NULL,
[event_id] [int] NULL,
[order_num] [bigint] NULL,
[order_line_item] [int] NULL,
[order_line_item_seq] [int] NULL,
[cc_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[payment_type_desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[payment_schedule_id] [bigint] NULL,
[invoice_id] [bigint] NULL,
[journal_Seq_id] [bigint] NULL,
[add_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upd_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsertDate] [datetime] NULL CONSTRAINT [DF__TM_Journa__Inser__36470DEF] DEFAULT (getdate()),
[UpdateDate] [datetime] NULL CONSTRAINT [DF__TM_Journa__Updat__373B3228] DEFAULT (getdate()),
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL,
[credit_applied] [decimal] (18, 6) NULL,
[batch_tag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[batch_id] [int] NULL,
[cc_num_masked] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[surchg_amount] [decimal] (18, 6) NULL,
[surchg_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[disc_amount] [decimal] (18, 6) NULL,
[disc_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ledger_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[merchant_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[plan_event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[section_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[row_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seat_num] [int] NULL,
[last_seat] [int] NULL,
[sell_location] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[info] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[posted_date] [date] NULL
)
GO
ALTER TABLE [zzz].[ods__TM_Journal_bkp_700Rollout] ADD CONSTRAINT [PK__TM_Journ__3213E83FE74A200C] PRIMARY KEY CLUSTERED  ([id])
GO
CREATE NONCLUSTERED INDEX [IDX_TMJournal_JournalSeqID] ON [zzz].[ods__TM_Journal_bkp_700Rollout] ([journal_Seq_id])
GO
CREATE NONCLUSTERED INDEX [IDX_TM_Journal_UpdateDate] ON [zzz].[ods__TM_Journal_bkp_700Rollout] ([UpdateDate]) WITH (DATA_COMPRESSION = ROW)
GO
