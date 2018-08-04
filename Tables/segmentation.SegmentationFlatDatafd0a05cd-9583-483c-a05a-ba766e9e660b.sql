CREATE TABLE [segmentation].[SegmentationFlatDatafd0a05cd-9583-483c-a05a-ba766e9e660b]
(
[id] [uniqueidentifier] NOT NULL,
[DocumentType] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SessionId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Environment] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TenantId] [varchar] (36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[_rn] [bigint] NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerSourceSystem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
)
GO
ALTER TABLE [segmentation].[SegmentationFlatDatafd0a05cd-9583-483c-a05a-ba766e9e660b] ADD CONSTRAINT [pk_SegmentationFlatDatafd0a05cd-9583-483c-a05a-ba766e9e660b] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatDatafd0a05cd-9583-483c-a05a-ba766e9e660b] ON [segmentation].[SegmentationFlatDatafd0a05cd-9583-483c-a05a-ba766e9e660b] ([_rn])
GO
