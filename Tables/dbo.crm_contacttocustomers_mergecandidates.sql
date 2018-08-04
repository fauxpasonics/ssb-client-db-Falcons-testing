CREATE TABLE [dbo].[crm_contacttocustomers_mergecandidates]
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
[Count_GUID] [int] NULL,
[comp_dimcustomerid] [int] NULL,
[TM_SSID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_accountid] [int] NULL,
[TM_ContactGUID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CRM_ContactGUID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_PrimaryFlag] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[firstname] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastname] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[emailprimary] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimarystreet] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[addressprimaryiscleanstatus] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NeedsMDMMerge] [int] NOT NULL,
[PrimaryMisMatch] [int] NOT NULL,
[TMRecordNotFound] [int] NOT NULL,
[DimCustomerID_Match] [int] NOT NULL
)
GO
