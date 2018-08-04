CREATE TABLE [apietl].[silverpop_get_sent_mailings_for_list_ListName_1]
(
[ETL__silverpop_get_sent_mailings_for_list_ListName_id] [uniqueidentifier] NOT NULL,
[ETL__silverpop_get_sent_mailings_for_list_id] [uniqueidentifier] NULL,
[#cdata-section] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[silverpop_get_sent_mailings_for_list_ListName_1] ADD CONSTRAINT [PK__silverpo__93B915B43270CBC6] PRIMARY KEY CLUSTERED  ([ETL__silverpop_get_sent_mailings_for_list_ListName_id])
GO
