SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [apietl].[IMC_RemoveNullEmails]
AS
SELECT imcdb.Email, imcdb.[CRM Sync ID 2] FROM archive.IMC_MasterDB_20170620 imcdb (NOLOCK)
LEFT JOIN apietl.silverpop_removeNullEmails_Results_0 rner0 (NOLOCK) ON rner0.Email = imcdb.Email AND imcdb.[CRM Sync ID 2]=rner0.CRMSyncID AND rner0.Success='True'
 WHERE ISNULL(imcdb.Email,'')='' AND ISNULL(imcdb.[Mobile User Id],'')='' AND rner0.CRMSyncID IS NULL


GO
