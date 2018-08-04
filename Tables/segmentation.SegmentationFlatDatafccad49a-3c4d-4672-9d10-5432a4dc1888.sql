CREATE TABLE [segmentation].[SegmentationFlatDatafccad49a-3c4d-4672-9d10-5432a4dc1888]
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
ALTER TABLE [segmentation].[SegmentationFlatDatafccad49a-3c4d-4672-9d10-5432a4dc1888] ADD CONSTRAINT [pk_SegmentationFlatDatafccad49a-3c4d-4672-9d10-5432a4dc1888] PRIMARY KEY NONCLUSTERED  ([id])
GO
CREATE CLUSTERED INDEX [cix_SegmentationFlatDatafccad49a-3c4d-4672-9d10-5432a4dc1888] ON [segmentation].[SegmentationFlatDatafccad49a-3c4d-4672-9d10-5432a4dc1888] ([_rn])
GO
