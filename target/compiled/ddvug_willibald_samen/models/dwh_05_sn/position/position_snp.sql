


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
        hk_position_d
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.position_snp

),

pit_records AS (

    SELECT
        
        '"REGULAR PIT"' as type,
        'PIT table for position' as rsrc,
        IFNULL(LOWER(MD5(NULLIF(CAST(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(CONCAT(
    IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST('Regular PIT' AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        
    IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST(te.hk_position_h AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^'),'||',
        
    IFNULL((CONCAT('\"', REPLACE(REPLACE(REPLACE(TRIM(CAST(snap.sdts AS STRING)), '\\', '\\\\'), '"', '\"'), '^^', '--'), '\"')), '^^')
    ), '\n', '') 
    , '\t', '') 
    , '\v', '') 
    , '\r', '') AS STRING), '^^||^^||^^'))), '00000000000000000000000000000000') AS hk_position_d ,
        te.hk_position_h,
        snap.sdts,
            COALESCE(position_rs_s.hk_position_h, CAST('00000000000000000000000000000000' as STRING)) AS hk_position_rs_s,
            COALESCE(position_rs_s.ldts, TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS')) AS ldts_position_rs_s,
            COALESCE(position_rs_sts.hk_position_h, CAST('00000000000000000000000000000000' as STRING)) AS hk_position_rs_sts,
            COALESCE(position_rs_sts.ldts, TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS')) AS ldts_position_rs_sts,
            COALESCE(position_ws_s.hk_position_h, CAST('00000000000000000000000000000000' as STRING)) AS hk_position_ws_s,
            COALESCE(position_ws_s.ldts, TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS')) AS ldts_position_ws_s,
            COALESCE(position_ws_sts.hk_position_h, CAST('00000000000000000000000000000000' as STRING)) AS hk_position_ws_sts,
            COALESCE(position_ws_sts.ldts, TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS')) AS ldts_position_ws_sts

    FROM
            WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_h te
        FULL OUTER JOIN
            WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.control_snap_v1 snap
            ON snap.is_active = true
            
        
        LEFT JOIN (
            SELECT
                hk_position_h,
                ldts,
                COALESCE(LEAD(ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY hk_position_h ORDER BY ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) AS ledts
            FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_rs_s
        ) position_rs_s
        
            ON
                position_rs_s.hk_position_h = te.hk_position_h
                AND snap.sdts BETWEEN position_rs_s.ldts AND position_rs_s.ledts
        
        LEFT JOIN (
            SELECT
                hk_position_h,
                ldts,
                COALESCE(LEAD(ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY hk_position_h ORDER BY ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) AS ledts
            FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_rs_sts
        ) position_rs_sts
        
            ON
                position_rs_sts.hk_position_h = te.hk_position_h
                AND snap.sdts BETWEEN position_rs_sts.ldts AND position_rs_sts.ledts
        
        LEFT JOIN (
            SELECT
                hk_position_h,
                ldts,
                COALESCE(LEAD(ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY hk_position_h ORDER BY ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) AS ledts
            FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_ws_s
        ) position_ws_s
        
            ON
                position_ws_s.hk_position_h = te.hk_position_h
                AND snap.sdts BETWEEN position_ws_s.ldts AND position_ws_s.ledts
        
        LEFT JOIN (
            SELECT
                hk_position_h,
                ldts,
                COALESCE(LEAD(ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY hk_position_h ORDER BY ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) AS ledts
            FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_ws_sts
        ) position_ws_sts
        
            ON
                position_ws_sts.hk_position_h = te.hk_position_h
                AND snap.sdts BETWEEN position_ws_sts.ldts AND position_ws_sts.ledts
        
    
        WHERE snap.is_active

),

records_to_insert AS (

    SELECT DISTINCT *
    FROM pit_records
    WHERE hk_position_d NOT IN (SELECT * FROM existing_dimension_keys)
    )

SELECT * FROM records_to_insert