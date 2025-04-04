
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_webshop_lieferung
  
    
    
(
  
    "LDTS" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "EDTS_IN" COMMENT $$$$, 
  
    "RAW_DATA" COMMENT $$$$, 
  
    "ROW_NUMBER" COMMENT $$$$, 
  
    "BESTELLUNGID" COMMENT $$$$, 
  
    "POSID" COMMENT $$$$, 
  
    "LIEFERADRID" COMMENT $$$$, 
  
    "LIEFERDIENSTID" COMMENT $$$$, 
  
    "LIEFERDATUM" COMMENT $$$$, 
  
    "IS_LDTS_SOURCE_TYPE_OK" COMMENT $$$$, 
  
    "IS_EDTS_IN_TYPE_OK" COMMENT $$$$, 
  
    "IS_ROW_NUMBER_TYPE_OK" COMMENT $$$$, 
  
    "IS_LIEFERDATUM_TYPE_OK" COMMENT $$$$, 
  
    "IS_DUB_CHECK_OK" COMMENT $$$$, 
  
    "IS_BESTELLUNGID_KEY_CHECK_OK" COMMENT $$$$, 
  
    "IS_POSID_KEY_CHECK_OK" COMMENT $$$$, 
  
    "IS_CHECK_OK" COMMENT $$$$, 
  
    "CHK_ALL_MSG" COMMENT $$$$, 
  
    "DELIVERYADRESS_BK" COMMENT $$$$, 
  
    "DELIVERYSERVICE_BK" COMMENT $$$$, 
  
    "ORDER_BK" COMMENT $$$$, 
  
    "POSITION_BK" COMMENT $$$$, 
  
    "CDTS" COMMENT $$$$, 
  
    "EDTS" COMMENT $$$$, 
  
    "HK_DELIVERYADRESS_H" COMMENT $$$$, 
  
    "HK_DELIVERYSERVICE_H" COMMENT $$$$, 
  
    "HK_ORDER_H" COMMENT $$$$, 
  
    "HK_POSITION_H" COMMENT $$$$, 
  
    "HK_ORDER_POSITION_L" COMMENT $$$$, 
  
    "HK_DELIVERY_L" COMMENT $$$$, 
  
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
        "LIEFERADRID",
        "LIEFERDIENSTID",
        "LIEFERDATUM",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_LIEFERDATUM_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_POSID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG"

  FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_lieferung

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
        "LIEFERADRID",
        "LIEFERDIENSTID",
        "LIEFERDATUM",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_LIEFERDATUM_TYPE_OK",
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
        "LIEFERADRID",
        "LIEFERDIENSTID",
        "LIEFERDATUM",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_LIEFERDATUM_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_POSID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
  
  "LIEFERADRID" AS "DELIVERYADRESS_BK",
    "LIEFERDIENSTID" AS "DELIVERYSERVICE_BK",
    "BESTELLUNGID" AS "ORDER_BK",
    BESTELLUNGID||'_'||POSID AS "POSITION_BK",
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
        "LIEFERADRID",
        "LIEFERDIENSTID",
        "LIEFERDATUM",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_LIEFERDATUM_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_POSID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "DELIVERYADRESS_BK",
        "DELIVERYSERVICE_BK",
        "ORDER_BK",
        "POSITION_BK",
        "CDTS",
        "EDTS",
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("LIEFERADRID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^'))), '00000000000000000000000000000000') AS HK_DELIVERYADRESS_H,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("LIEFERDIENSTID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^'))), '00000000000000000000000000000000') AS HK_DELIVERYSERVICE_H,
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
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("POSITION_BK" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("ORDER_BK" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^'))), '00000000000000000000000000000000') AS HK_ORDER_POSITION_L,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("LIEFERADRID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("LIEFERDIENSTID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("BESTELLUNGID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("BESTELLUNGID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("POSID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^||^^||^^||^^'))), '00000000000000000000000000000000') AS HK_DELIVERY_L,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(UPPER(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("BESTELLUNGID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("POSID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        )), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^'))), '00000000000000000000000000000000') AS HD_POSITION_WS_S

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
        '(unknown)' AS LIEFERADRID,
        '(unknown)' AS LIEFERDIENSTID,
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "LIEFERDATUM",
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_LIEFERDATUM_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_BESTELLUNGID_KEY_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_POSID_KEY_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK,
        NULL AS CHK_ALL_MSG
     ,
    
        TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        '(unknown)' AS DELIVERYADRESS_BK,
        '(unknown)' AS DELIVERYSERVICE_BK,
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "EDTS",
        '(unknown)' AS ORDER_BK,
        '(unknown)' AS POSITION_BK,
        CAST('00000000000000000000000000000000' as STRING) as HK_DELIVERYADRESS_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_DELIVERYSERVICE_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_ORDER_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_POSITION_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_ORDER_POSITION_L,
        CAST('00000000000000000000000000000000' as STRING) as HK_DELIVERY_L,
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
        '(error)' AS LIEFERADRID,
        '(error)' AS LIEFERDIENSTID,
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "LIEFERDATUM",
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_LIEFERDATUM_TYPE_OK
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
        '(error)' AS DELIVERYADRESS_BK,
        '(error)' AS DELIVERYSERVICE_BK,
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "EDTS",
        '(error)' AS ORDER_BK,
        '(error)' AS POSITION_BK,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_DELIVERYADRESS_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_DELIVERYSERVICE_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_ORDER_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_POSITION_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_ORDER_POSITION_L,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_DELIVERY_L,
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
        "LIEFERADRID",
        "LIEFERDIENSTID",
        "LIEFERDATUM",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_LIEFERDATUM_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_POSID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "DELIVERYADRESS_BK",
        "DELIVERYSERVICE_BK",
        "ORDER_BK",
        "POSITION_BK",
        "CDTS",
        "EDTS",
        "HK_DELIVERYADRESS_H",
        "HK_DELIVERYSERVICE_H",
        "HK_ORDER_H",
        "HK_POSITION_H",
        "HK_ORDER_POSITION_L",
        "HK_DELIVERY_L",
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
        "LIEFERADRID",
        "LIEFERDIENSTID",
        "LIEFERDATUM",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_LIEFERDATUM_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_POSID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "DELIVERYADRESS_BK",
        "DELIVERYSERVICE_BK",
        "ORDER_BK",
        "POSITION_BK",
        "CDTS",
        "EDTS",
        "HK_DELIVERYADRESS_H",
        "HK_DELIVERYSERVICE_H",
        "HK_ORDER_H",
        "HK_POSITION_H",
        "HK_ORDER_POSITION_L",
        "HK_DELIVERY_L",
        "HD_POSITION_WS_S"

    FROM ghost_records
  
)

SELECT * FROM columns_to_select
where is_check_ok or rsrc ='SYSTEM'
  );

