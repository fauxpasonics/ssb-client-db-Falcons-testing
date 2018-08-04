SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*******************************
Updated By: Caeleon Work
Updated Date: 2018-08-01
Update Notes: Added Fanatics to load
********************************/
CREATE PROCEDURE [etl].[DimCustomer_MasterLoad]

AS
BEGIN

SELECT 1
---- OLD CRM ACCOUNT
--EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Falcons', @LoadView = 'etl.vw_Load_DimCustomer_CRM_Account', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'

---- OLD CRM CONTACT
--EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Falcons', @LoadView = 'etl.vw_Load_DimCustomer_CRM_Contact', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'

-- CRM_Account - 365
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Falcons', @LoadView = 'etl.vw_Load_DimCustomer_CRM_Account_365', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'

-- CRM_Contact - 365
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Falcons', @LoadView = 'etl.vw_Load_DimCustomer_CRM_Contact_365', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'

-- Infogroup
--EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Falcons', @LoadView = '[ods].[vw_Infogroup_LoadDimCustomer]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'

--FB_Leads
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Falcons', @LoadView = 'etl.vw_Load_DimCustomer_FB_Leads', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'

--FB_Leads_1x
--EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Falcons', @LoadView = '[ods].[vw_FB_Leads_LoadDimCustomer_1x]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'

--TM
--EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Falcons', @LoadView = '[ods].[vw_TM_LoadDimCustomer]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'

----TM-Falcons_Dome
--EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Falcons_Dome', @LoadView = '[ods].[vw_TM_LoadDimCustomer]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'

----TM-Falcons_PSL
--EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Falcons_PSL', @LoadView = '[ods].[vw_TM_LoadDimCustomer]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'

--FanCentric
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Falcons', @LoadView = '[etl].[vw_Load_DimCustomer_FanCentric]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'

--IBM Email
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Falcons', @LoadView = '[ods].[vw_LoadDimCustomer_IBM_Email]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'

--Fanatics
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Falcons', @LoadView = '[ods].[vw_Fanatics_LoadDimCustomer]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'

END

GO
