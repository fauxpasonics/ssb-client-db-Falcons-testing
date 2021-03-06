CREATE TABLE [apietl].[silverpop_optOut_Results_0]
(
[ETL__silverpop_optOut_Results_id] [uniqueidentifier] NOT NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__silverpop__ETL____0BD4133B] DEFAULT (getutcdate()),
[ETL__multi_query_value_for_audit] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SUCCESS] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JOB_ID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JOB_STATUS] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JOB_DESCRIPTION] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[silverpop_optOut_Results_0] ADD CONSTRAINT [PK__silverpo__19BF4E96FE53286C] PRIMARY KEY CLUSTERED  ([ETL__silverpop_optOut_Results_id])
GO
