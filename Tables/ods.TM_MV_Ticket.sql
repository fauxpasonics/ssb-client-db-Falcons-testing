CREATE TABLE [ods].[TM_MV_Ticket]
(
[id] [bigint] NOT NULL,
[event_name] [datetime] NULL,
[section_name] [datetime] NULL,
[row_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[num_seats] [binary] (32) NULL,
[ticket_status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upd_datetime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seq_num] [int] NULL,
[block_purchase_price] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[order_num] [bigint] NULL,
[order_line_item] [datetime] NULL,
[order_line_item_seq] [bigint] NULL,
[info] [decimal] (18, 6) NULL,
[total_events] [bigint] NULL,
[price_code] [bigint] NULL,
[pricing_method] [int] NULL,
[comp_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comp_name] [int] NULL,
[Paid] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[disc_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[disc_amount] [int] NULL,
[surchg_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[surchg_amount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[group_flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[upd_user] [decimal] (18, 6) NULL,
[class_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sell_location] [decimal] (18, 6) NULL,
[full_price] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[purchase_price] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sales_source_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sales_source_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Ticket_Type] [decimal] (18, 6) NULL,
[Price_code_desc] [decimal] (18, 6) NULL,
[event_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[plan_event_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[plan_event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seat_num] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_Seat] [int] NULL,
[other_info_1] [int] NULL,
[other_info_2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_3] [int] NULL,
[other_info_4] [int] NULL,
[other_info_5] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_6] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_7] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_8] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_9] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other_info_10] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_Rep_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_rep_full_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tran_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[section_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[row_id] [int] NULL,
[promo_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[retail_ticket_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[retail_qualifiers] [decimal] (18, 6) NULL,
[paid_amount] [decimal] (18, 6) NULL,
[owed_amount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_datetime] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[add_user] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[renewal_ind] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsertDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssbPriceCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssbIsHost] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[return_reason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[return_reason_desc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[expanded] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_method] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_method_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_instructions] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_name_first] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_name_last] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_addr1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_addr2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_addr3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_city] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_state] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_zip] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_zip_formatted] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_country] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_phone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivery_phone_formatted] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[delivered_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[group_sales_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ledger_id] [int] NULL,
[pc_ticket] [decimal] (18, 6) NULL,
[pc_tax] [decimal] (18, 6) NULL,
[pc_licfee] [decimal] (18, 6) NULL,
[pc_other1] [decimal] (18, 6) NULL,
[pc_other2] [decimal] (18, 6) NULL,
[tax_rate_a] [decimal] (18, 6) NULL,
[tax_rate_b] [decimal] (18, 6) NULL,
[tax_rate_c] [decimal] (18, 6) NULL,
[ticket_seq_id] [int] NULL,
[orig_acct_rep_id] [int] NULL,
[SourceTable] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX [CCI_ods__TM_MV_Ticket] ON [ods].[TM_MV_Ticket]
GO
