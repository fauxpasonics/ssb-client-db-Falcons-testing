CREATE TABLE [stg].[TestJsonBug]
(
[ETL__ID] [bigint] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__Source] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[Data_Source	Initial_Catalog	User_ID	Password	ConnString] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [stg].[TestJsonBug] ADD CONSTRAINT [PK__TestJson__C4EA24455C99B325] PRIMARY KEY CLUSTERED  ([ETL__ID])
GO
