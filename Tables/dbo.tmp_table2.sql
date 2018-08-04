CREATE TABLE [dbo].[tmp_table2]
(
[SourceContactId] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Prefix] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FullName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[County] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PhoneType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailType] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourcePriorityRank] [int] NULL,
[SourceCreateDate] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom1] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom2] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom3] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom4] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Custom5] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RunContactMatch] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceSystem] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
