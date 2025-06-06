


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

existing_dimension_keys AS (

    SELECT
        hk_order_associationpartner_d
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.order_associationpartner_snp

),

pit_records AS (

    SELECT
        
        '"REGULAR PIT"' as type,
        'PIT table for order_associationpartner' as rsrc,
        IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
    IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST('Regular PIT' AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        
    IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST(te.hk_order_associationpartner_l AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        
    IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST(snap.sdts AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
    ), '\n', '') 
    , '\t', '') 
    , '\v', '') 
    , '\r', '') AS STRING), '^^||^^||^^'))), '00000000000000000000000000000000') AS hk_order_associationpartner_d ,
        te.hk_order_associationpartner_l,
        snap.sdts,
            COALESCE(order_associationpartner_rs_es.hk_order_associationpartner_l, CAST('00000000000000000000000000000000' as STRING)) AS hk_order_associationpartner_rs_es,
            COALESCE(order_associationpartner_rs_es.ldts, TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS')) AS ldts_order_associationpartner_rs_es,
            COALESCE(order_associationpartner_rs_sts.hk_order_associationpartner_l, CAST('00000000000000000000000000000000' as STRING)) AS hk_order_associationpartner_rs_sts,
            COALESCE(order_associationpartner_rs_sts.ldts, TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS')) AS ldts_order_associationpartner_rs_sts

    FROM
            WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_associationpartner_l te
        FULL OUTER JOIN
            WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.control_snap_v1 snap
            ON snap.is_active = true
            
        
        LEFT JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_associationpartner_rs_es
            ON
                order_associationpartner_rs_es.hk_order_associationpartner_l = te.hk_order_associationpartner_l
                AND snap.sdts BETWEEN order_associationpartner_rs_es.ldts AND order_associationpartner_rs_es.ledts
        
        LEFT JOIN (
            SELECT
                hk_order_associationpartner_l,
                ldts,
                COALESCE(LEAD(ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY hk_order_associationpartner_l ORDER BY ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) AS ledts
            FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_associationpartner_rs_sts
        ) order_associationpartner_rs_sts
        
            ON
                order_associationpartner_rs_sts.hk_order_associationpartner_l = te.hk_order_associationpartner_l
                AND snap.sdts BETWEEN order_associationpartner_rs_sts.ldts AND order_associationpartner_rs_sts.ledts
        
    
        WHERE snap.is_active

),

records_to_insert AS (

    SELECT DISTINCT *
    FROM pit_records
    WHERE hk_order_associationpartner_d NOT IN (SELECT * FROM existing_dimension_keys)
    )

SELECT * FROM records_to_insert