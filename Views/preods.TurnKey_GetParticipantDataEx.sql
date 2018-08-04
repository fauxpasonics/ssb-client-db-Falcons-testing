SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [preods].[TurnKey_GetParticipantDataEx]
AS

SELECT DISTINCT
	CONVERT(NVARCHAR(50),[ETL__multi_query_value_for_audit]) [SurveyID_K]
	,CONVERT(bigint,[L2_AllData_Participant_recordid]) [recordid_k]
	,CONVERT(datetime,[L2_AllData_Participant_started]) [started]
	,CONVERT(datetime,[L2_AllData_Participant_completed]) [completed]
	,CONVERT(NVARCHAR(50),[L2_AllData_Participant_branched-out]) [branched_out]
	,CONVERT(NVARCHAR(50),[L2_AllData_Participant_over-quota]) [over_quota]
	,CONVERT(datetime,[L2_AllData_Participant_modified]) [modified]
	,CONVERT(int,[L2_AllData_Participant_campaign-status]) [campaign_status]
	,CONVERT(NVARCHAR(50),[L2_AllData_Participant_culture]) [culture]
	,CONVERT(NVARCHAR(255),[L2_AllData_Participant_http-referer]) [http_referer]
	,CONVERT(NVARCHAR(500),[L2_AllData_Participant_http-user-agent]) [http_user_agent]
	,CONVERT(NVARCHAR(255),[L2_AllData_Participant_remote-addr]) [remote_addr]
	,CONVERT(NVARCHAR(255),[L2_AllData_Participant_remote-host]) [remote_host]
	,CONVERT(Nvarchar(255),[L2_AllData_Participant_last-page]) [Participant_last_page]
	,CONVERT(NVARCHAR(500),[L2_AllData_Participant_url]) [Participant_url]
	,CONVERT(int,[L2_AllData_Participant_last-page-number]) [Participant_last_page_number]
	,CONVERT(int,[L2_AllData_Participant_modifier]) [Participant_modifier]
	,CONVERT(int,[L2_AllData_Participant_device-type]) [Participant_device_type]
	,CONVERT(NVARCHAR(255),[L2_AllData_Participant_ua-family]) [Participant_ua_family]
	,CONVERT(NVARCHAR(255),[L2_AllData_Participant_ua-majorver]) [Participant_ua_majorver]
	,CONVERT(NVARCHAR(255),[L2_AllData_Participant_os-name]) [Participant_os_name]
	,CONVERT(NVARCHAR(255),[L2_AllData_Participant_os-family]) [Participant_os_family]
	,CONVERT(NVARCHAR(100),[L2_AllData_Participant_iploc-long]) [Participant_iploc_long]
	,CONVERT(NVARCHAR(100),[L2_AllData_Participant_iploc-lat]) [Participant_iploc_lat]
	,CONVERT(NVARCHAR(100),[L2_AllData_Participant_iploc-city]) [Participant_iploc_city]
	,CONVERT(NVARCHAR(255),[L2_AllData_Participant_iploc-state]) [Participant_iploc_state]
	,CONVERT(NVARCHAR(255),[L2_AllData_Participant_iploc-country]) [Participant_iploc_country]
	,CONVERT(NVARCHAR(100),[L2_AllData_Participant_iploc-zipcode]) [Participant_iploc_zipcode]
	FROM [src].[TurnKey_GetParticipantDataEx] WITH (NOLOCK)
	WHERE [L2_AllData_Participant_recordid] IS NOT NULL
	
	UNION

	SELECT
	CONVERT(NVARCHAR(50),[ETL__multi_query_value_for_audit]) [SurveyID_K]
	,CONVERT(bigint,[L3_AllData_Participant_recordid]) [Participant_recordid_k]
	,CONVERT(datetime,[L3_AllData_Participant_started]) [Participant_started]
	,CONVERT(datetime,[L3_AllData_Participant_completed]) [Participant_completed]
	,CONVERT(NVARCHAR(50),[L3_AllData_Participant_branched-out]) [Participant_branched_out]
	,CONVERT(NVARCHAR(50),[L3_AllData_Participant_over-quota]) [Participant_over_quota]
	,CONVERT(datetime,[L3_AllData_Participant_modified]) [Participant_modified]
	,CONVERT(int,[L3_AllData_Participant_campaign-status]) [Participant_campaign_status]
	,CONVERT(NVARCHAR(50),[L3_AllData_Participant_culture]) [Participant_culture]
	,CONVERT(NVARCHAR(255),[L3_AllData_Participant_http-referer]) [Participant_http_referer]
	,CONVERT(NVARCHAR(500),[L3_AllData_Participant_http-user-agent]) [Participant_http_user_agent]
	,CONVERT(NVARCHAR(255),[L3_AllData_Participant_remote-addr]) [Participant_remote_addr]
	,CONVERT(NVARCHAR(255),[L3_AllData_Participant_remote-host]) [Participant_remote_host]
	,CONVERT(NVARCHAR(255),[L3_AllData_Participant_last-page]) [Participant_last_page]
	,CONVERT(NVARCHAR(500),[L3_AllData_Participant_url]) [Participant_url]
	,CONVERT(int,[L3_AllData_Participant_last-page-number]) [Participant_last_page_number]
	,CONVERT(int,[L3_AllData_Participant_modifier]) [Participant_modifier]
	,CONVERT(int,[L3_AllData_Participant_device-type]) [Participant_device_type]
	,CONVERT(NVARCHAR(255),[L3_AllData_Participant_ua-family]) [Participant_ua_family]
	,CONVERT(NVARCHAR(255),[L3_AllData_Participant_ua-majorver]) [Participant_ua_majorver]
	,CONVERT(NVARCHAR(255),[L3_AllData_Participant_os-name]) [Participant_os_name]
	,CONVERT(NVARCHAR(255),[L3_AllData_Participant_os-family]) [Participant_os_family]
	,CONVERT(NVARCHAR(100),[L3_AllData_Participant_iploc-long]) [Participant_iploc_long]
	,CONVERT(NVARCHAR(100),[L3_AllData_Participant_iploc-lat]) [Participant_iploc_lat]
	,CONVERT(NVARCHAR(100),[L3_AllData_Participant_iploc-city]) [Participant_iploc_city]
	,CONVERT(NVARCHAR(255),[L3_AllData_Participant_iploc-state]) [Participant_iploc_state]
	,CONVERT(NVARCHAR(255),[L3_AllData_Participant_iploc-country]) [Participant_iploc_country]
	,CONVERT(NVARCHAR(100),[L3_AllData_Participant_iploc-zipcode]) [Participant_iploc_zipcode]
FROM [src].[TurnKey_GetParticipantDataEx] WITH (NOLOCK)
WHERE [L3_AllData_Participant_recordid] IS NOT NULL

GO
