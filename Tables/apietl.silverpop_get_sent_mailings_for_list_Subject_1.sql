CREATE TABLE [apietl].[silverpop_get_sent_mailings_for_list_Subject_1]
(
[ETL__silverpop_get_sent_mailings_for_list_Subject_id] [uniqueidentifier] NOT NULL,
[ETL__silverpop_get_sent_mailings_for_list_id] [uniqueidentifier] NULL,
[#cdata-section] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[#text] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[silverpop_get_sent_mailings_for_list_Subject_1] ADD CONSTRAINT [PK__silverpo__2040E709E253CDF4] PRIMARY KEY CLUSTERED  ([ETL__silverpop_get_sent_mailings_for_list_Subject_id])
GO
