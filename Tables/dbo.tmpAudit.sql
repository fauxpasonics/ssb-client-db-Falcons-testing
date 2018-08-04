CREATE TABLE [dbo].[tmpAudit]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[dimcustomerid] [int] NOT NULL,
[matchkeyid] [int] NOT NULL,
[matchkeyvalue] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[insertdate] [datetime] NULL,
[updatedate] [datetime] NULL
)
GO
CREATE CLUSTERED INDEX [ix_dimcustomerid] ON [dbo].[tmpAudit] ([dimcustomerid])
GO
CREATE NONCLUSTERED INDEX [ix_matchkeyvalue] ON [dbo].[tmpAudit] ([matchkeyvalue])
GO
