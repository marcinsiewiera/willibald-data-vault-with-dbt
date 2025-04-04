
  
    

        create or replace  table WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_bestellung
         as
        (with 
hwm as
    (
        select max(hwm_ldts) hwm_max_ts from WILLIBALD_DATA_VAULT_WITH_DBT.DWH_00_META.META_HWM where object_name = 'WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_bestellung'
    ),
    hwm_max AS
    (
        select COALESCE(hwm.hwm_max_ts,to_timestamp('01.01.1900','DD.MM.YYYY') ) hwm_max_ts from hwm
    ),
raw_data AS 
(
	SELECT 
		  TRIM(replace(right(filenamedate,19),'.csv','')::STRING) as "LDTS_SOURCE_RAW"
                , TRIM(filenamedate::STRING) as "RSRC_SOURCE_RAW"
		, TRIM(trim(reverse(substring(reverse(replace(filenamedate,'.csv','')), 17,8))::varchar)::STRING) as "EDTS_IN_RAW"
                , TRIM(value::STRING) as "RAW_DATA_RAW"
                , TRIM(metadata$file_row_number::STRING) as "ROW_NUMBER_RAW"
		, TRIM(value:c1::STRING) as "BESTELLUNGID_RAW"
                , TRIM(value:c2::STRING) as "KUNDEID_RAW"
                , REPLACE(TRIM(value:c3::STRING) , ',', '') as "ALLGLIEFERADRID_RAW"
                , TRIM(value:c4::STRING) as "BESTELLDATUM_RAW"
                , TRIM(value:c5::STRING) as "WUNSCHDATUM_RAW"
                , REPLACE(TRIM(value:c6::STRING) , ',', '.') as "RABATT_RAW"
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.DWH_01_EXT.EXT_WEBSHOP_BESTELLUNG
)
SELECT 
		  TRY_TO_TIMESTAMP("LDTS_SOURCE_RAW", 'YYYYMMDD_HH24MISS') as "LDTS_SOURCE"
                , "RSRC_SOURCE_RAW" as "RSRC_SOURCE" 
		, TRY_TO_DATE("EDTS_IN_RAW", 'YYYYMMDD') as "EDTS_IN"
                , "RAW_DATA_RAW" as "RAW_DATA"
                , TRY_TO_NUMBER("ROW_NUMBER_RAW") as "ROW_NUMBER" 
		, "BESTELLUNGID_RAW" as "BESTELLUNGID"
                , "KUNDEID_RAW" as "KUNDEID"
                , TRY_TO_NUMBER("ALLGLIEFERADRID_RAW") as "ALLGLIEFERADRID"
                , TRY_TO_DATE("BESTELLDATUM_RAW", 'DD.MM.YYYY') as "BESTELLDATUM"
                , TRY_TO_DATE("WUNSCHDATUM_RAW", 'DD.MM.YYYY') as "WUNSCHDATUM"
                , TRY_TO_NUMBER("RABATT_RAW", 28,10) as "RABATT" 
		, TRY_TO_TIMESTAMP("LDTS_SOURCE_RAW", 'YYYYMMDD_HH24MISS') IS NOT NULL OR "LDTS_SOURCE_RAW" IS NULL as "IS_LDTS_SOURCE_TYPE_OK" 
		, TRY_TO_DATE("EDTS_IN_RAW", 'YYYYMMDD') IS NOT NULL OR "EDTS_IN_RAW" IS NULL as "IS_EDTS_IN_TYPE_OK"
                , TRY_TO_NUMBER("ROW_NUMBER_RAW") IS NOT NULL OR "ROW_NUMBER_RAW" IS NULL as "IS_ROW_NUMBER_TYPE_OK" 
		, TRY_TO_NUMBER("ALLGLIEFERADRID_RAW") IS NOT NULL OR "ALLGLIEFERADRID_RAW" IS NULL as "IS_ALLGLIEFERADRID_TYPE_OK"
                , TRY_TO_DATE("BESTELLDATUM_RAW", 'DD.MM.YYYY') IS NOT NULL OR "BESTELLDATUM_RAW" IS NULL as "IS_BESTELLDATUM_TYPE_OK"
                , TRY_TO_DATE("WUNSCHDATUM_RAW", 'DD.MM.YYYY') IS NOT NULL OR "WUNSCHDATUM_RAW" IS NULL as "IS_WUNSCHDATUM_TYPE_OK"
                , TRY_TO_NUMBER("RABATT_RAW", 28,10) IS NOT NULL OR "RABATT_RAW" IS NULL as "IS_RABATT_TYPE_OK" 
		, ROW_NUMBER() OVER (PARTITION BY ldts_source,BestellungID,KundeID ORDER BY ldts_source,BestellungID,KundeID) = 1 AS "IS_DUB_CHECK_OK" 
		, COALESCE("BESTELLUNGID_RAW", '') <> '' as "IS_BESTELLUNGID_KEY_CHECK_OK"
		 
		, "IS_LDTS_SOURCE_TYPE_OK" AND "IS_EDTS_IN_TYPE_OK" AND "IS_ROW_NUMBER_TYPE_OK" AND "IS_ALLGLIEFERADRID_TYPE_OK" AND "IS_BESTELLDATUM_TYPE_OK" AND "IS_WUNSCHDATUM_TYPE_OK" AND "IS_RABATT_TYPE_OK" AND "IS_DUB_CHECK_OK" AND "IS_BESTELLUNGID_KEY_CHECK_OK" is_check_ok
		 
		,  TO_VARIANT(ARRAY_EXCEPT([REPLACE(IFF(NOT "IS_LDTS_SOURCE_TYPE_OK",'{"ldts_source":"' || COALESCE(TO_VARCHAR("LDTS_SOURCE_RAW") ,'') || '"}','') || IFF(NOT "IS_EDTS_IN_TYPE_OK",'{"edts_in":"' || COALESCE(TO_VARCHAR("EDTS_IN_RAW") ,'') || '"}','') || IFF(NOT "IS_ROW_NUMBER_TYPE_OK",'{"row_number":"' || COALESCE(TO_VARCHAR("ROW_NUMBER_RAW") ,'') || '"}','') || IFF(NOT "IS_ALLGLIEFERADRID_TYPE_OK",'{"allglieferadrid":"' || COALESCE(TO_VARCHAR("ALLGLIEFERADRID_RAW") ,'') || '"}','') || IFF(NOT "IS_BESTELLDATUM_TYPE_OK",'{"bestelldatum":"' || COALESCE(TO_VARCHAR("BESTELLDATUM_RAW") ,'') || '"}','') || IFF(NOT "IS_WUNSCHDATUM_TYPE_OK",'{"wunschdatum":"' || COALESCE(TO_VARCHAR("WUNSCHDATUM_RAW") ,'') || '"}','') || IFF(NOT "IS_RABATT_TYPE_OK",'{"rabatt":"' || COALESCE(TO_VARCHAR("RABATT_RAW") ,'') || '"}','') || IFF(NOT is_dub_check_ok, '{"dub_check": "ldts_source,BestellungID,KundeID"}','') || IFF(NOT is_BestellungID_key_check_ok, '{"key_check": "BestellungID"}',''), '}{','},{')],[''])) chk_all_msg
		FROM raw_data 


CROSS JOIN hwm_max 
WHERE ldts_source > hwm_max.hwm_max_ts

        );
      
  