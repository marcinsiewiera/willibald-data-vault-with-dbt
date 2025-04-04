
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_err.stg_error_misc
  
    
    
(
  
    "LDTS" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "ROW_NUMBER" COMMENT $$$$, 
  
    "RAW_DATA" COMMENT $$$$, 
  
    "CHK_ALL_MSG" COMMENT $$$$, 
  
    "IS_CHECK_OK" COMMENT $$$$, 
  
    "ERROR_ROW_NO_BK" COMMENT $$$$, 
  
    "ERROR_FILE_BK" COMMENT $$$$, 
  
    "HK_ERROR_H" COMMENT $$$$, 
  
    "HD_ERROR_S" COMMENT $$$$
  
)

   as (
    
--LOAD_TIMESTAMP, RECORD_SOURCE, JSON_DATA, CHK_ALL_MSG








WITH


source_data AS (
    SELECT

    
        "ROW_NUMBER",
        "LDTS",
        "RSRC",
        "RAW_DATA",
        "CHK_ALL_MSG",
        "IS_CHECK_OK"

  FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_err.pre_stg_error_misc

  ),





ldts_rsrc_data AS (

  SELECT
    "LDTS" AS ldts,
    CAST( "RSRC" as STRING ) AS rsrc,
      
        "ROW_NUMBER",
        "RAW_DATA",
        "CHK_ALL_MSG",
        "IS_CHECK_OK"
    

  FROM source_data
  

),

derived_columns AS (SELECT
  
        "LDTS",
        "RSRC",
        "ROW_NUMBER",
        "RAW_DATA",
        "CHK_ALL_MSG",
        "IS_CHECK_OK",
  
  to_varchar(row_number) AS "ERROR_ROW_NO_BK",
    to_varchar(rsrc) AS "ERROR_FILE_BK"

  FROM ldts_rsrc_data
),




hashed_columns AS (

    SELECT

    
        "LDTS",
        "RSRC",
        "ROW_NUMBER",
        "RAW_DATA",
        "CHK_ALL_MSG",
        "IS_CHECK_OK",
        "ERROR_ROW_NO_BK",
        "ERROR_FILE_BK",
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("ERROR_FILE_BK" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("ERROR_ROW_NO_BK" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^'))), '00000000000000000000000000000000') AS HK_ERROR_H,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("RAW_DATA" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("CHK_ALL_MSG" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^'))), '00000000000000000000000000000000') AS HD_ERROR_S

    FROM derived_columns
  
),

unknown_values AS (
  
    SELECT

    TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') as ldts,
    'SYSTEM' as rsrc,
    
        0 AS ROW_NUMBER,
        '(unknown)' AS RAW_DATA,
        NULL AS CHK_ALL_MSG
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK,
    
        '(unknown)' AS ERROR_FILE_BK,
        '(unknown)' AS ERROR_ROW_NO_BK,
        CAST('00000000000000000000000000000000' as STRING) as HK_ERROR_H,
        CAST('00000000000000000000000000000000' as STRING) as HD_ERROR_S
),


error_values AS (

    SELECT

    TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS') as ldts,
    'ERROR' as rsrc,
    
        -1 AS ROW_NUMBER
     ,
        '(error)' AS RAW_DATA,
        NULL AS CHK_ALL_MSG
      ,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK
     ,
    
        '(error)' AS ERROR_FILE_BK,
        '(error)' AS ERROR_ROW_NO_BK,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_ERROR_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HD_ERROR_S
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
        "ROW_NUMBER",
        "RAW_DATA",
        "CHK_ALL_MSG",
        "IS_CHECK_OK",
        "ERROR_ROW_NO_BK",
        "ERROR_FILE_BK",
        "HK_ERROR_H",
        "HD_ERROR_S"

    FROM hashed_columns

  
    UNION ALL
    
    SELECT

    
        "LDTS",
        "RSRC",
        "ROW_NUMBER",
        "RAW_DATA",
        "CHK_ALL_MSG",
        "IS_CHECK_OK",
        "ERROR_ROW_NO_BK",
        "ERROR_FILE_BK",
        "HK_ERROR_H",
        "HD_ERROR_S"

    FROM ghost_records
  
)

SELECT * FROM columns_to_select
  );

