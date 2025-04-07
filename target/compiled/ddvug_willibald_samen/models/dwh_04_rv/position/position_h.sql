








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


    distinct_target_hashkeys AS (

        SELECT
            hk_position_h
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_h

    ),
         

            

            rsrc_static_1 AS (SELECT 
                    t.*,
                    '*/roadshow/bestellung/*' AS rsrc_static
                    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_h t
                    WHERE rsrc like '*/roadshow/bestellung/*'),
         

            

            rsrc_static_2 AS (SELECT 
                    t.*,
                    '*/webshop/lieferung/*' AS rsrc_static
                    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_h t
                    WHERE rsrc like '*/webshop/lieferung/*'),
         

            

            rsrc_static_3 AS (SELECT 
                    t.*,
                    '*/webshop/position/*' AS rsrc_static
                    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_h t
                    WHERE rsrc like '*/webshop/position/*'),

        rsrc_static_union AS (
            
            SELECT rsrc_static_1.* FROM rsrc_static_1
            UNION ALL
            SELECT rsrc_static_2.* FROM rsrc_static_2
            UNION ALL
            SELECT rsrc_static_3.* FROM rsrc_static_3),

        max_ldts_per_rsrc_static_in_target AS (
        
            SELECT
                rsrc_static,
                MAX(ldts) as max_ldts
            FROM rsrc_static_union
            WHERE ldts != TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')
            GROUP BY rsrc_static

        ),


    src_new_1 AS (

        SELECT
            hk_position_h AS hk_position_h,
            position_bk,
            ldts,
            rsrc
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_roadshow_bestellung src
        

    ),

    src_new_2 AS (

        SELECT
            hk_position_h AS hk_position_h,
            position_bk,
            ldts,
            rsrc
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_webshop_lieferung src
        

    ),

    src_new_3 AS (

        SELECT
            hk_position_h AS hk_position_h,
            position_bk,
            ldts,
            rsrc
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_webshop_position src
        

    ),

source_new_union AS (SELECT
        hk_position_h,

        position_bk AS position_bk,
        ldts,
        rsrc
    FROM src_new_1
    UNION ALL
    SELECT
        hk_position_h,

        position_bk AS position_bk,
        ldts,
        rsrc
    FROM src_new_2
    UNION ALL
    SELECT
        hk_position_h,

        position_bk AS position_bk,
        ldts,
        rsrc
    FROM src_new_3),

earliest_hk_over_all_sources AS (
    SELECT
        lcte.*
    FROM source_new_union AS lcte

    QUALIFY ROW_NUMBER() OVER (PARTITION BY hk_position_h ORDER BY ldts) = 1),

records_to_insert AS (
    SELECT
        
        hk_position_h,
        position_bk,
        ldts,
        rsrc
    FROM earliest_hk_over_all_sources
    WHERE hk_position_h NOT IN (SELECT * FROM distinct_target_hashkeys)
    )

SELECT * FROM records_to_insert