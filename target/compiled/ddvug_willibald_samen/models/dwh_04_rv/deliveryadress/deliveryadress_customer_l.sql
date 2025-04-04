







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





    src_new_1 AS (

        SELECT
            hk_deliveryadress_customer_l AS hk_deliveryadress_customer_l,
            hk_deliveryadress_h,
            hk_customer_h,
            ldts,
            rsrc
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_webshop_lieferadresse src
        

    ),

earliest_hk_over_all_sources AS (
    

    SELECT
        lcte.*
    FROM src_new_1 AS lcte

    QUALIFY ROW_NUMBER() OVER (PARTITION BY hk_deliveryadress_customer_l ORDER BY ldts) = 1),

records_to_insert AS (
    

    SELECT
        
            hk_deliveryadress_customer_l,
            hk_deliveryadress_h,
            hk_customer_h,
            ldts,
            rsrc
    FROM earliest_hk_over_all_sources
)

SELECT * FROM records_to_insert