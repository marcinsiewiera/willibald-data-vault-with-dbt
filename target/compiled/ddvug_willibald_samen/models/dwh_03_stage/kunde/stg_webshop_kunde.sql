













WITH


source_data AS (
    SELECT

    
        "LDTS_SOURCE",
        "RSRC_SOURCE",
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "KUNDEID",
        "KREDITKARTE",
        "GUELTIGBIS",
        "KKFIRMA",
        "VEREINSPARTNERID",
        "VORNAME",
        "NAME",
        "GESCHLECHT",
        "GEBURTSDATUM",
        "TELEFON",
        "MOBIL",
        "EMAIL",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_GEBURTSDATUM_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_KUNDEID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG"

  FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_kunde

  ),





ldts_rsrc_data AS (

  SELECT
    "LDTS_SOURCE" AS ldts,
    CAST( "RSRC_SOURCE" as STRING ) AS rsrc,
      
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "KUNDEID",
        "KREDITKARTE",
        "GUELTIGBIS",
        "KKFIRMA",
        "VEREINSPARTNERID",
        "VORNAME",
        "NAME",
        "GESCHLECHT",
        "GEBURTSDATUM",
        "TELEFON",
        "MOBIL",
        "EMAIL",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_GEBURTSDATUM_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_KUNDEID_KEY_CHECK_OK",
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
        "KUNDEID",
        "KREDITKARTE",
        "GUELTIGBIS",
        "KKFIRMA",
        "VEREINSPARTNERID",
        "VORNAME",
        "NAME",
        "GESCHLECHT",
        "GEBURTSDATUM",
        "TELEFON",
        "MOBIL",
        "EMAIL",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_GEBURTSDATUM_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_KUNDEID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
  
  "VEREINSPARTNERID" AS "ASSOCIATIONPARTNER_BK",
    "KUNDEID" AS "CUSTOMER_BK",
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
        "KUNDEID",
        "KREDITKARTE",
        "GUELTIGBIS",
        "KKFIRMA",
        "VEREINSPARTNERID",
        "VORNAME",
        "NAME",
        "GESCHLECHT",
        "GEBURTSDATUM",
        "TELEFON",
        "MOBIL",
        "EMAIL",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_GEBURTSDATUM_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_KUNDEID_KEY_CHECK_OK",
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
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("KUNDEID" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
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
        , '\r', '') AS STRING), '^^||^^'))), '00000000000000000000000000000000') AS HK_CUSTOMER_ASSOCIATIONPARTNER_L,
    IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(UPPER(CONCAT(
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("EMAIL" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("GEBURTSDATUM" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("GESCHLECHT" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("GUELTIGBIS" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("KKFIRMA" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("KREDITKARTE" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("MOBIL" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("NAME" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("TELEFON" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST("VORNAME" AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
        )), '\n', '') 
        , '\t', '') 
        , '\v', '') 
        , '\r', '') AS STRING), '^^||^^||^^||^^||^^||^^||^^||^^||^^||^^'))), '00000000000000000000000000000000') AS HD_CUSTOMER_WS_S

    FROM derived_columns
  
),

unknown_values AS (
  
    SELECT

    TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') as ldts,
    'SYSTEM' as rsrc,
    
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "EDTS_IN",
        '(unknown)' AS RAW_DATA,
        0 AS ROW_NUMBER,
        '(unknown)' AS KUNDEID,
        '(unknown)' AS KREDITKARTE,
        '(unknown)' AS GUELTIGBIS,
        '(unknown)' AS KKFIRMA,
        '(unknown)' AS VEREINSPARTNERID,
        '(unknown)' AS VORNAME,
        '(unknown)' AS NAME,
        '(unknown)' AS GESCHLECHT,
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "GEBURTSDATUM",
        '(unknown)' AS TELEFON,
        '(unknown)' AS MOBIL,
        '(unknown)' AS EMAIL,
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_GEBURTSDATUM_TYPE_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_KUNDEID_KEY_CHECK_OK,
        CAST('FALSE' AS BOOLEAN) AS IS_CHECK_OK,
        NULL AS CHK_ALL_MSG
     ,
    
        '(unknown)' AS ASSOCIATIONPARTNER_BK,
        TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') AS CDTS,
        '(unknown)' AS CUSTOMER_BK,
        TO_DATE('0001-01-01', 'YYYY-mm-dd' ) as "EDTS",
        CAST('00000000000000000000000000000000' as STRING) as HK_ASSOCIATIONPARTNER_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_CUSTOMER_H,
        CAST('00000000000000000000000000000000' as STRING) as HK_CUSTOMER_ASSOCIATIONPARTNER_L,
        CAST('00000000000000000000000000000000' as STRING) as HD_CUSTOMER_WS_S
),


error_values AS (

    SELECT

    TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS') as ldts,
    'ERROR' as rsrc,
    
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "EDTS_IN",
        '(error)' AS RAW_DATA,
        -1 AS ROW_NUMBER
     ,
        '(error)' AS KUNDEID,
        '(error)' AS KREDITKARTE,
        '(error)' AS GUELTIGBIS,
        '(error)' AS KKFIRMA,
        '(error)' AS VEREINSPARTNERID,
        '(error)' AS VORNAME,
        '(error)' AS NAME,
        '(error)' AS GESCHLECHT,
        TO_DATE('8888-12-31', 'YYYY-mm-dd' ) as "GEBURTSDATUM",
        '(error)' AS TELEFON,
        '(error)' AS MOBIL,
        '(error)' AS EMAIL,
        CAST('FALSE' AS BOOLEAN) AS IS_LDTS_SOURCE_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_EDTS_IN_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_ROW_NUMBER_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_GEBURTSDATUM_TYPE_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_DUB_CHECK_OK
     ,
        CAST('FALSE' AS BOOLEAN) AS IS_KUNDEID_KEY_CHECK_OK
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
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HK_CUSTOMER_ASSOCIATIONPARTNER_L,
        CAST('ffffffffffffffffffffffffffffffff' as STRING) as HD_CUSTOMER_WS_S
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
        "KUNDEID",
        "KREDITKARTE",
        "GUELTIGBIS",
        "KKFIRMA",
        "VEREINSPARTNERID",
        "VORNAME",
        "NAME",
        "GESCHLECHT",
        "GEBURTSDATUM",
        "TELEFON",
        "MOBIL",
        "EMAIL",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_GEBURTSDATUM_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_KUNDEID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "ASSOCIATIONPARTNER_BK",
        "CUSTOMER_BK",
        "CDTS",
        "EDTS",
        "HK_ASSOCIATIONPARTNER_H",
        "HK_CUSTOMER_H",
        "HK_CUSTOMER_ASSOCIATIONPARTNER_L",
        "HD_CUSTOMER_WS_S"

    FROM hashed_columns

  
    UNION ALL
    
    SELECT

    
        "LDTS",
        "RSRC",
        "EDTS_IN",
        "RAW_DATA",
        "ROW_NUMBER",
        "KUNDEID",
        "KREDITKARTE",
        "GUELTIGBIS",
        "KKFIRMA",
        "VEREINSPARTNERID",
        "VORNAME",
        "NAME",
        "GESCHLECHT",
        "GEBURTSDATUM",
        "TELEFON",
        "MOBIL",
        "EMAIL",
        "IS_LDTS_SOURCE_TYPE_OK",
        "IS_EDTS_IN_TYPE_OK",
        "IS_ROW_NUMBER_TYPE_OK",
        "IS_GEBURTSDATUM_TYPE_OK",
        "IS_DUB_CHECK_OK",
        "IS_KUNDEID_KEY_CHECK_OK",
        "IS_CHECK_OK",
        "CHK_ALL_MSG",
        "ASSOCIATIONPARTNER_BK",
        "CUSTOMER_BK",
        "CDTS",
        "EDTS",
        "HK_ASSOCIATIONPARTNER_H",
        "HK_CUSTOMER_H",
        "HK_CUSTOMER_ASSOCIATIONPARTNER_L",
        "HD_CUSTOMER_WS_S"

    FROM ghost_records
  
)

SELECT * FROM columns_to_select
where is_check_ok or rsrc ='SYSTEM'