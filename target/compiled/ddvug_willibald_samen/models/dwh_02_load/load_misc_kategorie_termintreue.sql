with 
hwm as
    (
        select max(hwm_ldts) hwm_max_ts from WILLIBALD_DATA_VAULT_WITH_DBT.DWH_00_META.META_HWM where object_name = 'WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_misc_kategorie_termintreue'
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
		, TRIM(value:c1::STRING) as "ANZAHL_TAGE_VON_RAW"
                , TRIM(value:c2::STRING) as "ANZAHL_TAGE_BIS_RAW"
                , TRIM(value:c3::STRING) as "BEZEICHNUNG_RAW"
                , TRIM(value:c4::STRING) as "BEWERTUNG_RAW"
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.DWH_01_EXT.EXT_MISC_KATEGORIE_TERMINTREUE
)
SELECT 
		  TRY_TO_TIMESTAMP("LDTS_SOURCE_RAW", 'YYYYMMDD_HH24MISS') as "LDTS_SOURCE"
                , "RSRC_SOURCE_RAW" as "RSRC_SOURCE" 
		, TRY_TO_DATE("EDTS_IN_RAW", 'YYYYMMDD') as "EDTS_IN"
                , "RAW_DATA_RAW" as "RAW_DATA"
                , TRY_TO_NUMBER("ROW_NUMBER_RAW") as "ROW_NUMBER" 
		, "ANZAHL_TAGE_VON_RAW" as "ANZAHL_TAGE_VON"
                , "ANZAHL_TAGE_BIS_RAW" as "ANZAHL_TAGE_BIS"
                , "BEZEICHNUNG_RAW" as "BEZEICHNUNG"
                , "BEWERTUNG_RAW" as "BEWERTUNG" 
		, TRY_TO_TIMESTAMP("LDTS_SOURCE_RAW", 'YYYYMMDD_HH24MISS') IS NOT NULL OR "LDTS_SOURCE_RAW" IS NULL as "IS_LDTS_SOURCE_TYPE_OK" 
		, TRY_TO_DATE("EDTS_IN_RAW", 'YYYYMMDD') IS NOT NULL OR "EDTS_IN_RAW" IS NULL as "IS_EDTS_IN_TYPE_OK"
                , TRY_TO_NUMBER("ROW_NUMBER_RAW") IS NOT NULL OR "ROW_NUMBER_RAW" IS NULL as "IS_ROW_NUMBER_TYPE_OK" 
		, ROW_NUMBER() OVER (PARTITION BY ldts_source,bewertung ORDER BY ldts_source,bewertung) = 1 AS "IS_DUB_CHECK_OK" 
		, COALESCE("BEWERTUNG_RAW", '') <> '' as "IS_BEWERTUNG_KEY_CHECK_OK"
		 
		, "IS_LDTS_SOURCE_TYPE_OK" AND "IS_EDTS_IN_TYPE_OK" AND "IS_ROW_NUMBER_TYPE_OK" AND "IS_DUB_CHECK_OK" AND "IS_BEWERTUNG_KEY_CHECK_OK" is_check_ok
		 
		,  TO_VARIANT(ARRAY_EXCEPT([REPLACE(IFF(NOT "IS_LDTS_SOURCE_TYPE_OK",'{"ldts_source":"' || COALESCE(TO_VARCHAR("LDTS_SOURCE_RAW") ,'') || '"}','') || IFF(NOT "IS_EDTS_IN_TYPE_OK",'{"edts_in":"' || COALESCE(TO_VARCHAR("EDTS_IN_RAW") ,'') || '"}','') || IFF(NOT "IS_ROW_NUMBER_TYPE_OK",'{"row_number":"' || COALESCE(TO_VARCHAR("ROW_NUMBER_RAW") ,'') || '"}','') || IFF(NOT is_dub_check_ok, '{"dub_check": "ldts_source,bewertung"}','') || IFF(NOT is_bewertung_key_check_ok, '{"key_check": "bewertung"}',''), '}{','},{')],[''])) chk_all_msg
		FROM raw_data 


CROSS JOIN hwm_max 
WHERE ldts_source > hwm_max.hwm_max_ts
