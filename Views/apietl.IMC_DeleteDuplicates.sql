SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [apietl].[IMC_DeleteDuplicates]
AS
    SELECT  imdb.Email ,
            imdb.[CRM Sync ID 2] ,
            imdb.Duplicate
    FROM    archive.IMC_MasterDB_20170620 imdb ( NOLOCK )
            LEFT JOIN apietl.silverpop_removeRecipient_Results_0 srrr0 ( NOLOCK ) ON imdb.Email = srrr0.Email
                                                              AND imdb.[CRM Sync ID 2] = srrr0.CRMSyncID
    WHERE   Duplicate = 'Duplicate'
            AND Last_Click = ''
            AND Last_Open = ''
            AND Last_Sent = ''
			AND srrr0.Email IS NULL;
GO
