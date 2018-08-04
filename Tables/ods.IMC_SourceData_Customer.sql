CREATE TABLE [ods].[IMC_SourceData_Customer]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[EMAIL] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_City] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_Country] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_County] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_Line1] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_Line2] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_Line3] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_PostalCode] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1_StateOrProvince] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BirthDate] [datetime] NULL,
[FirstName] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FullName] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GenderCode] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MiddleName] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobilePhone] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Suffix] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Telephone1] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Telephone2] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__UpdatedDate] [datetime] NOT NULL
)
GO
