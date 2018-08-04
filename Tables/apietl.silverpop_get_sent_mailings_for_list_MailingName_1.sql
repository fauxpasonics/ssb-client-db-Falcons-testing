CREATE TABLE [apietl].[silverpop_get_sent_mailings_for_list_MailingName_1]
(
[ETL__silverpop_get_sent_mailings_for_list_MailingName_id] [uniqueidentifier] NOT NULL,
[ETL__silverpop_get_sent_mailings_for_list_id] [uniqueidentifier] NULL,
[#cdata-section] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [apietl].[silverpop_get_sent_mailings_for_list_MailingName_1] ADD CONSTRAINT [PK__silverpo__6E2E0CE7E1CDCFB6] PRIMARY KEY CLUSTERED  ([ETL__silverpop_get_sent_mailings_for_list_MailingName_id])
GO
