CREATE TABLE [src].[MLS_LOOKALIKE]
(
[ID] [float] NULL,
[SOURCE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXISTING_SSB] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CREATE_DATE] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSB_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Addr1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Addr2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [float] NULL,
[Phone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MLSSource] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Team] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Acct_ID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Subscriber_Key] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email_Id] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Acctno] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerID] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_primary_number] [float] NULL,
[AH1_mb_zip4_pre_direction] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_primary_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_street_suffix] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_post_direction] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_unit_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_unit_number] [float] NULL,
[AH1_mb_zip4_city_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_state_abbreviation] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_zip_code] [float] NULL,
[AH1_mb_zip4_zip4_code] [float] NULL,
[AH1_mb_zip4_advanced_bar_code_and_check_digit] [float] NULL,
[AH1_mb_zip4_carrier_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_zip4_match_level] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_primary_number_is_a_box] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_zip_code_status] [float] NULL,
[AH1_mb_zip4_city_name_has_changed] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_line_of_travel_information] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_lot_sortation_number] [float] NULL,
[AH1_mb_zip4_state_code] [float] NULL,
[AH1_mb_zip4_county_code] [float] NULL,
[AH1_mb_zip4_lacs_indicator] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_urbanization_code_for_puerto_rico] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_unit_return_code_from_finalist] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_FILLER] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_vendor_source] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_city_type_indicator] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_address_type_indicator] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_aa] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_a1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_a2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_a3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes___expansion1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_d] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_e] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_f] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes___expansion2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_h] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes___expansion3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_j] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_k] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_k1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_k2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_l] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_m1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_m2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_n1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_n2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_p1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_p2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_q1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_q2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_m3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_footnote_m4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes___expansion4] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_zip4_footnotes_ews] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_match_level] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_coa_move_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_coa_effective_move_date] [float] NULL,
[AH1_mb_coa_delivery_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_primary_number] [float] NULL,
[AH1_mb_coa_pre_direction] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_primary_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_street_suffix] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_post_direction] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_unit_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_unit_number] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_city_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_state_abbreviation] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_zip_code] [float] NULL,
[AH1_mb_coa_zip4_addon] [float] NULL,
[AH1_mb_coa_delivery_point_and_check_digit] [float] NULL,
[AH1_mb_coa_carrier_route_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_zip4_match_level] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_primary_number_is_a_box] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_urbanization_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_record_type] [float] NULL,
[AH1_mb_coa_multi_source_match] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_reserved] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_individual_match_logic_required] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_ncoalink_return_code] [float] NULL,
[AH1_mb_coa___expansion1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_query_prefix_title] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_query_given_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_query_middle_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_query_surname] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa_query_surname_suffix] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_coa___expansion2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dpv_footnote_aa] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dpv_footnote_a1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dpv_footnote_bb] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dpv_footnote_cc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dpv_footnote_n1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dpv_footnote_m1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dpv_footnote_m3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dpv_footnote_p1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dpv_footnote_rr] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dpv_footnote_r1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dpv_confirmation_indicator] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dpv_footnote_p3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dpv_lacs_indicator] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dpv_footnote_f1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dpv_footnote_g1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dpv_footnote_u1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dsf2_match_level] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dsf2_pseudo_sequence] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv___expansion2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dsf2_educational_indicator] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dsf2_vacant] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dsf2_seasonal] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dsf2_residential_business_general_delivery] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dsf2_throwback] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dsf2_delivery_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dsf2_delivery_drop] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dsf2_delivery_drop_count] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dsf2_lacs_indicator] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv_dsf2_no_stat] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_dpv___expansion3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address_address_source_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address_address_status_delivery_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address_pander_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address_local_address_line_1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address_unit_information_line] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address_secondary_address_line] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address_long_city_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address_short_city_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address_state] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address_zip_code] [float] NULL,
[AH1_mb_mailing_address_zip_four] [float] NULL,
[AH1_mb_mailing_address___expansion1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address_mailability_score] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address___expansion2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address_military_zip_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address_opac_match_indicator] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address_ndi_affirmed_apt_indicator] [float] NULL,
[AH1_mb_mailing_address_secondary_address_indicator] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address_state_code] [float] NULL,
[AH1_mb_mailing_address_county_code] [float] NULL,
[AH1_mb_mailing_address_long_city_indicator] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address_carrier_route_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address_line_of_travel_information] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address_lot_sortation_number] [float] NULL,
[AH1_mb_mailing_address_prestige_city_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AH1_mb_mailing_address_zip_addon_delivery_point] [float] NULL,
[Match_Level] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Match_Score] [float] NULL,
[Household_ID] [float] NULL,
[Individual_HoH_Individual_ID] [float] NULL,
[Location_ID] [float] NULL,
[CE_Edited_Address40] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Selected_Individual_ID] [float] NULL,
[CE_Active_Bank_Card_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Address_Type] [float] NULL,
[CE_Address_Type_String_Recode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Number_Adult_Females] [float] NULL,
[CE_Number_Adult_Males] [float] NULL,
[CE_Number_Adults] [float] NULL,
[CE_Household_Head_Age_Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Household_Head_Age_Code_Source] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Presence_Age_0_To_3_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Presence_Age_13_To_17_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Presence_Age_4_To_7_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Presence_Age_8_To_12_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual_HoH_Age] [float] NULL,
[CE_Individual2_Age] [float] NULL,
[CE_Individual3_Age] [float] NULL,
[CE_Allergies_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Alzheimers_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Angina_Heart_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Apparel_Interest_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Arrival_Date_Formatted] [datetime] NULL,
[CE_Arthritis_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Asthma_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Bank_Card_Holder_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Number_Bathrooms] [float] NULL,
[CE_Number_Bedrooms] [float] NULL,
[CE_Incontenance_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Boat_Owner_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Boat_Propulsion_Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Books_Music_Interest_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Box_Number] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Box_Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Camping_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Car_Buff_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Carrier_Route] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Carrier_Route_Type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Cat_Owner_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Cat_Product_Model] [float] NULL,
[CE_Children_By_Age_By_Gender] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Children_By_Age_By_Month] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Number_Children] [float] NULL,
[CE_Children_Present_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Childrens_Products_Interest_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_City] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Collectibles_Interest_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Computer_Owner_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Construction_Type_Code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Buyer_Behavior_Cluster_Code] [float] NULL,
[CE_Cooking_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Corrective_Lenses_Present_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual_HoH_Has_Finance_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual2_Has_Finance_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual3_Has_Finance_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual_HoH_Has_Misc_Credit_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual2_Has_Misc_Credit_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual3_Has_Misc_Credit_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual_HoH_Has_Oil_Company_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual2_Has_Oil_Company_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual3_Has_Oil_Company_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual_HoH_Has_Premium_Bank_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual2_Has_Premium_Bank_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual3_Has_Premium_Bank_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual_HoH_Has_Retail_Store_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual2_Has_Retail_Store_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual3_Has_Retail_Store_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual_HoH_Has_Specialty_Store_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual2_Has_Specialty_Store_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual3_Has_Specialty_Store_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Household_Head_Has_Travel_Entertainment_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual_HoH_Has_Upscale_Retail_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual2_Has_Upscale_Retail_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual3_Has_Upscale_Retail_Card] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Individual_HoH_YYYYMMDD_Of_Birth] [float] NULL,
[CE_Individual2_YYYYMMDD_Of_Birth] [float] NULL,
[CE_Individual3_YYYYMMDD_Of_Birth] [float] NULL,
[CE_Delivery_Point] [float] NULL,
[CE_Delivery_Unit_Size] [float] NULL,
[CE_Diabetes_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Dieting_Weightloss_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Environment_Contributor_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Health_Contributor_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Political_Contributor_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CE_Religious_Contributor_Flag] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [NFL_Lookalike_ID] ON [src].[MLS_LOOKALIKE] ([ID])
GO
CREATE NONCLUSTERED INDEX [NFL_Lookalike_Index] ON [src].[MLS_LOOKALIKE] ([SSB_ID], [FirstName], [LastName], [email], [Phone])
GO
