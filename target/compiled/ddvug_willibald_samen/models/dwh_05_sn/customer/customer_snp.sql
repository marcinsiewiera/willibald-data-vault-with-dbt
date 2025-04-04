


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
        'PIT table for customer' as rsrc,
        IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
    IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST('Regular PIT' AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        
    IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST(te.hk_customer_h AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        
    IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST(snap.sdts AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
    ), '\n', '') 
    , '\t', '') 
    , '\v', '') 
    , '\r', '') AS STRING), '^^||^^||^^'))), '00000000000000000000000000000000') AS hk_customer_d ,
        te.hk_customer_h,
        snap.sdts,
            COALESCE(customer_ws_la_ms.hk_customer_h, CAST('00000000000000000000000000000000' as STRING)) AS hk_customer_ws_la_ms,
            COALESCE(customer_ws_la_ms.ldts, TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS')) AS ldts_customer_ws_la_ms,
            COALESCE(customer_ws_s.hk_customer_h, CAST('00000000000000000000000000000000' as STRING)) AS hk_customer_ws_s,
            COALESCE(customer_ws_s.ldts, TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS')) AS ldts_customer_ws_s,
            COALESCE(customer_ws_sts.hk_customer_h, CAST('00000000000000000000000000000000' as STRING)) AS hk_customer_ws_sts,
            COALESCE(customer_ws_sts.ldts, TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS')) AS ldts_customer_ws_sts

    FROM
            WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_h te
        FULL OUTER JOIN
            WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.control_snap_v1 snap
            ON snap.is_active = true
            
        
        LEFT JOIN (
            SELECT
                hk_customer_h,
                ldts,
                COALESCE(LEAD(ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY hk_customer_h ORDER BY ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) AS ledts
            FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_ws_la_ms
        ) customer_ws_la_ms
        
            ON
                customer_ws_la_ms.hk_customer_h = te.hk_customer_h
                AND snap.sdts BETWEEN customer_ws_la_ms.ldts AND customer_ws_la_ms.ledts
        
        LEFT JOIN (
            SELECT
                hk_customer_h,
                ldts,
                COALESCE(LEAD(ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY hk_customer_h ORDER BY ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) AS ledts
            FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_ws_s
        ) customer_ws_s
        
            ON
                customer_ws_s.hk_customer_h = te.hk_customer_h
                AND snap.sdts BETWEEN customer_ws_s.ldts AND customer_ws_s.ledts
        
        LEFT JOIN (
            SELECT
                hk_customer_h,
                ldts,
                COALESCE(LEAD(ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY hk_customer_h ORDER BY ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) AS ledts
            FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_ws_sts
        ) customer_ws_sts
        
            ON
                customer_ws_sts.hk_customer_h = te.hk_customer_h
                AND snap.sdts BETWEEN customer_ws_sts.ldts AND customer_ws_sts.ledts
        
    
        WHERE snap.is_active

),

records_to_insert AS (

    SELECT DISTINCT *
    FROM pit_records)

SELECT * FROM records_to_insert