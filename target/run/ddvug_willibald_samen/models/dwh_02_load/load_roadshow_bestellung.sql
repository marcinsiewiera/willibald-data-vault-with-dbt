
  
    

        create or replace  table WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_roadshow_bestellung
         as
        (with 
hwm as
    (
        select max(hwm_ldts) hwm_max_ts from WILLIBALD_DATA_VAULT_WITH_DBT.DWH_00_META.META_HWM where object_name = 'WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_roadshow_bestellung'
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
                , REPLACE(TRIM(value:c10::STRING) , ',', '.') as "PREIS_RAW"
                , REPLACE(TRIM(value:c11::STRING) , ',', '.') as "RABATT_RAW"
                , TRIM(value:c2::STRING) as "KUNDEID_RAW"
                , TRIM(value:c3::STRING) as "VEREINSPARTNERID_RAW"
                , TRIM(value:c4::STRING) as "KAUFDATUM_RAW"
                , TRIM(value:c5::STRING) as "KREDITKARTE_RAW"
                , TRIM(value:c6::STRING) as "GUELTIGBIS_RAW"
                , TRIM(value:c7::STRING) as "KKFIRMA_RAW"
                , TRIM(value:c8::STRING) as "PRODUKTID_RAW"
                , REPLACE(TRIM(value:c9::STRING) , ',', '') as "MENGE_RAW"
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.DWH_01_EXT.EXT_ROADSHOW_BESTELLUNG
)
SELECT 
		  TRY_TO_TIMESTAMP("LDTS_SOURCE_RAW", 'YYYYMMDD_HH24MISS') as "LDTS_SOURCE"
                , "RSRC_SOURCE_RAW" as "RSRC_SOURCE" 
		, TRY_TO_DATE("EDTS_IN_RAW", 'YYYYMMDD') as "EDTS_IN"
                , "RAW_DATA_RAW" as "RAW_DATA"
                , TRY_TO_NUMBER("ROW_NUMBER_RAW") as "ROW_NUMBER" 
		, "BESTELLUNGID_RAW" as "BESTELLUNGID"
                , TRY_TO_NUMBER("PREIS_RAW", 20,8) as "PREIS"
                , TRY_TO_NUMBER("RABATT_RAW", 20,8) as "RABATT"
                , "KUNDEID_RAW" as "KUNDEID"
                , "VEREINSPARTNERID_RAW" as "VEREINSPARTNERID"
                , TRY_TO_DATE("KAUFDATUM_RAW", 'DD.MM.YYYY') as "KAUFDATUM"
                , "KREDITKARTE_RAW" as "KREDITKARTE"
                , "GUELTIGBIS_RAW" as "GUELTIGBIS"
                , "KKFIRMA_RAW" as "KKFIRMA"
                , "PRODUKTID_RAW" as "PRODUKTID"
                , TRY_TO_NUMBER("MENGE_RAW") as "MENGE" 
		, TRY_TO_TIMESTAMP("LDTS_SOURCE_RAW", 'YYYYMMDD_HH24MISS') IS NOT NULL OR "LDTS_SOURCE_RAW" IS NULL as "IS_LDTS_SOURCE_TYPE_OK" 
		, TRY_TO_DATE("EDTS_IN_RAW", 'YYYYMMDD') IS NOT NULL OR "EDTS_IN_RAW" IS NULL as "IS_EDTS_IN_TYPE_OK"
                , TRY_TO_NUMBER("ROW_NUMBER_RAW") IS NOT NULL OR "ROW_NUMBER_RAW" IS NULL as "IS_ROW_NUMBER_TYPE_OK" 
		, TRY_TO_NUMBER("PREIS_RAW", 20,8) IS NOT NULL OR "PREIS_RAW" IS NULL as "IS_PREIS_TYPE_OK"
                , TRY_TO_NUMBER("RABATT_RAW", 20,8) IS NOT NULL OR "RABATT_RAW" IS NULL as "IS_RABATT_TYPE_OK"
                , TRY_TO_DATE("KAUFDATUM_RAW", 'DD.MM.YYYY') IS NOT NULL OR "KAUFDATUM_RAW" IS NULL as "IS_KAUFDATUM_TYPE_OK"
                , TRY_TO_NUMBER("MENGE_RAW") IS NOT NULL OR "MENGE_RAW" IS NULL as "IS_MENGE_TYPE_OK" 
		, ROW_NUMBER() OVER (PARTITION BY ldts_source,bestellungid,produktid ORDER BY ldts_source,bestellungid,produktid) = 1 AS "IS_DUB_CHECK_OK" 
		, COALESCE("BESTELLUNGID_RAW", '') <> '' as "IS_BESTELLUNGID_KEY_CHECK_OK"
                , COALESCE("PRODUKTID_RAW", '') <> '' as "IS_PRODUKTID_KEY_CHECK_OK"
		 
		, "IS_LDTS_SOURCE_TYPE_OK" AND "IS_EDTS_IN_TYPE_OK" AND "IS_ROW_NUMBER_TYPE_OK" AND "IS_PREIS_TYPE_OK" AND "IS_RABATT_TYPE_OK" AND "IS_KAUFDATUM_TYPE_OK" AND "IS_MENGE_TYPE_OK" AND "IS_DUB_CHECK_OK" AND "IS_BESTELLUNGID_KEY_CHECK_OK" AND "IS_PRODUKTID_KEY_CHECK_OK" is_check_ok
		 
		,  TO_VARIANT(ARRAY_EXCEPT([REPLACE(IFF(NOT "IS_LDTS_SOURCE_TYPE_OK",'{"ldts_source":"' || COALESCE(TO_VARCHAR("LDTS_SOURCE_RAW") ,'') || '"}','') || IFF(NOT "IS_EDTS_IN_TYPE_OK",'{"edts_in":"' || COALESCE(TO_VARCHAR("EDTS_IN_RAW") ,'') || '"}','') || IFF(NOT "IS_ROW_NUMBER_TYPE_OK",'{"row_number":"' || COALESCE(TO_VARCHAR("ROW_NUMBER_RAW") ,'') || '"}','') || IFF(NOT "IS_PREIS_TYPE_OK",'{"preis":"' || COALESCE(TO_VARCHAR("PREIS_RAW") ,'') || '"}','') || IFF(NOT "IS_RABATT_TYPE_OK",'{"rabatt":"' || COALESCE(TO_VARCHAR("RABATT_RAW") ,'') || '"}','') || IFF(NOT "IS_KAUFDATUM_TYPE_OK",'{"kaufdatum":"' || COALESCE(TO_VARCHAR("KAUFDATUM_RAW") ,'') || '"}','') || IFF(NOT "IS_MENGE_TYPE_OK",'{"menge":"' || COALESCE(TO_VARCHAR("MENGE_RAW") ,'') || '"}','') || IFF(NOT is_dub_check_ok, '{"dub_check": "ldts_source,bestellungid,produktid"}','') || IFF(NOT is_bestellungid_key_check_ok, '{"key_check": "bestellungid"}','') || IFF(NOT is_produktid_key_check_ok, '{"key_check": "produktid"}',''), '}{','},{')],[''])) chk_all_msg
		FROM raw_data 


CROSS JOIN hwm_max 
WHERE ldts_source > hwm_max.hwm_max_ts

        );
      
  