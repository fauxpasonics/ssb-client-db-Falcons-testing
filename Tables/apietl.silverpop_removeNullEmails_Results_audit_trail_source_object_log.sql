CREATE TABLE [apietl].[silverpop_removeNullEmails_Results_audit_trail_source_object_log]
(
[ETL__audit_id] [uniqueidentifier] NOT NULL,
[ETL__silverpop_removeNullEmails_Results_id] [uniqueidentifier] NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__silverpop__ETL____4E80EC38] DEFAULT (getutcdate()),
[json_payload] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[raw_response] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[silverpop_removeNullEmails_Results_audit_trail_source_object_log] ADD CONSTRAINT [PK__silverpo__DB9573BCB2DA4D38] PRIMARY KEY CLUSTERED  ([ETL__audit_id])
GO
