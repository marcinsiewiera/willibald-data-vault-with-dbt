with 
hwm as
    (
        select max(hwm_ldts) hwm_max_ts from WILLIBALD_DATA_VAULT_WITH_DBT.DWH_00_META.META_HWM where object_name = 'WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_produkt'
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
		, TRIM(value:c1::STRING) as "PRODUKTID_RAW"
                , TRIM(value:c2::STRING) as "KATID_RAW"
                , TRIM(value:c3::STRING) as "BEZEICHNUNG_RAW"
                , TRIM(value:c4::STRING) as "UMFANG_RAW"
                , REPLACE(TRIM(value:c5::STRING) , ',', '') as "TYP_RAW"
                , REPLACE(TRIM(value:c6::STRING) , ',', '.') as "PREIS_RAW"
                , TRIM(value:c7::STRING) as "PFLANZORT_RAW"
                , TRIM(value:c8::STRING) as "PFLANZABSTAND_RAW"
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.DWH_01_EXT.EXT_WEBSHOP_PRODUKT
)
SELECT 
		  TRY_TO_TIMESTAMP("LDTS_SOURCE_RAW", 'YYYYMMDD_HH24MISS') as "LDTS_SOURCE"
                , "RSRC_SOURCE_RAW" as "RSRC_SOURCE" 
		, TRY_TO_DATE("EDTS_IN_RAW", 'YYYYMMDD') as "EDTS_IN"
                , "RAW_DATA_RAW" as "RAW_DATA"
                , TRY_TO_NUMBER("ROW_NUMBER_RAW") as "ROW_NUMBER" 
		, "PRODUKTID_RAW" as "PRODUKTID"
                , "KATID_RAW" as "KATID"
                , "BEZEICHNUNG_RAW" as "BEZEICHNUNG"
                , "UMFANG_RAW" as "UMFANG"
                , TRY_TO_NUMBER("TYP_RAW") as "TYP"
                , TRY_TO_NUMBER("PREIS_RAW", 28,10) as "PREIS"
                , "PFLANZORT_RAW" as "PFLANZORT"
                , "PFLANZABSTAND_RAW" as "PFLANZABSTAND" 
		, TRY_TO_TIMESTAMP("LDTS_SOURCE_RAW", 'YYYYMMDD_HH24MISS') IS NOT NULL OR "LDTS_SOURCE_RAW" IS NULL as "IS_LDTS_SOURCE_TYPE_OK" 
		, TRY_TO_DATE("EDTS_IN_RAW", 'YYYYMMDD') IS NOT NULL OR "EDTS_IN_RAW" IS NULL as "IS_EDTS_IN_TYPE_OK"
                , TRY_TO_NUMBER("ROW_NUMBER_RAW") IS NOT NULL OR "ROW_NUMBER_RAW" IS NULL as "IS_ROW_NUMBER_TYPE_OK" 
		, TRY_TO_NUMBER("TYP_RAW") IS NOT NULL OR "TYP_RAW" IS NULL as "IS_TYP_TYPE_OK"
                , TRY_TO_NUMBER("PREIS_RAW", 28,10) IS NOT NULL OR "PREIS_RAW" IS NULL as "IS_PREIS_TYPE_OK" 
		, ROW_NUMBER() OVER (PARTITION BY ldts_source,produktid ORDER BY ldts_source,produktid) = 1 AS "IS_DUB_CHECK_OK" 
		, COALESCE("PRODUKTID_RAW", '') <> '' as "IS_PRODUKTID_KEY_CHECK_OK"
		 
		, "IS_LDTS_SOURCE_TYPE_OK" AND "IS_EDTS_IN_TYPE_OK" AND "IS_ROW_NUMBER_TYPE_OK" AND "IS_TYP_TYPE_OK" AND "IS_PREIS_TYPE_OK" AND "IS_DUB_CHECK_OK" AND "IS_PRODUKTID_KEY_CHECK_OK" is_check_ok
		 
		,  TO_VARIANT(ARRAY_EXCEPT([REPLACE(IFF(NOT "IS_LDTS_SOURCE_TYPE_OK",'{"ldts_source":"' || COALESCE(TO_VARCHAR("LDTS_SOURCE_RAW") ,'') || '"}','') || IFF(NOT "IS_EDTS_IN_TYPE_OK",'{"edts_in":"' || COALESCE(TO_VARCHAR("EDTS_IN_RAW") ,'') || '"}','') || IFF(NOT "IS_ROW_NUMBER_TYPE_OK",'{"row_number":"' || COALESCE(TO_VARCHAR("ROW_NUMBER_RAW") ,'') || '"}','') || IFF(NOT "IS_TYP_TYPE_OK",'{"typ":"' || COALESCE(TO_VARCHAR("TYP_RAW") ,'') || '"}','') || IFF(NOT "IS_PREIS_TYPE_OK",'{"preis":"' || COALESCE(TO_VARCHAR("PREIS_RAW") ,'') || '"}','') || IFF(NOT is_dub_check_ok, '{"dub_check": "ldts_source,produktid"}','') || IFF(NOT is_produktid_key_check_ok, '{"key_check": "produktid"}',''), '}{','},{')],[''])) chk_all_msg
		FROM raw_data 


CROSS JOIN hwm_max 
WHERE ldts_source > hwm_max.hwm_max_ts
