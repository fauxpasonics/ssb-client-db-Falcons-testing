CREATE TABLE [dbo].[CRM_ContactsToCustomers]
(
[TicketingSystem] [varchar] (51) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CrmContactId] [varchar] (37) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExternalContactId ] [varchar] (18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsPrimary ] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[database_id] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Count_ContactID] [int] NULL,
[Complete] [bit] NULL,
[sourcesystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dimcustomerid] [int] NULL,
[Count_GUID] [int] NULL
)
GO
