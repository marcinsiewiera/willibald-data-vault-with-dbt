





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
        hk_delivery_l
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.delivery_nhl

    ),




src_new_1 AS (

    SELECT
            hk_delivery_l AS hk_delivery_l,
            hk_deliveryadress_h,
            hk_deliveryservice_h,
            hk_order_h,
            hk_position_h,
            ldts,
        rsrc,

        
           bestellungid,
           lieferdatum,
           posid

    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_webshop_lieferung src
    
    
    
        WHERE src.ldts > (
            SELECT MAX(ldts)
            FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.delivery_nhl
            WHERE ldts != TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')
            )

    ),

earliest_hk_over_all_sources AS (


    SELECT
        lcte.*
    FROM src_new_1 AS lcte

    QUALIFY ROW_NUMBER() OVER (PARTITION BY hk_delivery_l ORDER BY ldts) = 1),

records_to_insert AS (


    SELECT
        
            hk_delivery_l,
            hk_deliveryadress_h,
            hk_deliveryservice_h,
            hk_order_h,
            hk_position_h,
            ldts,
            rsrc,
            bestellungid,
            lieferdatum,
            posid
    FROM earliest_hk_over_all_sources
    WHERE hk_delivery_l NOT IN (SELECT * FROM distinct_target_hashkeys)
    
)

SELECT * FROM records_to_insert