CREATE TABLE [dbo].[CRM_ContactsToCustomers_v1]
(
[TicketingSystem] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CrmContactid] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExternalContactid] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsPrimary] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Database_Id] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Count_ContactID] [int] NULL,
[Complete] [bit] NULL,
[dimcustomerid] [int] NULL,
[sourcesystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Count_GUID] [int] NULL
)
GO
