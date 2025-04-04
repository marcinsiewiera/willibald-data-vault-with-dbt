with 
hwm as
    (
        select max(hwm_ldts) hwm_max_ts from WILLIBALD_DATA_VAULT_WITH_DBT.DWH_00_META.META_HWM where object_name = 'WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_wohnort'
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
		, TRIM(value:c1::STRING) as "KUNDEID_RAW"
                , TRIM(value:c2::STRING) as "VON_RAW"
                , TRIM(value:c3::STRING) as "BIS_RAW"
                , TRIM(value:c4::STRING) as "STRASSE_RAW"
                , TRIM(value:c5::STRING) as "HAUSNUMMER_RAW"
                , TRIM(value:c6::STRING) as "ADRESSZUSATZ_RAW"
                , TRIM(value:c7::STRING) as "PLZ_RAW"
                , TRIM(value:c8::STRING) as "ORT_RAW"
                , TRIM(value:c9::STRING) as "LAND_RAW"
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.DWH_01_EXT.EXT_WEBSHOP_WOHNORT
)
SELECT 
		  TRY_TO_TIMESTAMP("LDTS_SOURCE_RAW", 'YYYYMMDD_HH24MISS') as "LDTS_SOURCE"
                , "RSRC_SOURCE_RAW" as "RSRC_SOURCE" 
		, TRY_TO_DATE("EDTS_IN_RAW", 'YYYYMMDD') as "EDTS_IN"
                , "RAW_DATA_RAW" as "RAW_DATA"
                , TRY_TO_NUMBER("ROW_NUMBER_RAW") as "ROW_NUMBER" 
		, "KUNDEID_RAW" as "KUNDEID"
                , TRY_TO_DATE("VON_RAW", 'DD.MM.YYYY') as "VON"
                , TRY_TO_DATE("BIS_RAW", 'DD.MM.YYYY') as "BIS"
                , "STRASSE_RAW" as "STRASSE"
                , "HAUSNUMMER_RAW" as "HAUSNUMMER"
                , "ADRESSZUSATZ_RAW" as "ADRESSZUSATZ"
                , "PLZ_RAW" as "PLZ"
                , "ORT_RAW" as "ORT"
                , "LAND_RAW" as "LAND" 
		, TRY_TO_TIMESTAMP("LDTS_SOURCE_RAW", 'YYYYMMDD_HH24MISS') IS NOT NULL OR "LDTS_SOURCE_RAW" IS NULL as "IS_LDTS_SOURCE_TYPE_OK" 
		, TRY_TO_DATE("EDTS_IN_RAW", 'YYYYMMDD') IS NOT NULL OR "EDTS_IN_RAW" IS NULL as "IS_EDTS_IN_TYPE_OK"
                , TRY_TO_NUMBER("ROW_NUMBER_RAW") IS NOT NULL OR "ROW_NUMBER_RAW" IS NULL as "IS_ROW_NUMBER_TYPE_OK" 
		, TRY_TO_DATE("VON_RAW", 'DD.MM.YYYY') IS NOT NULL OR "VON_RAW" IS NULL as "IS_VON_TYPE_OK"
                , TRY_TO_DATE("BIS_RAW", 'DD.MM.YYYY') IS NOT NULL OR "BIS_RAW" IS NULL as "IS_BIS_TYPE_OK" 
		, ROW_NUMBER() OVER (PARTITION BY ldts_source,kundeid,von ORDER BY ldts_source,kundeid,von) = 1 AS "IS_DUB_CHECK_OK" 
		, COALESCE("KUNDEID_RAW", '') <> '' as "IS_KUNDEID_KEY_CHECK_OK"
                , COALESCE("VON_RAW", '') <> '' as "IS_VON_KEY_CHECK_OK"
		 
		, "IS_LDTS_SOURCE_TYPE_OK" AND "IS_EDTS_IN_TYPE_OK" AND "IS_ROW_NUMBER_TYPE_OK" AND "IS_VON_TYPE_OK" AND "IS_BIS_TYPE_OK" AND "IS_DUB_CHECK_OK" AND "IS_KUNDEID_KEY_CHECK_OK" AND "IS_VON_KEY_CHECK_OK" is_check_ok
		 
		,  TO_VARIANT(ARRAY_EXCEPT([REPLACE(IFF(NOT "IS_LDTS_SOURCE_TYPE_OK",'{"ldts_source":"' || COALESCE(TO_VARCHAR("LDTS_SOURCE_RAW") ,'') || '"}','') || IFF(NOT "IS_EDTS_IN_TYPE_OK",'{"edts_in":"' || COALESCE(TO_VARCHAR("EDTS_IN_RAW") ,'') || '"}','') || IFF(NOT "IS_ROW_NUMBER_TYPE_OK",'{"row_number":"' || COALESCE(TO_VARCHAR("ROW_NUMBER_RAW") ,'') || '"}','') || IFF(NOT "IS_VON_TYPE_OK",'{"von":"' || COALESCE(TO_VARCHAR("VON_RAW") ,'') || '"}','') || IFF(NOT "IS_BIS_TYPE_OK",'{"bis":"' || COALESCE(TO_VARCHAR("BIS_RAW") ,'') || '"}','') || IFF(NOT is_dub_check_ok, '{"dub_check": "ldts_source,kundeid,von"}','') || IFF(NOT is_kundeid_key_check_ok, '{"key_check": "kundeid"}','') || IFF(NOT is_von_key_check_ok, '{"key_check": "von"}',''), '}{','},{')],[''])) chk_all_msg
		FROM raw_data 


CROSS JOIN hwm_max 
WHERE ldts_source > hwm_max.hwm_max_ts
