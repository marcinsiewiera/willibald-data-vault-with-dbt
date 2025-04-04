
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_misc_kategorie_termintreue
  
    
    
(
  
    "LDTS" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "EDTS_IN" COMMENT $$$$, 
  
    "RAW_DATA" COMMENT $$$$, 
  
    "ROW_NUMBER" COMMENT $$$$, 
  
    "ANZAHL_TAGE_VON" COMMENT $$$$, 
  
    "ANZAHL_TAGE_BIS" COMMENT $$$$, 
  
    "BEZEICHNUNG" COMMENT $$$$, 
  
    "BEWERTUNG" COMMENT $$$$, 
  
    "IS_LDTS_SOURCE_TYPE_OK" COMMENT $$$$, 
  
    "IS_EDTS_IN_TYPE_OK" COMMENT $$$$, 
  
    "IS_ROW_NUMBER_TYPE_OK" COMMENT $$$$, 
  
    "IS_DUB_CHECK_OK" COMMENT $$$$, 
  
    "IS_BEWERTUNG_KEY_CHECK_OK" COMMENT $$$$, 
  
    "IS_CHECK_OK" COMMENT $$$$, 
  
    "CHK_ALL_MSG" COMMENT $$$$, 
  
    "CATEGORY_DELIVERYADHERENCE_NK" COMMENT $$$$, 
  
    "COUNT_DAYS_FROM" COMMENT $$$$, 
  
    "COUNT_DAYS_TO" COMMENT $$$$, 
  
    "NAME" COMMENT $$$$, 
  
    "CDTS" COMMENT $$$$, 
  
    "EDTS" COMMENT $$$$, 
  
    "HD_CATEGORY_DELIVERYADHERENCE_MISC_RS" COMMENT $$$$
  
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
        "ANZAHL_TAGE_VON",
        "ANZAHL_TAGE_BIS",
        "BEZEICHNUNG",
        "BEWERTUNG",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BEWERTUNG_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG"

  FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_misc_kategorie_termintreue

  ),





ldts_rsrc_data AS (

  SELECT
    "LDTS_SOURCE" AS ldts,
    CAST( "RSRC_SOURCE" as STRING ) AS rsrc,
      
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "ANZAHL_TAGE_VON",
        "ANZAHL_TAGE_BIS",
        "BEZEICHNUNG",
        "BEWERTUNG",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BEWERTUNG_KEY_CHECK_OK",
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
        "ANZAHL_TAGE_VON",
        "ANZAHL_TAGE_BIS",
        "BEZEICHNUNG",
        "BEWERTUNG",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BEWERTUNG_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
  
  "BEWERTUNG" AS "CATEGORY_DELIVERYADHERENCE_NK",
    "ANZAHL_TAGE_VON" AS "COUNT_DAYS_FROM",
    "ANZAHL_TAGE_BIS" AS "COUNT_DAYS_TO",
    "BEZEICHNUNG" AS "NAME",
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
        "ANZAHL_TAGE_VON",
        "ANZAHL_TAGE_BIS",
        "BEZEICHNUNG",
        "BEWERTUNG",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BEWERTUNG_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "CATEGORY_DELIVERYADHERENCE_NK",
        "COUNT_DAYS_FROM",
        "COUNT_DAYS_TO",
        "NAME",
        "CDTS",
        "EDTS",
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(UPPER(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("ANZAHL_TAGE_VON" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("ANZAHL_TAGE_BIS" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("BEZEICHNUNG" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        )), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^||^^'))), '00000000000000000000000000000000') AS HD_CATEGORY_DELIVERYADHERENCE_MISC_RS

    FROM derived_columns
  
),

unknown_values AS (
  
    SELECT

    TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') as ldts,
    'SYSTEM' as rsrc,
    
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "EDTS_IN",
        '(unknown)' AS RAW_DATA,
        0 AS ROW_NUMBER,
        '(unknown)' AS ANZAHL_TAGE_VON,
        '(unknown)' AS ANZAHL_TAGE_BIS,
        '(unknown)' AS BEZEICHNUNG,
        '(unknown)' AS BEWERTUNG,
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_BEWERTUNG_KEY_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK,
        NULL AS CHK_ALL_MSG
     ,
    
        '(unknown)' AS CATEGORY_DELIVERYADHERENCE_NK,
        TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        '(unknown)' AS COUNT_DAYS_FROM,
        '(unknown)' AS COUNT_DAYS_TO,
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "EDTS",
        '(unknown)' AS NAME,
        CAST('00000000000000000000000000000000' as STRING) as HD_CATEGORY_DELIVERYADHERENCE_MISC_RS
),


error_values AS (

    SELECT

    TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS') as ldts,
    'ERROR' as rsrc,
    
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "EDTS_IN",
        '(error)' AS RAW_DATA,
        -1 AS ROW_NUMBER
     ,
        '(error)' AS ANZAHL_TAGE_VON,
        '(error)' AS ANZAHL_TAGE_BIS,
        '(error)' AS BEZEICHNUNG,
        '(error)' AS BEWERTUNG,
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_BEWERTUNG_KEY_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK
     ,
        NULL AS CHK_ALL_MSG
      ,
    
        '(error)' AS CATEGORY_DELIVERYADHERENCE_NK,
        TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        '(error)' AS COUNT_DAYS_FROM,
        '(error)' AS COUNT_DAYS_TO,
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "EDTS",
        '(error)' AS NAME,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HD_CATEGORY_DELIVERYADHERENCE_MISC_RS
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
        "ANZAHL_TAGE_VON",
        "ANZAHL_TAGE_BIS",
        "BEZEICHNUNG",
        "BEWERTUNG",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BEWERTUNG_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "CATEGORY_DELIVERYADHERENCE_NK",
        "COUNT_DAYS_FROM",
        "COUNT_DAYS_TO",
        "NAME",
        "CDTS",
        "EDTS",
        "HD_CATEGORY_DELIVERYADHERENCE_MISC_RS"

    FROM hashed_columns

  
    UNION ALL
    
    SELECT

    
        "LDTS",
        "RSRC",
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "ANZAHL_TAGE_VON",
        "ANZAHL_TAGE_BIS",
        "BEZEICHNUNG",
        "BEWERTUNG",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BEWERTUNG_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "CATEGORY_DELIVERYADHERENCE_NK",
        "COUNT_DAYS_FROM",
        "COUNT_DAYS_TO",
        "NAME",
        "CDTS",
        "EDTS",
        "HD_CATEGORY_DELIVERYADHERENCE_MISC_RS"

    FROM ghost_records
  
)

SELECT * FROM columns_to_select
where is_check_ok or rsrc ='SYSTEM'
  );

