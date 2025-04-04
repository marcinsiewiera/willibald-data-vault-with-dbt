
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_webshop_ref_produkt_typ
  
    
    
(
  
    "LDTS" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "EDTS_IN" COMMENT $$$$, 
  
    "RAW_DATA" COMMENT $$$$, 
  
    "ROW_NUMBER" COMMENT $$$$, 
  
    "TYP" COMMENT $$$$, 
  
    "BEZEICHNUNG" COMMENT $$$$, 
  
    "IS_DUB_CHECK_OK" COMMENT $$$$, 
  
    "IS_KEY_CHECK_OK" COMMENT $$$$, 
  
    "IS_CHECK_OK" COMMENT $$$$, 
  
    "CHK_ALL_MSG" COMMENT $$$$, 
  
    "CDTS" COMMENT $$$$, 
  
    "PRODUCT_TYPE_NK" COMMENT $$$$, 
  
    "EDTS" COMMENT $$$$, 
  
    "HD_PRODUCT_TYPE_WS_RS" COMMENT $$$$
  
)

   as (
    








WITH


source_data AS (
    SELECT

    
        "LDTS_SOURCE",
        "EDTS_IN",
        "RSRC_SOURCE",
        "RAW_DATA",
        "ROW_NUMBER",
        "TYP",
        "BEZEICHNUNG",
        "IS_DUB_CHECK_OK",
        "IS_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG"

  FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_ref_produkt_typ

  ),





ldts_rsrc_data AS (

  SELECT
    "LDTS_SOURCE" AS ldts,
    CAST( "RSRC_SOURCE" as STRING ) AS rsrc,
      
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "TYP",
        "BEZEICHNUNG",
        "IS_DUB_CHECK_OK",
        "IS_KEY_CHECK_OK",
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
        "TYP",
        "BEZEICHNUNG",
        "IS_DUB_CHECK_OK",
        "IS_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
  
  TO_TIMESTAMP(DATEADD(HOUR, 1, SYSDATE())) AS "CDTS",
    typ::string AS "PRODUCT_TYPE_NK",
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
        "TYP",
        "BEZEICHNUNG",
        "IS_DUB_CHECK_OK",
        "IS_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "CDTS",
        "PRODUCT_TYPE_NK",
        "EDTS",
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(UPPER(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("BEZEICHNUNG" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        )), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^'))), '00000000000000000000000000000000') AS HD_PRODUCT_TYPE_WS_RS

    FROM derived_columns
  
),

unknown_values AS (
  
    SELECT

    TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') as ldts,
    'SYSTEM' as rsrc,
    
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "EDTS_IN",
        NULL AS RAW_DATA
     ,
        '(unknown)' AS ROW_NUMBER,
        '(unknown)' AS TYP,
        '(unknown)' AS BEZEICHNUNG,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_KEY_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK,
        NULL AS CHK_ALL_MSG
     ,
    
        TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "EDTS",
        '(unknown)' AS PRODUCT_TYPE_NK,
        CAST('00000000000000000000000000000000' as STRING) as HD_PRODUCT_TYPE_WS_RS
),


error_values AS (

    SELECT

    TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS') as ldts,
    'ERROR' as rsrc,
    
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "EDTS_IN",
        NULL AS RAW_DATA
      ,
        '(error)' AS ROW_NUMBER,
        '(error)' AS TYP,
        '(error)' AS BEZEICHNUNG,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_KEY_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK
     ,
        NULL AS CHK_ALL_MSG
      ,
    
        TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "EDTS",
        '(error)' AS PRODUCT_TYPE_NK,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HD_PRODUCT_TYPE_WS_RS
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
        "TYP",
        "BEZEICHNUNG",
        "IS_DUB_CHECK_OK",
        "IS_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "CDTS",
        "PRODUCT_TYPE_NK",
        "EDTS",
        "HD_PRODUCT_TYPE_WS_RS"

    FROM hashed_columns

  
    UNION ALL
    
    SELECT

    
        "LDTS",
        "RSRC",
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "TYP",
        "BEZEICHNUNG",
        "IS_DUB_CHECK_OK",
        "IS_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "CDTS",
        "PRODUCT_TYPE_NK",
        "EDTS",
        "HD_PRODUCT_TYPE_WS_RS"

    FROM ghost_records
  
)

SELECT * FROM columns_to_select
where is_check_ok or (typ in ('00000000000000000000000000000000'::string, 'ffffffffffffffffffffffffffffffff'::string) )
  );

