
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_webshop_vereinspartner
  
    
    
(
  
    "LDTS" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "EDTS_IN" COMMENT $$$$, 
  
    "RAW_DATA" COMMENT $$$$, 
  
    "ROW_NUMBER" COMMENT $$$$, 
  
    "VEREINSPARTNERID" COMMENT $$$$, 
  
    "KUNDEIDVEREIN" COMMENT $$$$, 
  
    "RABATT1" COMMENT $$$$, 
  
    "RABATT2" COMMENT $$$$, 
  
    "RABATT3" COMMENT $$$$, 
  
    "IS_LDTS_SOURCE_TYPE_OK" COMMENT $$$$, 
  
    "IS_EDTS_IN_TYPE_OK" COMMENT $$$$, 
  
    "IS_ROW_NUMBER_TYPE_OK" COMMENT $$$$, 
  
    "IS_RABATT1_TYPE_OK" COMMENT $$$$, 
  
    "IS_RABATT2_TYPE_OK" COMMENT $$$$, 
  
    "IS_RABATT3_TYPE_OK" COMMENT $$$$, 
  
    "IS_DUB_CHECK_OK" COMMENT $$$$, 
  
    "IS_VEREINSPARTNERID_KEY_CHECK_OK" COMMENT $$$$, 
  
    "IS_CHECK_OK" COMMENT $$$$, 
  
    "CHK_ALL_MSG" COMMENT $$$$, 
  
    "ASSOCIATIONPARTNER_BK" COMMENT $$$$, 
  
    "CUSTOMER_BK" COMMENT $$$$, 
  
    "CDTS" COMMENT $$$$, 
  
    "EDTS" COMMENT $$$$, 
  
    "HK_ASSOCIATIONPARTNER_H" COMMENT $$$$, 
  
    "HK_CUSTOMER_H" COMMENT $$$$, 
  
    "HK_ASSOCIATIONPARTNER_CUSTOMER_L" COMMENT $$$$, 
  
    "HD_ASSOCIATIONPARTNER_WS_S" COMMENT $$$$
  
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
        "VEREINSPARTNERID",
        "KUNDEIDVEREIN",
        "RABATT1",
        "RABATT2",
        "RABATT3",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_RABATT1_TYPE_OK",
        "IS_RABATT2_TYPE_OK",
        "IS_RABATT3_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_VEREINSPARTNERID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG"

  FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_vereinspartner

  ),





ldts_rsrc_data AS (

  SELECT
    "LDTS_SOURCE" AS ldts,
    CAST( "RSRC_SOURCE" as STRING ) AS rsrc,
      
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "VEREINSPARTNERID",
        "KUNDEIDVEREIN",
        "RABATT1",
        "RABATT2",
        "RABATT3",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_RABATT1_TYPE_OK",
        "IS_RABATT2_TYPE_OK",
        "IS_RABATT3_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_VEREINSPARTNERID_KEY_CHECK_OK",
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
        "VEREINSPARTNERID",
        "KUNDEIDVEREIN",
        "RABATT1",
        "RABATT2",
        "RABATT3",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_RABATT1_TYPE_OK",
        "IS_RABATT2_TYPE_OK",
        "IS_RABATT3_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_VEREINSPARTNERID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
  
  "VEREINSPARTNERID" AS "ASSOCIATIONPARTNER_BK",
    "KUNDEIDVEREIN" AS "CUSTOMER_BK",
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
        "VEREINSPARTNERID",
        "KUNDEIDVEREIN",
        "RABATT1",
        "RABATT2",
        "RABATT3",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_RABATT1_TYPE_OK",
        "IS_RABATT2_TYPE_OK",
        "IS_RABATT3_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_VEREINSPARTNERID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "ASSOCIATIONPARTNER_BK",
        "CUSTOMER_BK",
        "CDTS",
        "EDTS",
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("VEREINSPARTNERID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^'))), '00000000000000000000000000000000') AS HK_ASSOCIATIONPARTNER_H,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("KUNDEIDVEREIN" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^'))), '00000000000000000000000000000000') AS HK_CUSTOMER_H,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("CUSTOMER_BK" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("ASSOCIATIONPARTNER_BK" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^'))), '00000000000000000000000000000000') AS HK_ASSOCIATIONPARTNER_CUSTOMER_L,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(UPPER(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("KUNDEIDVEREIN" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("RABATT1" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("RABATT2" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("RABATT3" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        )), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^||^^||^^'))), '00000000000000000000000000000000') AS HD_ASSOCIATIONPARTNER_WS_S

    FROM derived_columns
  
),

unknown_values AS (
  
    SELECT

    TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') as ldts,
    'SYSTEM' as rsrc,
    
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "EDTS_IN",
        '(unknown)' AS RAW_DATA,
        0 AS ROW_NUMBER,
        '(unknown)' AS VEREINSPARTNERID,
        '(unknown)' AS KUNDEIDVEREIN,
        0 AS RABATT1,
        0 AS RABATT2,
        0 AS RABATT3,
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_RABATT1_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_RABATT2_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_RABATT3_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_VEREINSPARTNERID_KEY_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK,
        NULL AS CHK_ALL_MSG
     ,
    
        '(unknown)' AS ASSOCIATIONPARTNER_BK,
        TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        '(unknown)' AS CUSTOMER_BK,
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "EDTS",
        CAST('00000000000000000000000000000000' as STRING) as HK_ASSOCIATIONPARTNER_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_CUSTOMER_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_ASSOCIATIONPARTNER_CUSTOMER_L,
        CAST('00000000000000000000000000000000' as STRING) as HD_ASSOCIATIONPARTNER_WS_S
),


error_values AS (

    SELECT

    TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS') as ldts,
    'ERROR' as rsrc,
    
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "EDTS_IN",
        '(error)' AS RAW_DATA,
        -1 AS ROW_NUMBER
     ,
        '(error)' AS VEREINSPARTNERID,
        '(error)' AS KUNDEIDVEREIN,
        -1 AS RABATT1
     ,
        -1 AS RABATT2
     ,
        -1 AS RABATT3
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_RABATT1_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_RABATT2_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_RABATT3_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_VEREINSPARTNERID_KEY_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK
     ,
        NULL AS CHK_ALL_MSG
      ,
    
        '(error)' AS ASSOCIATIONPARTNER_BK,
        TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        '(error)' AS CUSTOMER_BK,
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "EDTS",
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_ASSOCIATIONPARTNER_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_CUSTOMER_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_ASSOCIATIONPARTNER_CUSTOMER_L,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HD_ASSOCIATIONPARTNER_WS_S
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
        "VEREINSPARTNERID",
        "KUNDEIDVEREIN",
        "RABATT1",
        "RABATT2",
        "RABATT3",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_RABATT1_TYPE_OK",
        "IS_RABATT2_TYPE_OK",
        "IS_RABATT3_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_VEREINSPARTNERID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "ASSOCIATIONPARTNER_BK",
        "CUSTOMER_BK",
        "CDTS",
        "EDTS",
        "HK_ASSOCIATIONPARTNER_H",
        "HK_CUSTOMER_H",
        "HK_ASSOCIATIONPARTNER_CUSTOMER_L",
        "HD_ASSOCIATIONPARTNER_WS_S"

    FROM hashed_columns

  
    UNION ALL
    
    SELECT

    
        "LDTS",
        "RSRC",
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "VEREINSPARTNERID",
        "KUNDEIDVEREIN",
        "RABATT1",
        "RABATT2",
        "RABATT3",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_RABATT1_TYPE_OK",
        "IS_RABATT2_TYPE_OK",
        "IS_RABATT3_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_VEREINSPARTNERID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "ASSOCIATIONPARTNER_BK",
        "CUSTOMER_BK",
        "CDTS",
        "EDTS",
        "HK_ASSOCIATIONPARTNER_H",
        "HK_CUSTOMER_H",
        "HK_ASSOCIATIONPARTNER_CUSTOMER_L",
        "HD_ASSOCIATIONPARTNER_WS_S"

    FROM ghost_records
  
)

SELECT * FROM columns_to_select
where is_check_ok or rsrc ='SYSTEM'
  );

