
  
    

        create or replace  table WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.customer_associationpartner_snp
         as
        (


-----------------------------------------------------------------------------------------------
--                                                                                      ( )  --
--                                                                                     //    --
--                                                                               ( )=( o )   --
--  #####   #####     #    #       ####### ####### ######  ####### #######             \\    --
-- #     # #     #   # #   #       #       #       #     # #       #                    ( )  --
-- #       #        #   #  #       #       #       #     # #       #                         --
--  #####  #       #     # #       #####   #####   ######  #####   #####                     --
--       # #       ####### #       #       #       #   #   #       #                         --
-- #     # #     # #     # #       #       #       #    #  #       #                         --
--  #####   #####  #     # ####### ####### #       #     # ####### #######                   --
-----------------------------------------------------------------------------------------------
--              Generated by datavault4dbt by Scalefree International GmbH                   --
-----------------------------------------------------------------------------------------------

WITH

pit_records AS (

    SELECT
        
        '"REGULAR PIT"' as type,
        'PIT table for customer_associationpartner' as rsrc,
        IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
    IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST('Regular PIT' AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        
    IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST(te.hk_customer_associationpartner_l AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        
    IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST(snap.sdts AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
    ), '\n', '') 
    , '\t', '') 
    , '\v', '') 
    , '\r', '') AS STRING), '^^||^^||^^'))), '00000000000000000000000000000000') AS hk_customer_associationpartner_d ,
        te.hk_customer_associationpartner_l,
        snap.sdts,
            COALESCE(customer_associationpartner_ws_es.hk_customer_associationpartner_l, CAST('00000000000000000000000000000000' as STRING)) AS hk_customer_associationpartner_ws_es,
            COALESCE(customer_associationpartner_ws_es.ldts, TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS')) AS ldts_customer_associationpartner_ws_es,
            COALESCE(customer_associationpartner_ws_sts.hk_customer_associationpartner_l, CAST('00000000000000000000000000000000' as STRING)) AS hk_customer_associationpartner_ws_sts,
            COALESCE(customer_associationpartner_ws_sts.ldts, TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS')) AS ldts_customer_associationpartner_ws_sts

    FROM
            WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_associationpartner_l te
        FULL OUTER JOIN
            WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.control_snap_v1 snap
            ON snap.is_active = true
            
        
        LEFT JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_associationpartner_ws_es
            ON
                customer_associationpartner_ws_es.hk_customer_associationpartner_l = te.hk_customer_associationpartner_l
                AND snap.sdts BETWEEN customer_associationpartner_ws_es.ldts AND customer_associationpartner_ws_es.ledts
        
        LEFT JOIN (
            SELECT
                hk_customer_associationpartner_l,
                ldts,
                COALESCE(LEAD(ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY hk_customer_associationpartner_l ORDER BY ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) AS ledts
            FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_associationpartner_ws_sts
        ) customer_associationpartner_ws_sts
        
            ON
                customer_associationpartner_ws_sts.hk_customer_associationpartner_l = te.hk_customer_associationpartner_l
                AND snap.sdts BETWEEN customer_associationpartner_ws_sts.ldts AND customer_associationpartner_ws_sts.ledts
        
    
        WHERE snap.is_active

),

records_to_insert AS (

    SELECT DISTINCT *
    FROM pit_records)

SELECT * FROM records_to_insert
        );
      
  