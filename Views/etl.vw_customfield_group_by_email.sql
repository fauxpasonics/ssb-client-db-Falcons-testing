SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE VIEW [etl].[vw_customfield_group_by_email]
AS
SELECT 
DISTINCT
    dim.EmailPrimary,
    MAX(CASE WHEN cust.CustomfieldBit1 = 1 THEN 1 ELSE 0 END) AS [Current_PSL_Owners],
    MAX(CASE WHEN cust.CustomfieldBit2 = 1 THEN 1 ELSE 0 END) AS [2018_Falcons_STM],
    MAX(CASE WHEN cust.CustomfieldBit3 = 1 THEN 1 ELSE 0 END) AS [2018_United_STM],
    MAX(CASE WHEN cust.CustomfieldBit4 = 1 THEN 1 ELSE 0 END) AS [NOT SET YET.2017_Falcons_Single_Game_Buyer], 
    MAX(CASE WHEN cust.CustomfieldBit5 = 1 THEN 1 ELSE 0 END) AS [2018_United_Single_Game_Buyer],
    MAX(CASE WHEN cust.CustomfieldBit6 = 1 THEN 1 ELSE 0 END) AS [2017_Falcons_STM],
    MAX(CASE WHEN cust.CustomfieldBit7 = 1 THEN 1 ELSE 0 END) AS [2017_United_STM],
    MAX(CASE WHEN cust.CustomfieldBit8 = 1 THEN 1 ELSE 0 END) AS [2017_Falcons_Single_Game_Buyer],
    MAX(CASE WHEN cust.CustomfieldBit9 = 1 THEN 1 ELSE 0 END) AS [2017_United_Single_Game_Buyer],
    MAX(CASE WHEN cust.CustomfieldBit10 = 1 THEN 1 ELSE 0 END) AS [AU031118],
	MAX(CASE WHEN cust.CustomfieldBit11 = 1 THEN 1 ELSE 0 END) AS [AU031718],
	MAX(CASE WHEN cust.CustomfieldBit12 = 1 THEN 1 ELSE 0 END) AS [AU040718],
	MAX(CASE WHEN cust.CustomfieldBit13 = 1 THEN 1 ELSE 0 END) AS [AU041518],
	MAX(CASE WHEN cust.CustomfieldBit14 = 1 THEN 1 ELSE 0 END) AS [AU042818],
	MAX(CASE WHEN cust.CustomfieldBit15 = 1 THEN 1 ELSE 0 END) AS [AU050918],
	MAX(CASE WHEN cust.CustomfieldBit16 = 1 THEN 1 ELSE 0 END) AS [AU052018],
	MAX(CASE WHEN cust.CustomfieldBit17 = 1 THEN 1 ELSE 0 END) AS [AU060218],
	MAX(CASE WHEN cust.CustomfieldBit18 = 1 THEN 1 ELSE 0 END) AS [AU062418],
	MAX(CASE WHEN cust.CustomfieldBit19 = 1 THEN 1 ELSE 0 END) AS [AU063018],
	MAX(CASE WHEN cust.CustomfieldBit20 = 1 THEN 1 ELSE 0 END) AS [AU071518],
	MAX(CASE WHEN cust.CustomfieldBit21 = 1 THEN 1 ELSE 0 END) AS [AU072118],
	MAX(CASE WHEN cust.CustomfieldBit22 = 1 THEN 1 ELSE 0 END) AS [AU080418],
	MAX(CASE WHEN cust.CustomfieldBit23 = 1 THEN 1 ELSE 0 END) AS [AU081918],
	MAX(CASE WHEN cust.CustomfieldBit24 = 1 THEN 1 ELSE 0 END) AS [AU092218],
	MAX(CASE WHEN cust.CustomfieldBit25 = 1 THEN 1 ELSE 0 END) AS [AU100618],
	MAX(CASE WHEN cust.CustomfieldBit26 = 1 THEN 1 ELSE 0 END) AS [AU102118],
    --MAX(cust.CustomfieldNvarcharMax1) AS CustomfieldNvarcharMax1,
    --MAX(cust.CustomfieldNvarcharMax2) AS CustomfieldNvarcharMax2,
    --MAX(cust.CustomfieldNvarcharMax3) AS CustomfieldNvarcharMax3,
    --MAX(cust.CustomfieldNvarcharMax4) AS CustomfieldNvarcharMax4,
    --MAX(cust.CustomfieldNvarcharMax5) AS CustomfieldNvarcharMax5,
    MAX(cust.CustomfieldNvarchar1) AS PSL_Owner,
    --MAX(cust.CustomfieldNvarchar2) AS CustomfieldNvarchar2,
    --MAX(cust.CustomfieldNvarchar3) AS CustomfieldNvarchar3,
    --MAX(cust.CustomfieldNvarchar4) AS CustomfieldNvarchar4,
    --MAX(cust.CustomfieldNvarchar5) AS CustomfieldNvarchar5,
    --MAX(cust.CustomfieldNvarchar6) AS CustomfieldNvarchar6,
    --MAX(cust.CustomfieldNvarchar7) AS CustomfieldNvarchar7,
    --MAX(cust.CustomfieldNvarchar8) AS CustomfieldNvarchar8,
    --MAX(cust.CustomfieldNvarchar9) AS CustomfieldNvarchar9,
    --MAX(cust.CustomfieldNvarchar10) AS CustomfieldNvarchar10,
    --MAX(CustomFieldInt1) AS CustomFieldInt1, 
    --MAX(CustomFieldInt2) AS CustomFieldInt2, 
    --MAX(CustomFieldInt3) AS CustomFieldInt3, 
    --MAX(CustomFieldInt4) AS CustomFieldInt4, 
    --MAX(CustomFieldInt5) AS CustomFieldInt5, 
    --MAX(CustomFieldInt6) AS CustomFieldInt6, 
    --MAX(CustomFieldInt7) AS CustomFieldInt7, 
    --MAX(CustomFieldInt8) AS CustomFieldInt8, 
    --MAX(CustomFieldInt9) AS CustomFieldInt9, 
    --MAX(CustomFieldInt10) AS CustomFieldInt10,
    --MAX(CustomFieldDecimal1) AS CustomFieldDecimal1,
    --MAX(CustomFieldDecimal2) AS CustomFieldDecimal2,
    --MAX(CustomFieldDecimal3) AS CustomFieldDecimal3,
    --MAX(CustomFieldDecimal4) AS CustomFieldDecimal4,
    --MAX(CustomFieldDecimal5) AS CustomFieldDecimal5,
	MAX(cust.CustomFieldDateTime1) AS optin_AF_date,
	MAX(cust.CustomFieldDateTime2) AS optin_AU_date,
	MAX(cust.CustomFieldDateTime3) AS optin_Stadium_Date,
	MAX(cust.CustomFieldDateTime4) AS CustomFieldDateTime4,
	MAX(cust.CustomFieldDateTime5) AS CustomFieldDateTime5
FROM etl.azure_customtable cust
INNER JOIN dbo.vwDimCustomer_ModAcctId dim
ON dim.DimCustomerId = cust.Dimcustomerid AND dim.IsDeleted = 0
WHERE ISNULL(EmailPrimary,'') != ''
GROUP BY 
    dim.EmailPrimary


GO
