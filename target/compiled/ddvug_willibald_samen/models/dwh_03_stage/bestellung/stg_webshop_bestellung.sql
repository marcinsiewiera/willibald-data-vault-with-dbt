













WITH


source_data AS (
    SELECT

    
        "LDTS_SOURCE",
        "RSRC_SOURCE",
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "BESTELLUNGID",
        "KUNDEID",
        "ALLGLIEFERADRID",
        "BESTELLDATUM",
        "WUNSCHDATUM",
        "RABATT",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_ALLGLIEFERADRID_TYPE_OK",
        "IS_BESTELLDATUM_TYPE_OK",
        "IS_WUNSCHDATUM_TYPE_OK",
        "IS_RABATT_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG"

  FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_bestellung

  ),





ldts_rsrc_data AS (

  SELECT
    "LDTS_SOURCE" AS ldts,
    CAST( "RSRC_SOURCE" as STRING ) AS rsrc,
      
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "BESTELLUNGID",
        "KUNDEID",
        "ALLGLIEFERADRID",
        "BESTELLDATUM",
        "WUNSCHDATUM",
        "RABATT",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_ALLGLIEFERADRID_TYPE_OK",
        "IS_BESTELLDATUM_TYPE_OK",
        "IS_WUNSCHDATUM_TYPE_OK",
        "IS_RABATT_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
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
        "BESTELLUNGID",
        "KUNDEID",
        "ALLGLIEFERADRID",
        "BESTELLDATUM",
        "WUNSCHDATUM",
        "RABATT",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_ALLGLIEFERADRID_TYPE_OK",
        "IS_BESTELLDATUM_TYPE_OK",
        "IS_WUNSCHDATUM_TYPE_OK",
        "IS_RABATT_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
  
  "KUNDEID" AS "CUSTOMER_BK",
    "BESTELLUNGID" AS "ORDER_BK",
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
        "BESTELLUNGID",
        "KUNDEID",
        "ALLGLIEFERADRID",
        "BESTELLDATUM",
        "WUNSCHDATUM",
        "RABATT",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_ALLGLIEFERADRID_TYPE_OK",
        "IS_BESTELLDATUM_TYPE_OK",
        "IS_WUNSCHDATUM_TYPE_OK",
        "IS_RABATT_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "CUSTOMER_BK",
        "ORDER_BK",
        "CDTS",
        "EDTS",
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("KUNDEID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^'))), '00000000000000000000000000000000') AS HK_CUSTOMER_H,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("BESTELLUNGID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^'))), '00000000000000000000000000000000') AS HK_ORDER_H,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("ORDER_BK" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("CUSTOMER_BK" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^'))), '00000000000000000000000000000000') AS HK_ORDER_CUSTOMER_L,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(UPPER(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("ALLGLIEFERADRID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("BESTELLDATUM" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("RABATT" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("WUNSCHDATUM" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        )), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^||^^||^^'))), '00000000000000000000000000000000') AS HD_ORDER_WS_S

    FROM derived_columns
  
),

unknown_values AS (
  
    SELECT

    TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') as ldts,
    'SYSTEM' as rsrc,
    
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "EDTS_IN",
        '(unknown)' AS RAW_DATA,
        0 AS ROW_NUMBER,
        '(unknown)' AS BESTELLUNGID,
        '(unknown)' AS KUNDEID,
        0 AS ALLGLIEFERADRID,
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "BESTELLDATUM",
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "WUNSCHDATUM",
        0 AS RABATT,
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_ALLGLIEFERADRID_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_BESTELLDATUM_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_WUNSCHDATUM_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_RABATT_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_BESTELLUNGID_KEY_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK,
        NULL AS CHK_ALL_MSG
     ,
    
        TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        '(unknown)' AS CUSTOMER_BK,
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "EDTS",
        '(unknown)' AS ORDER_BK,
        CAST('00000000000000000000000000000000' as STRING) as HK_CUSTOMER_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_ORDER_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_ORDER_CUSTOMER_L,
        CAST('00000000000000000000000000000000' as STRING) as HD_ORDER_WS_S
),


error_values AS (

    SELECT

    TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS') as ldts,
    'ERROR' as rsrc,
    
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "EDTS_IN",
        '(error)' AS RAW_DATA,
        -1 AS ROW_NUMBER
     ,
        '(error)' AS BESTELLUNGID,
        '(error)' AS KUNDEID,
        -1 AS ALLGLIEFERADRID
     ,
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "BESTELLDATUM",
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "WUNSCHDATUM",
        -1 AS RABATT
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_ALLGLIEFERADRID_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_BESTELLDATUM_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_WUNSCHDATUM_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_RABATT_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_BESTELLUNGID_KEY_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK
     ,
        NULL AS CHK_ALL_MSG
      ,
    
        TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        '(error)' AS CUSTOMER_BK,
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "EDTS",
        '(error)' AS ORDER_BK,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_CUSTOMER_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_ORDER_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_ORDER_CUSTOMER_L,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HD_ORDER_WS_S
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
        "BESTELLUNGID",
        "KUNDEID",
        "ALLGLIEFERADRID",
        "BESTELLDATUM",
        "WUNSCHDATUM",
        "RABATT",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_ALLGLIEFERADRID_TYPE_OK",
        "IS_BESTELLDATUM_TYPE_OK",
        "IS_WUNSCHDATUM_TYPE_OK",
        "IS_RABATT_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "CUSTOMER_BK",
        "ORDER_BK",
        "CDTS",
        "EDTS",
        "HK_CUSTOMER_H",
        "HK_ORDER_H",
        "HK_ORDER_CUSTOMER_L",
        "HD_ORDER_WS_S"

    FROM hashed_columns

  
    UNION ALL
    
    SELECT

    
        "LDTS",
        "RSRC",
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "BESTELLUNGID",
        "KUNDEID",
        "ALLGLIEFERADRID",
        "BESTELLDATUM",
        "WUNSCHDATUM",
        "RABATT",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_ALLGLIEFERADRID_TYPE_OK",
        "IS_BESTELLDATUM_TYPE_OK",
        "IS_WUNSCHDATUM_TYPE_OK",
        "IS_RABATT_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "CUSTOMER_BK",
        "ORDER_BK",
        "CDTS",
        "EDTS",
        "HK_CUSTOMER_H",
        "HK_ORDER_H",
        "HK_ORDER_CUSTOMER_L",
        "HD_ORDER_WS_S"

    FROM ghost_records
  
)

SELECT * FROM columns_to_select
where is_check_ok or rsrc ='SYSTEM'