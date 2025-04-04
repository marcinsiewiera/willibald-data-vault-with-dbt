
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_webshop_lieferdienst
  
    
    
(
  
    "LDTS" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "EDTS_IN" COMMENT $$$$, 
  
    "RAW_DATA" COMMENT $$$$, 
  
    "ROW_NUMBER" COMMENT $$$$, 
  
    "LIEFERDIENSTID" COMMENT $$$$, 
  
    "LAND" COMMENT $$$$, 
  
    "NAME" COMMENT $$$$, 
  
    "TELEFON" COMMENT $$$$, 
  
    "FAX" COMMENT $$$$, 
  
    "EMAIL" COMMENT $$$$, 
  
    "STRASSE" COMMENT $$$$, 
  
    "HAUSNUMMER" COMMENT $$$$, 
  
    "PLZ" COMMENT $$$$, 
  
    "ORT" COMMENT $$$$, 
  
    "IS_LDTS_SOURCE_TYPE_OK" COMMENT $$$$, 
  
    "IS_EDTS_IN_TYPE_OK" COMMENT $$$$, 
  
    "IS_ROW_NUMBER_TYPE_OK" COMMENT $$$$, 
  
    "IS_DUB_CHECK_OK" COMMENT $$$$, 
  
    "IS_LIEFERDIENSTID_KEY_CHECK_OK" COMMENT $$$$, 
  
    "IS_CHECK_OK" COMMENT $$$$, 
  
    "CHK_ALL_MSG" COMMENT $$$$, 
  
    "DELIVERYSERVICE_BK" COMMENT $$$$, 
  
    "CDTS" COMMENT $$$$, 
  
    "EDTS" COMMENT $$$$, 
  
    "HK_DELIVERYSERVICE_H" COMMENT $$$$, 
  
    "HD_DELIVERYSERVICE_WS_S" COMMENT $$$$
  
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
        "LIEFERDIENSTID",
        "LAND",
        "NAME",
        "TELEFON",
        "FAX",
        "EMAIL",
        "STRASSE",
        "HAUSNUMMER",
        "PLZ",
        "ORT",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_LIEFERDIENSTID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG"

  FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_lieferdienst

  ),





ldts_rsrc_data AS (

  SELECT
    "LDTS_SOURCE" AS ldts,
    CAST( "RSRC_SOURCE" as STRING ) AS rsrc,
      
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "LIEFERDIENSTID",
        "LAND",
        "NAME",
        "TELEFON",
        "FAX",
        "EMAIL",
        "STRASSE",
        "HAUSNUMMER",
        "PLZ",
        "ORT",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_LIEFERDIENSTID_KEY_CHECK_OK",
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
        "LIEFERDIENSTID",
        "LAND",
        "NAME",
        "TELEFON",
        "FAX",
        "EMAIL",
        "STRASSE",
        "HAUSNUMMER",
        "PLZ",
        "ORT",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_LIEFERDIENSTID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
  
  "LIEFERDIENSTID" AS "DELIVERYSERVICE_BK",
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
        "LIEFERDIENSTID",
        "LAND",
        "NAME",
        "TELEFON",
        "FAX",
        "EMAIL",
        "STRASSE",
        "HAUSNUMMER",
        "PLZ",
        "ORT",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_LIEFERDIENSTID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "DELIVERYSERVICE_BK",
        "CDTS",
        "EDTS",
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("LIEFERDIENSTID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^'))), '00000000000000000000000000000000') AS HK_DELIVERYSERVICE_H,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(UPPER(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("EMAIL" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("FAX" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("HAUSNUMMER" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("LAND" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("NAME" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("ORT" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("PLZ" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("STRASSE" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("TELEFON" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        )), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^||^^||^^||^^||^^||^^||^^||^^'))), '00000000000000000000000000000000') AS HD_DELIVERYSERVICE_WS_S

    FROM derived_columns
  
),

unknown_values AS (
  
    SELECT

    TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') as ldts,
    'SYSTEM' as rsrc,
    
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "EDTS_IN",
        '(unknown)' AS RAW_DATA,
        0 AS ROW_NUMBER,
        '(unknown)' AS LIEFERDIENSTID,
        '(unknown)' AS LAND,
        '(unknown)' AS NAME,
        '(unknown)' AS TELEFON,
        '(unknown)' AS FAX,
        '(unknown)' AS EMAIL,
        '(unknown)' AS STRASSE,
        '(unknown)' AS HAUSNUMMER,
        '(unknown)' AS PLZ,
        '(unknown)' AS ORT,
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_LIEFERDIENSTID_KEY_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK,
        NULL AS CHK_ALL_MSG
     ,
    
        TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        '(unknown)' AS DELIVERYSERVICE_BK,
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "EDTS",
        CAST('00000000000000000000000000000000' as STRING) as HK_DELIVERYSERVICE_H,
        CAST('00000000000000000000000000000000' as STRING) as HD_DELIVERYSERVICE_WS_S
),


error_values AS (

    SELECT

    TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS') as ldts,
    'ERROR' as rsrc,
    
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "EDTS_IN",
        '(error)' AS RAW_DATA,
        -1 AS ROW_NUMBER
     ,
        '(error)' AS LIEFERDIENSTID,
        '(error)' AS LAND,
        '(error)' AS NAME,
        '(error)' AS TELEFON,
        '(error)' AS FAX,
        '(error)' AS EMAIL,
        '(error)' AS STRASSE,
        '(error)' AS HAUSNUMMER,
        '(error)' AS PLZ,
        '(error)' AS ORT,
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_LIEFERDIENSTID_KEY_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK
     ,
        NULL AS CHK_ALL_MSG
      ,
    
        TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        '(error)' AS DELIVERYSERVICE_BK,
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "EDTS",
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_DELIVERYSERVICE_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HD_DELIVERYSERVICE_WS_S
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
        "LIEFERDIENSTID",
        "LAND",
        "NAME",
        "TELEFON",
        "FAX",
        "EMAIL",
        "STRASSE",
        "HAUSNUMMER",
        "PLZ",
        "ORT",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_LIEFERDIENSTID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "DELIVERYSERVICE_BK",
        "CDTS",
        "EDTS",
        "HK_DELIVERYSERVICE_H",
        "HD_DELIVERYSERVICE_WS_S"

    FROM hashed_columns

  
    UNION ALL
    
    SELECT

    
        "LDTS",
        "RSRC",
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "LIEFERDIENSTID",
        "LAND",
        "NAME",
        "TELEFON",
        "FAX",
        "EMAIL",
        "STRASSE",
        "HAUSNUMMER",
        "PLZ",
        "ORT",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_LIEFERDIENSTID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "DELIVERYSERVICE_BK",
        "CDTS",
        "EDTS",
        "HK_DELIVERYSERVICE_H",
        "HD_DELIVERYSERVICE_WS_S"

    FROM ghost_records
  
)

SELECT * FROM columns_to_select
where is_check_ok or rsrc ='SYSTEM'
  );

