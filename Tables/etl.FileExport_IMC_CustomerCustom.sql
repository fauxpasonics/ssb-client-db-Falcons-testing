CREATE TABLE [etl].[FileExport_IMC_CustomerCustom]
(
[optin_AF_date] [datetime] NULL,
[optin_AU_date] [datetime] NULL,
[optin_Stadium_Date] [datetime] NULL,
[PSL_Owner_SSB] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[United_Season_Ticket_Holder] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Falcons_Season_Ticket_Holder] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Duplicate] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Recipient_id] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[acquisition_source] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[optin_AF_Source] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[optin_AU_Source] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[optin_Stadium_Source] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
