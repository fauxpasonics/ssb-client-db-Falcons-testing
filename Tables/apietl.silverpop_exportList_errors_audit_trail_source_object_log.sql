CREATE TABLE [apietl].[silverpop_exportList_errors_audit_trail_source_object_log]
(
[ETL__audit_id] [uniqueidentifier] NOT NULL,
[ETL__silverpop_exportList_errors_id] [uniqueidentifier] NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__silverpop__ETL____6F37D48D] DEFAULT (getutcdate()),
[json_payload] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[raw_response] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[silverpop_exportList_errors_audit_trail_source_object_log] ADD CONSTRAINT [PK__silverpo__DB9573BCC4FAF96F] PRIMARY KEY CLUSTERED  ([ETL__audit_id])
GO
