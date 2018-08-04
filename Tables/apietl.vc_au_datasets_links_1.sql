CREATE TABLE [apietl].[vc_au_datasets_links_1]
(
[ETL__vc_au_datasets_links_id] [uniqueidentifier] NOT NULL,
[ETL__vc_au_datasets_id] [uniqueidentifier] NULL,
[rel] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[href] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[vc_au_datasets_links_1] ADD CONSTRAINT [PK__vc_au_da__25A821E6306F5AB4] PRIMARY KEY CLUSTERED  ([ETL__vc_au_datasets_links_id])
GO
