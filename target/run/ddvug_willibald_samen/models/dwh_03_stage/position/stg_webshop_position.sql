
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_webshop_position
  
    
    
(
  
    "LDTS" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "EDTS_IN" COMMENT $$$$, 
  
    "RAW_DATA" COMMENT $$$$, 
  
    "ROW_NUMBER" COMMENT $$$$, 
  
    "BESTELLUNGID" COMMENT $$$$, 
  
    "POSID" COMMENT $$$$, 
  
    "PRODUKTID" COMMENT $$$$, 
  
    "SPEZLIEFERADRID" COMMENT $$$$, 
  
    "MENGE" COMMENT $$$$, 
  
    "PREIS" COMMENT $$$$, 
  
    "IS_LDTS_SOURCE_TYPE_OK" COMMENT $$$$, 
  
    "IS_EDTS_IN_TYPE_OK" COMMENT $$$$, 
  
    "IS_ROW_NUMBER_TYPE_OK" COMMENT $$$$, 
  
    "IS_SPEZLIEFERADRID_TYPE_OK" COMMENT $$$$, 
  
    "IS_MENGE_TYPE_OK" COMMENT $$$$, 
  
    "IS_DUB_CHECK_OK" COMMENT $$$$, 
  
    "IS_BESTELLUNGID_KEY_CHECK_OK" COMMENT $$$$, 
  
    "IS_POSID_KEY_CHECK_OK" COMMENT $$$$, 
  
    "IS_CHECK_OK" COMMENT $$$$, 
  
    "CHK_ALL_MSG" COMMENT $$$$, 
  
    "ORDER_BK" COMMENT $$$$, 
  
    "POSITION_BK" COMMENT $$$$, 
  
    "PRODUCT_BK" COMMENT $$$$, 
  
    "CDTS" COMMENT $$$$, 
  
    "EDTS" COMMENT $$$$, 
  
    "HK_ORDER_H" COMMENT $$$$, 
  
    "HK_POSITION_H" COMMENT $$$$, 
  
    "HK_PRODUCT_H" COMMENT $$$$, 
  
    "HK_ORDER_POSITION_L" COMMENT $$$$, 
  
    "HK_POSITION_PRODUCT_L" COMMENT $$$$, 
  
    "HD_POSITION_WS_S" COMMENT $$$$
  
)

   as (
    













WITH


source_data AS (
    SELECT

    
        "LDTS_SOURCE",
        "RSRC_SOURCE",
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "BESTELLUNGID",
        "POSID",
        "PRODUKTID",
        "SPEZLIEFERADRID",
        "MENGE",
        "PREIS",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_SPEZLIEFERADRID_TYPE_OK",
        "IS_MENGE_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_POSID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG"

  FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_position

  ),





ldts_rsrc_data AS (

  SELECT
    "LDTS_SOURCE" AS ldts,
    CAST( "RSRC_SOURCE" as STRING ) AS rsrc,
      
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "BESTELLUNGID",
        "POSID",
        "PRODUKTID",
        "SPEZLIEFERADRID",
        "MENGE",
        "PREIS",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_SPEZLIEFERADRID_TYPE_OK",
        "IS_MENGE_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_POSID_KEY_CHECK_OK",
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
        "POSID",
        "PRODUKTID",
        "SPEZLIEFERADRID",
        "MENGE",
        "PREIS",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_SPEZLIEFERADRID_TYPE_OK",
        "IS_MENGE_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_POSID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
  
  "BESTELLUNGID" AS "ORDER_BK",
    BESTELLUNGID||'_'||POSID AS "POSITION_BK",
    "PRODUKTID" AS "PRODUCT_BK",
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
        "POSID",
        "PRODUKTID",
        "SPEZLIEFERADRID",
        "MENGE",
        "PREIS",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_SPEZLIEFERADRID_TYPE_OK",
        "IS_MENGE_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_POSID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "ORDER_BK",
        "POSITION_BK",
        "PRODUCT_BK",
        "CDTS",
        "EDTS",
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("BESTELLUNGID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^'))), '00000000000000000000000000000000') AS HK_ORDER_H,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("BESTELLUNGID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("POSID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^'))), '00000000000000000000000000000000') AS HK_POSITION_H,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("PRODUKTID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^'))), '00000000000000000000000000000000') AS HK_PRODUCT_H,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("POSITION_BK" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("ORDER_BK" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^'))), '00000000000000000000000000000000') AS HK_ORDER_POSITION_L,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("PRODUCT_BK" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("POSITION_BK" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^'))), '00000000000000000000000000000000') AS HK_POSITION_PRODUCT_L,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(UPPER(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("BESTELLUNGID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("MENGE" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("POSID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("PREIS" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("SPEZLIEFERADRID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        )), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^||^^||^^||^^'))), '00000000000000000000000000000000') AS HD_POSITION_WS_S

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
        '(unknown)' AS POSID,
        '(unknown)' AS PRODUKTID,
        0 AS SPEZLIEFERADRID,
        0 AS MENGE,
        '(unknown)' AS PREIS,
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_SPEZLIEFERADRID_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_MENGE_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_BESTELLUNGID_KEY_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_POSID_KEY_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK,
        NULL AS CHK_ALL_MSG
     ,
    
        TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "EDTS",
        '(unknown)' AS ORDER_BK,
        '(unknown)' AS POSITION_BK,
        '(unknown)' AS PRODUCT_BK,
        CAST('00000000000000000000000000000000' as STRING) as HK_ORDER_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_POSITION_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_PRODUCT_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_ORDER_POSITION_L,
        CAST('00000000000000000000000000000000' as STRING) as HK_POSITION_PRODUCT_L,
        CAST('00000000000000000000000000000000' as STRING) as HD_POSITION_WS_S
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
        '(error)' AS POSID,
        '(error)' AS PRODUKTID,
        -1 AS SPEZLIEFERADRID
     ,
        -1 AS MENGE
     ,
        '(error)' AS PREIS,
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_SPEZLIEFERADRID_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_MENGE_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_BESTELLUNGID_KEY_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_POSID_KEY_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK
     ,
        NULL AS CHK_ALL_MSG
      ,
    
        TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "EDTS",
        '(error)' AS ORDER_BK,
        '(error)' AS POSITION_BK,
        '(error)' AS PRODUCT_BK,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_ORDER_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_POSITION_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_PRODUCT_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_ORDER_POSITION_L,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_POSITION_PRODUCT_L,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HD_POSITION_WS_S
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
        "POSID",
        "PRODUKTID",
        "SPEZLIEFERADRID",
        "MENGE",
        "PREIS",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_SPEZLIEFERADRID_TYPE_OK",
        "IS_MENGE_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_POSID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "ORDER_BK",
        "POSITION_BK",
        "PRODUCT_BK",
        "CDTS",
        "EDTS",
        "HK_ORDER_H",
        "HK_POSITION_H",
        "HK_PRODUCT_H",
        "HK_ORDER_POSITION_L",
        "HK_POSITION_PRODUCT_L",
        "HD_POSITION_WS_S"

    FROM hashed_columns

  
    UNION ALL
    
    SELECT

    
        "LDTS",
        "RSRC",
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "BESTELLUNGID",
        "POSID",
        "PRODUKTID",
        "SPEZLIEFERADRID",
        "MENGE",
        "PREIS",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_SPEZLIEFERADRID_TYPE_OK",
        "IS_MENGE_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_POSID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "ORDER_BK",
        "POSITION_BK",
        "PRODUCT_BK",
        "CDTS",
        "EDTS",
        "HK_ORDER_H",
        "HK_POSITION_H",
        "HK_PRODUCT_H",
        "HK_ORDER_POSITION_L",
        "HK_POSITION_PRODUCT_L",
        "HD_POSITION_WS_S"

    FROM ghost_records
  
)

SELECT * FROM columns_to_select
where is_check_ok or rsrc ='SYSTEM'
  );

