SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [etl].[vwTurnkeySurveyOutput] 
AS

--252,760
SELECT a.ETL__multi_query_value_for_audit,surv.Name SurveyName, Record.Value RecordID,QuestionText Question, t.Topic SubQuestion, a.Value Response, COALESCE(col3.value,col4c.value,col4d.value,col5d.Value,col6e.Value,col7c.Value) Heading,  a.[key]
, par.Started, par. Completed, par.LastPageNumber
--,COALESCE(col3.value,col4c.value,col4d.value,col5d.Value,col6e.Value,col7c.Value) as heading ,COALESCE(id4.value,id3.value,id2.value,col4.value) as ID--, col4a.ParentJID, col4b.value
--,id4.value,id3.value,id2.value,col4.value
FROM etl.TurnKey_GetSurveyDataEX (NOLOCK)a --where level =2
JOIN 
		(SELECT ParentJID, value, ROW_NUMBER() OVER(PARTITION BY value ORDER BY ETL__insert_datetime DESC) rn  FROM etl.TurnKey_GetSurveyDataEX (NOLOCK) WHERE [key] = 'recordid' --and value ='635970186474825824'
		--and value = 636289863137996782 --and [key] = 'Q187_1'
		) Record 
	ON a.ParentJID = Record.ParentJID
	AND record.rn = 1
JOIN (SELECT *, ROW_NUMBER() OVER(PARTITION BY [@id] ORDER BY ETL__TurnKey_GetSurveyList_id DESC) rn  FROM [apietl].[TurnKey_GetSurveyList_Project_1]) Surv 
	ON a.ETL__multi_query_value_for_audit = surv.[@id]
	AND surv.rn = 1
JOIN etl.[TurnKey_GetSurveyInformation]  col
	ON col.[key] ='@column'
		AND a.[Key] = col.value
		AND a.ETL__multi_query_value_for_audit = col.ETL__multi_query_value_for_audit
		--AND col.rn=1
		--and a.[key] = 'Q123'
LEFT JOIN etl.[TurnKey_GetSurveyInformation] col3 ON col.parentJID = col3.ParentJID AND col3.[key] ='@heading'
--left JOIN etl.[TurnKey_GetSurveyInformation] Class1 on col.parentJID = Class1.ParentJID and Class1.[key] ='@class'
LEFT JOIN etl.[TurnKey_GetSurveyInformation] col4 ON col.parentJID = col4.ParentJID AND col4.[key] ='@id'
LEFT JOIN etl.[TurnKey_GetSurveyInformation] col4a ON col4.ParentJID = col4a.JID 
LEFT JOIN etl.[TurnKey_GetSurveyInformation] col4b ON col4a.ParentJID = col4b.JID 
LEFT JOIN etl.[TurnKey_GetSurveyInformation] col4c ON col4b.ParentJID = col4c.ParentJID AND col4c.[key] ='@heading'
--2left JOIN etl.[TurnKey_GetSurveyInformation] Class2 on col4b.parentJID = Class1.ParentJID and Class2.[key] ='@class'
LEFT JOIN etl.[TurnKey_GetSurveyInformation] col4d ON col4b.JID = col4d.ParentJID AND col4d.[key] ='@heading'
--2left JOIN etl.[TurnKey_GetSurveyInformation] Class3 on col4b.JID = Class1.ParentJID and Class2.[key] ='@class'
LEFT JOIN etl.[TurnKey_GetSurveyInformation] col5c ON col4b.ParentJID = col5c.JID 
LEFT JOIN etl.[TurnKey_GetSurveyInformation] col5d ON col5c.ParentJID = col5d.ParentJID AND col5d.[key] ='@heading'
LEFT JOIN etl.[TurnKey_GetSurveyInformation] id2 ON col5d.jid = id2.ParentJID AND id2.[key] ='@id'
LEFT JOIN etl.[TurnKey_GetSurveyInformation] col6d ON col5c.ParentJID = col6d.JID 
LEFT JOIN etl.[TurnKey_GetSurveyInformation] col6e ON col6e.ParentJID = col6d.ParentJID AND col6e.[key] ='@heading'
LEFT JOIN etl.[TurnKey_GetSurveyInformation] id3 ON col6e.jid = id3.ParentJID AND id3.[key] ='@id'
LEFT JOIN etl.[TurnKey_GetSurveyInformation] col7a ON col6d.ParentJID = col7a.JID 
LEFT JOIN etl.[TurnKey_GetSurveyInformation] col7b ON col7a.ParentJID = col7b.JID 
LEFT JOIN etl.[TurnKey_GetSurveyInformation] col7c ON col7b.JID = col7c.ParentJID AND col7c.[key] ='@heading'
LEFT JOIN etl.[TurnKey_GetSurveyInformation] id4 ON col7c.jid = id4.ParentJID AND id4.[key] ='@id'
INNER JOIN (
		SELECT  ParentJID, ETL__multi_query_value_for_audit,
		[Heading-Text] QuestionHeadingID, [Body-Text] QuestionText
		FROM
			(
				SELECT a.[key] + '-' + b.[Key] [Key] , a.ParentJID, b.value,a.ETL__multi_query_value_for_audit
				FROM [etl].[TurnKey_GetSurveyFieldInformation] a --where JID = 82
					--where rn = 1
					--[etl].[TurnKey_GetSurveyFieldInformation] a
				JOIN [etl].[TurnKey_GetSurveyFieldInformation] b ON a.JID = b.parentJID
					--AND a.rn=1
				WHERE  a.[key] IN ('Heading', 'Body')			
			) AS SourceTable
		PIVOT
		(
		MAX(value)
		FOR [Key] IN ([Heading-Text], [Body-Text])
		) AS PivotTable
) HeaderInfo
ON COALESCE(col3.value,col4c.value,col4d.value,col5d.Value,col6e.Value,col7c.Value) = headerinfo.QuestionHeadingID
	AND a.ETL__multi_query_value_for_audit = HeaderInfo.ETL__multi_query_value_for_audit
LEFT JOIN 
	(
		SELECT a.ETL__multi_query_value_for_audit, f.value Heading,b.[Key] + 1 ID,c.value Topic  
		FROM  [etl].[TurnKey_GetSurveyFieldInformation] a
		JOIN [etl].[TurnKey_GetSurveyFieldInformation] b ON a.JID = b.parentjid AND a.[key] = 'Topic' --and a.rn=1
		LEFT JOIN [etl].[TurnKey_GetSurveyFieldInformation] c ON b.JID = c.parentjid
		LEFT JOIN [etl].[TurnKey_GetSurveyFieldInformation] d ON a.parentjid = d.jid
		JOIN [etl].[TurnKey_GetSurveyFieldInformation] e ON d.jid = e.parentjid AND e.[key] = 'Heading' --and e.value = '20'
		LEFT JOIN [etl].[TurnKey_GetSurveyFieldInformation] f ON e.jid = f.parentjid
		WHERE ISNUMERIC(b.[Key]) = 1
		--and a.ETL__multi_query_value_for_audit =1002811988
	) T
ON COALESCE(col3.value,col4c.value,col4d.value,col5d.Value,col6e.Value,col7c.Value) = t.Heading
	AND COALESCE(id4.value,id3.value,id2.value,col4.value) = T.ID
	AND a.ETL__multi_query_value_for_audit = T.ETL__multi_query_value_for_audit
LEFT JOIN
	(
		SELECT a.ETL__multi_query_value_for_audit, a.value RecordId, sta.value Started, com.value Completed, lp.value LastPageNumber
		, ROW_NUMBER() OVER(PARTITION BY a.value ORDER BY ETL__insert_datetime DESC) rn  
		FROM etl.TurnKey_GetParticipantDataEX a 
		--join (Select ParentJID, value from etl.TurnKey_GetParticipantDataEX (NOLOCK) where [key] = '@recordid' ) Record on a.ParentJID = Record.ParentJID
		JOIN (SELECT ParentJID, value FROM etl.TurnKey_GetParticipantDataEX (NOLOCK) WHERE [key] = '@started' ) sta ON a.ParentJID = sta.ParentJID
		JOIN (SELECT ParentJID, value FROM etl.TurnKey_GetParticipantDataEX (NOLOCK) WHERE [key] = '@completed' ) com ON a.ParentJID = com.ParentJID
		JOIN (SELECT ParentJID, value FROM etl.TurnKey_GetParticipantDataEX (NOLOCK) WHERE [key] = '@last_page_number' ) lp ON a.ParentJID = lp.ParentJID
		WHERE a.[key]  = '@recordid'
	) par
ON a.ETL__multi_query_value_for_audit = par.ETL__multi_query_value_for_audit
	AND Record.Value = par.RecordId
	AND par.rn =1
GO
