
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_webshop_produkt
  
    
    
(
  
    "LDTS" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "EDTS_IN" COMMENT $$$$, 
  
    "RAW_DATA" COMMENT $$$$, 
  
    "ROW_NUMBER" COMMENT $$$$, 
  
    "PRODUKTID" COMMENT $$$$, 
  
    "KATID" COMMENT $$$$, 
  
    "BEZEICHNUNG" COMMENT $$$$, 
  
    "UMFANG" COMMENT $$$$, 
  
    "TYP" COMMENT $$$$, 
  
    "PREIS" COMMENT $$$$, 
  
    "PFLANZORT" COMMENT $$$$, 
  
    "PFLANZABSTAND" COMMENT $$$$, 
  
    "IS_LDTS_SOURCE_TYPE_OK" COMMENT $$$$, 
  
    "IS_EDTS_IN_TYPE_OK" COMMENT $$$$, 
  
    "IS_ROW_NUMBER_TYPE_OK" COMMENT $$$$, 
  
    "IS_TYP_TYPE_OK" COMMENT $$$$, 
  
    "IS_PREIS_TYPE_OK" COMMENT $$$$, 
  
    "IS_DUB_CHECK_OK" COMMENT $$$$, 
  
    "IS_PRODUKTID_KEY_CHECK_OK" COMMENT $$$$, 
  
    "IS_CHECK_OK" COMMENT $$$$, 
  
    "CHK_ALL_MSG" COMMENT $$$$, 
  
    "PRODUCT_BK" COMMENT $$$$, 
  
    "PRODUCTCATEGORY_BK" COMMENT $$$$, 
  
    "CDTS" COMMENT $$$$, 
  
    "EDTS" COMMENT $$$$, 
  
    "HK_PRODUCT_H" COMMENT $$$$, 
  
    "HK_PRODUCTCATEGORY_H" COMMENT $$$$, 
  
    "HK_PRODUCT_PRODUCTCATEGORY_L" COMMENT $$$$, 
  
    "HD_PRODUCT_WS_S" COMMENT $$$$
  
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
        "PRODUKTID",
        "KATID",
        "BEZEICHNUNG",
        "UMFANG",
        "TYP",
        "PREIS",
        "PFLANZORT",
        "PFLANZABSTAND",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_TYP_TYPE_OK",
        "IS_PREIS_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_PRODUKTID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG"

  FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_produkt

  ),





ldts_rsrc_data AS (

  SELECT
    "LDTS_SOURCE" AS ldts,
    CAST( "RSRC_SOURCE" as STRING ) AS rsrc,
      
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "PRODUKTID",
        "KATID",
        "BEZEICHNUNG",
        "UMFANG",
        "TYP",
        "PREIS",
        "PFLANZORT",
        "PFLANZABSTAND",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_TYP_TYPE_OK",
        "IS_PREIS_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_PRODUKTID_KEY_CHECK_OK",
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
        "PRODUKTID",
        "KATID",
        "BEZEICHNUNG",
        "UMFANG",
        "TYP",
        "PREIS",
        "PFLANZORT",
        "PFLANZABSTAND",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_TYP_TYPE_OK",
        "IS_PREIS_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_PRODUKTID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
  
  "PRODUKTID" AS "PRODUCT_BK",
    "KATID" AS "PRODUCTCATEGORY_BK",
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
        "PRODUKTID",
        "KATID",
        "BEZEICHNUNG",
        "UMFANG",
        "TYP",
        "PREIS",
        "PFLANZORT",
        "PFLANZABSTAND",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_TYP_TYPE_OK",
        "IS_PREIS_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_PRODUKTID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "PRODUCT_BK",
        "PRODUCTCATEGORY_BK",
        "CDTS",
        "EDTS",
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("PRODUKTID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^'))), '00000000000000000000000000000000') AS HK_PRODUCT_H,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("KATID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^'))), '00000000000000000000000000000000') AS HK_PRODUCTCATEGORY_H,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("PRODUCTCATEGORY_BK" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("PRODUCT_BK" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^'))), '00000000000000000000000000000000') AS HK_PRODUCT_PRODUCTCATEGORY_L,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(UPPER(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("BEZEICHNUNG" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("PFLANZABSTAND" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("PFLANZORT" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("PREIS" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("TYP" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("UMFANG" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        )), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^||^^||^^||^^||^^'))), '00000000000000000000000000000000') AS HD_PRODUCT_WS_S

    FROM derived_columns
  
),

unknown_values AS (
  
    SELECT

    TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') as ldts,
    'SYSTEM' as rsrc,
    
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "EDTS_IN",
        '(unknown)' AS RAW_DATA,
        0 AS ROW_NUMBER,
        '(unknown)' AS PRODUKTID,
        '(unknown)' AS KATID,
        '(unknown)' AS BEZEICHNUNG,
        '(unknown)' AS UMFANG,
        0 AS TYP,
        0 AS PREIS,
        '(unknown)' AS PFLANZORT,
        '(unknown)' AS PFLANZABSTAND,
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_TYP_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_PREIS_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_PRODUKTID_KEY_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK,
        NULL AS CHK_ALL_MSG
     ,
    
        TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "EDTS",
        '(unknown)' AS PRODUCTCATEGORY_BK,
        '(unknown)' AS PRODUCT_BK,
        CAST('00000000000000000000000000000000' as STRING) as HK_PRODUCT_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_PRODUCTCATEGORY_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_PRODUCT_PRODUCTCATEGORY_L,
        CAST('00000000000000000000000000000000' as STRING) as HD_PRODUCT_WS_S
),


error_values AS (

    SELECT

    TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS') as ldts,
    'ERROR' as rsrc,
    
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "EDTS_IN",
        '(error)' AS RAW_DATA,
        -1 AS ROW_NUMBER
     ,
        '(error)' AS PRODUKTID,
        '(error)' AS KATID,
        '(error)' AS BEZEICHNUNG,
        '(error)' AS UMFANG,
        -1 AS TYP
     ,
        -1 AS PREIS
     ,
        '(error)' AS PFLANZORT,
        '(error)' AS PFLANZABSTAND,
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_TYP_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_PREIS_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_PRODUKTID_KEY_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK
     ,
        NULL AS CHK_ALL_MSG
      ,
    
        TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "EDTS",
        '(error)' AS PRODUCTCATEGORY_BK,
        '(error)' AS PRODUCT_BK,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_PRODUCT_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_PRODUCTCATEGORY_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_PRODUCT_PRODUCTCATEGORY_L,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HD_PRODUCT_WS_S
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
        "PRODUKTID",
        "KATID",
        "BEZEICHNUNG",
        "UMFANG",
        "TYP",
        "PREIS",
        "PFLANZORT",
        "PFLANZABSTAND",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_TYP_TYPE_OK",
        "IS_PREIS_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_PRODUKTID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "PRODUCT_BK",
        "PRODUCTCATEGORY_BK",
        "CDTS",
        "EDTS",
        "HK_PRODUCT_H",
        "HK_PRODUCTCATEGORY_H",
        "HK_PRODUCT_PRODUCTCATEGORY_L",
        "HD_PRODUCT_WS_S"

    FROM hashed_columns

  
    UNION ALL
    
    SELECT

    
        "LDTS",
        "RSRC",
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "PRODUKTID",
        "KATID",
        "BEZEICHNUNG",
        "UMFANG",
        "TYP",
        "PREIS",
        "PFLANZORT",
        "PFLANZABSTAND",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_TYP_TYPE_OK",
        "IS_PREIS_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_PRODUKTID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "PRODUCT_BK",
        "PRODUCTCATEGORY_BK",
        "CDTS",
        "EDTS",
        "HK_PRODUCT_H",
        "HK_PRODUCTCATEGORY_H",
        "HK_PRODUCT_PRODUCTCATEGORY_L",
        "HD_PRODUCT_WS_S"

    FROM ghost_records
  
)

SELECT * FROM columns_to_select
where is_check_ok or rsrc ='SYSTEM'
  );

