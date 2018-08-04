CREATE TABLE [apietl].[vc_au_datasets_audit_trail_source_object_log]
(
[ETL__audit_id] [uniqueidentifier] NOT NULL,
[ETL__vc_au_datasets_id] [uniqueidentifier] NULL,
[ETL__session_id] [uniqueidentifier] NOT NULL,
[ETL__insert_datetime] [datetime] NOT NULL CONSTRAINT [DF__vc_au_dat__ETL____150F9DC9] DEFAULT (getutcdate()),
[json_payload] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[raw_response] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[vc_au_datasets_audit_trail_source_object_log] ADD CONSTRAINT [PK__vc_au_da__DB9573BC65975401] PRIMARY KEY CLUSTERED  ([ETL__audit_id])
GO
