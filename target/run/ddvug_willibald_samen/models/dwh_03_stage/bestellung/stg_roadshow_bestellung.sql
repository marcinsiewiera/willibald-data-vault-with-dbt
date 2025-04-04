
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_roadshow_bestellung
  
    
    
(
  
    "LDTS" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "EDTS_IN" COMMENT $$$$, 
  
    "RAW_DATA" COMMENT $$$$, 
  
    "ROW_NUMBER" COMMENT $$$$, 
  
    "BESTELLUNGID" COMMENT $$$$, 
  
    "PREIS" COMMENT $$$$, 
  
    "RABATT" COMMENT $$$$, 
  
    "KUNDEID" COMMENT $$$$, 
  
    "VEREINSPARTNERID" COMMENT $$$$, 
  
    "KAUFDATUM" COMMENT $$$$, 
  
    "KREDITKARTE" COMMENT $$$$, 
  
    "GUELTIGBIS" COMMENT $$$$, 
  
    "KKFIRMA" COMMENT $$$$, 
  
    "PRODUKTID" COMMENT $$$$, 
  
    "MENGE" COMMENT $$$$, 
  
    "IS_LDTS_SOURCE_TYPE_OK" COMMENT $$$$, 
  
    "IS_EDTS_IN_TYPE_OK" COMMENT $$$$, 
  
    "IS_ROW_NUMBER_TYPE_OK" COMMENT $$$$, 
  
    "IS_PREIS_TYPE_OK" COMMENT $$$$, 
  
    "IS_RABATT_TYPE_OK" COMMENT $$$$, 
  
    "IS_KAUFDATUM_TYPE_OK" COMMENT $$$$, 
  
    "IS_MENGE_TYPE_OK" COMMENT $$$$, 
  
    "IS_DUB_CHECK_OK" COMMENT $$$$, 
  
    "IS_BESTELLUNGID_KEY_CHECK_OK" COMMENT $$$$, 
  
    "IS_PRODUKTID_KEY_CHECK_OK" COMMENT $$$$, 
  
    "IS_CHECK_OK" COMMENT $$$$, 
  
    "CHK_ALL_MSG" COMMENT $$$$, 
  
    "ASSOCIATIONPARTNER_BK" COMMENT $$$$, 
  
    "CUSTOMER_BK" COMMENT $$$$, 
  
    "ORDER_BK" COMMENT $$$$, 
  
    "POSITION_BK" COMMENT $$$$, 
  
    "PRODUCT_BK" COMMENT $$$$, 
  
    "CDTS" COMMENT $$$$, 
  
    "EDTS" COMMENT $$$$, 
  
    "HK_ASSOCIATIONPARTNER_H" COMMENT $$$$, 
  
    "HK_CUSTOMER_H" COMMENT $$$$, 
  
    "HK_ORDER_H" COMMENT $$$$, 
  
    "HK_POSITION_H" COMMENT $$$$, 
  
    "HK_PRODUCT_H" COMMENT $$$$, 
  
    "HK_ORDER_ASSOCIATIONPARTNER_L" COMMENT $$$$, 
  
    "HK_ORDER_CUSTOMER_L" COMMENT $$$$, 
  
    "HK_ORDER_POSITION_L" COMMENT $$$$, 
  
    "HK_POSITION_PRODUCT_L" COMMENT $$$$, 
  
    "HD_POSITION_RS_S" COMMENT $$$$
  
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
        "PREIS",
        "RABATT",
        "KUNDEID",
        "VEREINSPARTNERID",
        "KAUFDATUM",
        "KREDITKARTE",
        "GUELTIGBIS",
        "KKFIRMA",
        "PRODUKTID",
        "MENGE",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_PREIS_TYPE_OK",
        "IS_RABATT_TYPE_OK",
        "IS_KAUFDATUM_TYPE_OK",
        "IS_MENGE_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_PRODUKTID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG"

  FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_roadshow_bestellung

  ),





ldts_rsrc_data AS (

  SELECT
    "LDTS_SOURCE" AS ldts,
    CAST( "RSRC_SOURCE" as STRING ) AS rsrc,
      
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "BESTELLUNGID",
        "PREIS",
        "RABATT",
        "KUNDEID",
        "VEREINSPARTNERID",
        "KAUFDATUM",
        "KREDITKARTE",
        "GUELTIGBIS",
        "KKFIRMA",
        "PRODUKTID",
        "MENGE",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_PREIS_TYPE_OK",
        "IS_RABATT_TYPE_OK",
        "IS_KAUFDATUM_TYPE_OK",
        "IS_MENGE_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
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
        "BESTELLUNGID",
        "PREIS",
        "RABATT",
        "KUNDEID",
        "VEREINSPARTNERID",
        "KAUFDATUM",
        "KREDITKARTE",
        "GUELTIGBIS",
        "KKFIRMA",
        "PRODUKTID",
        "MENGE",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_PREIS_TYPE_OK",
        "IS_RABATT_TYPE_OK",
        "IS_KAUFDATUM_TYPE_OK",
        "IS_MENGE_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_PRODUKTID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
  
  "VEREINSPARTNERID" AS "ASSOCIATIONPARTNER_BK",
    "KUNDEID" AS "CUSTOMER_BK",
    "BESTELLUNGID" AS "ORDER_BK",
    CAST(BESTELLUNGID ||'_'|| PRODUKTID ||'_'|| CAST(ROW_NUMBER() OVER (PARTITION BY LDTS, BESTELLUNGID, PRODUKTID  ORDER BY MENGE, PREIS) AS VARCHAR) AS VARCHAR) AS "POSITION_BK",
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
        "PREIS",
        "RABATT",
        "KUNDEID",
        "VEREINSPARTNERID",
        "KAUFDATUM",
        "KREDITKARTE",
        "GUELTIGBIS",
        "KKFIRMA",
        "PRODUKTID",
        "MENGE",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_PREIS_TYPE_OK",
        "IS_RABATT_TYPE_OK",
        "IS_KAUFDATUM_TYPE_OK",
        "IS_MENGE_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_PRODUKTID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "ASSOCIATIONPARTNER_BK",
        "CUSTOMER_BK",
        "ORDER_BK",
        "POSITION_BK",
        "PRODUCT_BK",
        "CDTS",
        "EDTS",
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("VEREINSPARTNERID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^'))), '00000000000000000000000000000000') AS HK_ASSOCIATIONPARTNER_H,
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
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("BESTELLUNGID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("PRODUKTID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
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
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("ORDER_BK" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("ASSOCIATIONPARTNER_BK" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^'))), '00000000000000000000000000000000') AS HK_ORDER_ASSOCIATIONPARTNER_L,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("ORDER_BK" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("CUSTOMER_BK" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        ), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^'))), '00000000000000000000000000000000') AS HK_ORDER_CUSTOMER_L,
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
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("GUELTIGBIS" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("KAUFDATUM" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("KKFIRMA" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("KREDITKARTE" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("MENGE" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("PREIS" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("PRODUKTID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("RABATT" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        )), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^||^^||^^||^^||^^||^^||^^||^^'))), '00000000000000000000000000000000') AS HD_POSITION_RS_S

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
        0 AS PREIS,
        0 AS RABATT,
        '(unknown)' AS KUNDEID,
        '(unknown)' AS VEREINSPARTNERID,
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "KAUFDATUM",
        '(unknown)' AS KREDITKARTE,
        '(unknown)' AS GUELTIGBIS,
        '(unknown)' AS KKFIRMA,
        '(unknown)' AS PRODUKTID,
        0 AS MENGE,
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_PREIS_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_RABATT_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_KAUFDATUM_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_MENGE_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_BESTELLUNGID_KEY_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_PRODUKTID_KEY_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK,
        NULL AS CHK_ALL_MSG
     ,
    
        '(unknown)' AS ASSOCIATIONPARTNER_BK,
        TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        '(unknown)' AS CUSTOMER_BK,
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "EDTS",
        '(unknown)' AS ORDER_BK,
        '(unknown)' AS POSITION_BK,
        '(unknown)' AS PRODUCT_BK,
        CAST('00000000000000000000000000000000' as STRING) as HK_ASSOCIATIONPARTNER_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_CUSTOMER_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_ORDER_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_POSITION_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_PRODUCT_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_ORDER_ASSOCIATIONPARTNER_L,
        CAST('00000000000000000000000000000000' as STRING) as HK_ORDER_CUSTOMER_L,
        CAST('00000000000000000000000000000000' as STRING) as HK_ORDER_POSITION_L,
        CAST('00000000000000000000000000000000' as STRING) as HK_POSITION_PRODUCT_L,
        CAST('00000000000000000000000000000000' as STRING) as HD_POSITION_RS_S
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
        -1 AS PREIS
     ,
        -1 AS RABATT
     ,
        '(error)' AS KUNDEID,
        '(error)' AS VEREINSPARTNERID,
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "KAUFDATUM",
        '(error)' AS KREDITKARTE,
        '(error)' AS GUELTIGBIS,
        '(error)' AS KKFIRMA,
        '(error)' AS PRODUKTID,
        -1 AS MENGE
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_PREIS_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_RABATT_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_KAUFDATUM_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_MENGE_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_BESTELLUNGID_KEY_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_PRODUKTID_KEY_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK
     ,
        NULL AS CHK_ALL_MSG
      ,
    
        '(error)' AS ASSOCIATIONPARTNER_BK,
        TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        '(error)' AS CUSTOMER_BK,
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "EDTS",
        '(error)' AS ORDER_BK,
        '(error)' AS POSITION_BK,
        '(error)' AS PRODUCT_BK,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_ASSOCIATIONPARTNER_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_CUSTOMER_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_ORDER_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_POSITION_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_PRODUCT_H,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_ORDER_ASSOCIATIONPARTNER_L,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_ORDER_CUSTOMER_L,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_ORDER_POSITION_L,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_POSITION_PRODUCT_L,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HD_POSITION_RS_S
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
        "PREIS",
        "RABATT",
        "KUNDEID",
        "VEREINSPARTNERID",
        "KAUFDATUM",
        "KREDITKARTE",
        "GUELTIGBIS",
        "KKFIRMA",
        "PRODUKTID",
        "MENGE",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_PREIS_TYPE_OK",
        "IS_RABATT_TYPE_OK",
        "IS_KAUFDATUM_TYPE_OK",
        "IS_MENGE_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_PRODUKTID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "ASSOCIATIONPARTNER_BK",
        "CUSTOMER_BK",
        "ORDER_BK",
        "POSITION_BK",
        "PRODUCT_BK",
        "CDTS",
        "EDTS",
        "HK_ASSOCIATIONPARTNER_H",
        "HK_CUSTOMER_H",
        "HK_ORDER_H",
        "HK_POSITION_H",
        "HK_PRODUCT_H",
        "HK_ORDER_ASSOCIATIONPARTNER_L",
        "HK_ORDER_CUSTOMER_L",
        "HK_ORDER_POSITION_L",
        "HK_POSITION_PRODUCT_L",
        "HD_POSITION_RS_S"

    FROM hashed_columns

  
    UNION ALL
    
    SELECT

    
        "LDTS",
        "RSRC",
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "BESTELLUNGID",
        "PREIS",
        "RABATT",
        "KUNDEID",
        "VEREINSPARTNERID",
        "KAUFDATUM",
        "KREDITKARTE",
        "GUELTIGBIS",
        "KKFIRMA",
        "PRODUKTID",
        "MENGE",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_PREIS_TYPE_OK",
        "IS_RABATT_TYPE_OK",
        "IS_KAUFDATUM_TYPE_OK",
        "IS_MENGE_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_BESTELLUNGID_KEY_CHECK_OK",
        "IS_PRODUKTID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "ASSOCIATIONPARTNER_BK",
        "CUSTOMER_BK",
        "ORDER_BK",
        "POSITION_BK",
        "PRODUCT_BK",
        "CDTS",
        "EDTS",
        "HK_ASSOCIATIONPARTNER_H",
        "HK_CUSTOMER_H",
        "HK_ORDER_H",
        "HK_POSITION_H",
        "HK_PRODUCT_H",
        "HK_ORDER_ASSOCIATIONPARTNER_L",
        "HK_ORDER_CUSTOMER_L",
        "HK_ORDER_POSITION_L",
        "HK_POSITION_PRODUCT_L",
        "HD_POSITION_RS_S"

    FROM ghost_records
  
)

SELECT * FROM columns_to_select
where is_check_ok or rsrc ='SYSTEM'
  );

