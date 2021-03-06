CREATE TABLE [stg].[Infogroup_sumtmtkts]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL,
[ETL_FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[block_first_seat] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[block_last_seat] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[block_num_seat] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[event_date] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[event_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[event_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[order_num] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[price_code_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QUALIFIERS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[row_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SALEDATE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[season_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seat_number] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[section_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TICKET_TEXT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TICKETS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[primary_acct_id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
