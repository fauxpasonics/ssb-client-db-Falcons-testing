CREATE TABLE [audit].[MDMKeysAudit]
(
[dimcustomerid] [int] NOT NULL,
[ssid] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nameaddr_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NameEmail_id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Composite_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_ACCT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_CRMSYSTEM_PRIMARY_FLAG] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[snapsshotdate] [datetime] NOT NULL
)
GO
