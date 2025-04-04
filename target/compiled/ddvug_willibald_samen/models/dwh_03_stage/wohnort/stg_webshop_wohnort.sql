













WITH


source_data AS (
    SELECT

    
        "LDTS_SOURCE",
        "RSRC_SOURCE",
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "KUNDEID",
        "VON",
        "BIS",
        "STRASSE",
        "HAUSNUMMER",
        "ADRESSZUSATZ",
        "PLZ",
        "ORT",
        "LAND",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_VON_TYPE_OK",
        "IS_BIS_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_KUNDEID_KEY_CHECK_OK",
        "IS_VON_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG"

  FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_wohnort

  ),





ldts_rsrc_data AS (

  SELECT
    "LDTS_SOURCE" AS ldts,
    CAST( "RSRC_SOURCE" as STRING ) AS rsrc,
      
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "KUNDEID",
        "VON",
        "BIS",
        "STRASSE",
        "HAUSNUMMER",
        "ADRESSZUSATZ",
        "PLZ",
        "ORT",
        "LAND",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_VON_TYPE_OK",
        "IS_BIS_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_KUNDEID_KEY_CHECK_OK",
        "IS_VON_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG"
    

  FROM source_data
  

),

derived_columns AS (SELECT
  
        "LDTS",
        "RSRC",
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "KUNDEID",
        "VON",
        "BIS",
        "STRASSE",
        "HAUSNUMMER",
        "ADRESSZUSATZ",
        "PLZ",
        "ORT",
        "LAND",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_VON_TYPE_OK",
        "IS_BIS_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_KUNDEID_KEY_CHECK_OK",
        "IS_VON_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
  
  "KUNDEID" AS "CUSTOMER_BK",
    TO_TIMESTAMP(DATEADD(HOUR, 1, SYSDATE())) AS "CDTS",
    "EDTS_IN" AS "EDTS"

  FROM ldts_rsrc_data
),



hashed_columns AS (

    SELECT

    
        "LDTS",
        "RSRC",
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "KUNDEID",
        "VON",
        "BIS",
        "STRASSE",
        "HAUSNUMMER",
        "ADRESSZUSATZ",
        "PLZ",
        "ORT",
        "LAND",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_VON_TYPE_OK",
        "IS_BIS_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_KUNDEID_KEY_CHECK_OK",
        "IS_VON_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "CUSTOMER_BK",
        "CDTS",
        "EDTS",

    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("KUNDEID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^'))), '00000000000000000000000000000000') AS HK_CUSTOMER_H, 
    IFNULL(LOWER(MD5(LISTAGG(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(UPPER(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("ADRESSZUSATZ" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("BIS" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("HAUSNUMMER" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("LAND" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("ORT" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("PLZ" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("STRASSE" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        )), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^||^^||^^||^^||^^||^^')) WITHIN GROUP (ORDER BY VON) OVER (PARTITION BY HK_CUSTOMER_H, ldts))), '00000000000000000000000000000000') AS HD_CUSTOMER_WS_LA_MS

    FROM derived_columns

),



unknown_values AS (
  
    SELECT

    TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') as ldts,
    'SYSTEM' as rsrc,
    
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "EDTS_IN",
        '(unknown)' AS RAW_DATA,
        0 AS ROW_NUMBER,
        '(unknown)' AS KUNDEID,
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "VON",
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "BIS",
        '(unknown)' AS STRASSE,
        '(unknown)' AS HAUSNUMMER,
        '(unknown)' AS ADRESSZUSATZ,
        '(unknown)' AS PLZ,
        '(unknown)' AS ORT,
        '(unknown)' AS LAND,
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_VON_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_BIS_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_KUNDEID_KEY_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_VON_KEY_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK,
        NULL AS CHK_ALL_MSG
     ,
    
        TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        '(unknown)' AS CUSTOMER_BK,
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "EDTS",
        CAST('00000000000000000000000000000000' as STRING) as HK_CUSTOMER_H,
        CAST('00000000000000000000000000000000' as STRING) as HD_CUSTOMER_WS_LA_MS
),


error_values AS (

    SELECT

    TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS') as ldts,
    'ERROR' as rsrc,
    
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "EDTS_IN",
        '(error)' AS RAW_DATA,
        -1 AS ROW_NUMBER
     ,
        '(error)' AS KUNDEID,
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "VON",
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "BIS",
        '(error)' AS STRASSE,
        '(error)' AS HAUSNUMMER,
        '(error)' AS ADRESSZUSATZ,
        '(error)' AS PLZ,
        '(error)' AS ORT,
        '(error)' AS LAND,
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_VON_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_BIS_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_KUNDEID_KEY_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_VON_KEY_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK
     ,
        NULL AS CHK_ALL_MSG
      ,
    
        TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        '(error)' AS CUSTOMER_BK,
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "EDTS",
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_CUSTOMER_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HD_CUSTOMER_WS_LA_MS
),


ghost_records AS (
    SELECT * FROM unknown_values
    UNION ALL
    SELECT * FROM error_values
),
columns_to_select AS (

    SELECT

    
        "LDTS",
        "RSRC",
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "KUNDEID",
        "VON",
        "BIS",
        "STRASSE",
        "HAUSNUMMER",
        "ADRESSZUSATZ",
        "PLZ",
        "ORT",
        "LAND",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_VON_TYPE_OK",
        "IS_BIS_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_KUNDEID_KEY_CHECK_OK",
        "IS_VON_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "CUSTOMER_BK",
        "CDTS",
        "EDTS",
        "HK_CUSTOMER_H",
        "HD_CUSTOMER_WS_LA_MS"

    FROM hashed_columns

  
    UNION ALL
    
    SELECT

    
        "LDTS",
        "RSRC",
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "KUNDEID",
        "VON",
        "BIS",
        "STRASSE",
        "HAUSNUMMER",
        "ADRESSZUSATZ",
        "PLZ",
        "ORT",
        "LAND",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_VON_TYPE_OK",
        "IS_BIS_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_KUNDEID_KEY_CHECK_OK",
        "IS_VON_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "CUSTOMER_BK",
        "CDTS",
        "EDTS",
        "HK_CUSTOMER_H",
        "HD_CUSTOMER_WS_LA_MS"

    FROM ghost_records
  
)

SELECT * FROM columns_to_select
where is_check_ok or rsrc ='SYSTEM'