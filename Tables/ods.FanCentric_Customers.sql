CREATE TABLE [ods].[FanCentric_Customers]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__FanCentri__ETL_C__01C22FCA] DEFAULT (getdate()),
[ETL_UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF__FanCentri__ETL_U__02B65403] DEFAULT (getdate()),
[ETL_IsDeleted] [bit] NOT NULL CONSTRAINT [DF__FanCentri__ETL_I__03AA783C] DEFAULT ((0)),
[ETL_DeletedDate] [datetime] NULL,
[ETL_DeltaHashKey] [binary] (32) NULL,
[ETL_FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUST_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMAIL_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMAIL_ADDR] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EMAILABLE_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[USERNAME] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADDR_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[INDIV_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FAV_TEAM_CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TEAM_LONG_NM] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GENDER] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FIRST_NM] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LAST_NM] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MIDDLE_NM] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACE_PRIM_ADDR] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACE_SEC_ADDR] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACE_CITY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACE_STATE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACE_POSTAL_CODE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACE_ISO_CODE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BIRTH_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AGE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ORIG_SRC] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ORIG_SRC_DT] [date] NULL,
[ORIG_SRC_BU] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ORIG_EPS_FCM_CRTD_DT] [date] NULL,
[IN_MARKET_CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BU_CLUBS_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BU_DCOM_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BU_LIVE_EVENT_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BU_PRTR_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BU_SHOP_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BU_YUTH_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BU_INTL_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BU_OTHR_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BU_MKTG_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JETS_CROSSOVER_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CROSSOVER_BU_CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CROSSOVER_PRODUCT_CD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_FANTASY_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_FANT_LM_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_FANT_UE_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_FANT_CUSTOM_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_FANT_MANAGED_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_SUB_PROD] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_SUB_PROD_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_GPD_SUB_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_GPD_FT_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_GPI_SUB_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_GPI_FT_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_GPI_SUB_SSN_SSN_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_GPI_SUB_SSNPLS_SSN_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_GPI_SUB_WKLY_SSN_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_GPI_SUB_FYT_SSN_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_NFL_NOW_SIGNUP_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_MINIGM_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_MINIGM_SSN_REG_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_PERFCH_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_PERFCH_SSN_REG_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_PLAYCH_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_PLAYCH_SSN_REG_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_PICKEM_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_PICKEM_SSN_REG_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_PTP_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_PTP_SSN_REG_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_DRAFT_FMP_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_KICKOFF_FMP_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_SB_FMP_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_PB_STH_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_PB_STB_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_LST_PURCH_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_DOL_3M] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_DOL_6M] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_DOL_1YR] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_DOL_TOTAL] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_ORD_TOTAL] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_LST_CANCER_PURCH_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_CANCER_PURCHASES] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_CANCER_DOL] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_LST_BT_PURCH_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_BT_PURCHASES] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_BT_DOL] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_LST_JERSEYS_PURCH_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_JERSEYS_PURCHASES] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_JERSEYS_DOL] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_LST_HOMEOFF_PURCH_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_HOMEOFF_PURCHASES] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_HOMEOFF_DOL] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_LST_MENS_PURCH_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_MENS_PURCHASES] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_MENS_DOL] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_LST_PLUS_PURCH_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_PLUS_PURCHASES] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_PLUS_DOL] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_LST_YOUTH_PURCH_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_YOUTH_PURCHASES] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_YOUTH_DOL] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_LST_WOMENS_PURCH_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_WOMENS_PURCHASES] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_WOMENS_DOL] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_LST_UNDERMINED_PURCH_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_UNDERMINED_PURCHASES] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SHOP_UNDERMINED_DOL] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACTIVE_0_3M_FLAG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACTIVE_4_6M_FLAG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACTIVE_7_12M_FLAG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACTIVE_1YR_FLAG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACTIVE_2YR_FLAG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ACTIVE_3YR_FLAG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUST_RECENCY_DT] [date] NULL,
[EM_LST_OPEN_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EM_LST_DCOM_OPEN_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EM_LST_MOBILE_OPEN_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EM_LST_SMRTPH_OPEN_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EM_LST_TABLT_OPEN_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EM_LST_CLICK_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EM_LST_DCOM_CLICK_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EM_LST_MOBILE_CLICK_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EM_LST_SMRTPH_CLICK_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EM_LST_TABLT_CLICK_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WEB_LST_VST_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[APP_LST_VST_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FANTASY_LST_VST_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_M_FANTASY_VST_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CURR_SSN_WEB_PAGEVIEWS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CURR_SSN_FANTASY_PAGEVIEWS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CURR_SSN_APP_VISITS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CURR_SSN_M_FANTASY_PAGEVIEWS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREV_SSN_WEB_PAGEVIEWS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREV_SSN_FANTASY_PAGEVIEWS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREV_SSN_APP_VISITS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PREV_SSN_M_FANTASY_PAGEVIEWS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TOTAL_SSN_WEB_PAGEVIEWS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TOTAL_CURR_SSN_FANTASY_PAGEVW] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TOTAL_CURR_SSN_APP_VISITS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TOTAL_CURR_SSN_M_FANT_PAGEVW] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_CLUBS_STH_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_CLUBS_STB_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CLUBS_STB_TIX_REV] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CLUBS_STB_TIX_ORDERS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CLUBS_STB_TIX_LST_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CLUBS_STB_NUMSEATS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LST_TICKET_EXCH_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TICKET_EXCH_REV] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TICKET_EXCH_ORDERS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TICKET_EXCH_LST_DT] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TICKET_EXCH_NUMSEATS] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DTV_SUNDAY_TICKET_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DTV_SUNDAY_TICKET_ACTIVE_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DTV_TV_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DTV_TV_ACTIVE_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DTV_COMMERICAL_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DTV_COMMERICAL_ACTIVE_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MADDEN_PLAYER_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NFLN_SURVEY_HAVE_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NFLN_SURVEY_AWARE_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GIGYA_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOCIAL_FACEBOOK_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOCIAL_GOOGLEPLUS_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SOCIAL_MESSENGER_FLG] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TRANSACTIONAL_VALUE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TRANSACTIONAL_VALUE_CURR_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TRANSACTIONAL_VALUE_PREV_SSN] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EPS_CRTD_DT] [date] NULL
)
GO
ALTER TABLE [ods].[FanCentric_Customers] ADD CONSTRAINT [PK__FanCentr__7EF6BFCD0B24BD11] PRIMARY KEY CLUSTERED  ([ETL_ID])
GO
