







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
        hk_product_productcategory_l
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_productcategory_l

    ),
        

            rsrc_static_1 AS (SELECT t.*,
                    '*/webshop/produkt/*' AS rsrc_static
                    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_productcategory_l t
                    WHERE rsrc like '*/webshop/produkt/*'),

        max_ldts_per_rsrc_static_in_target AS (
        

            SELECT
                rsrc_static,
                MAX(ldts) as max_ldts
            FROM rsrc_static_1
            WHERE ldts != TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')
            GROUP BY rsrc_static

        ),




    src_new_1 AS (

        SELECT
            hk_product_productcategory_l AS hk_product_productcategory_l,
            hk_productcategory_h,
            hk_product_h,
            ldts,
            rsrc
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_webshop_produkt src
        

    ),

earliest_hk_over_all_sources AS (
    

    SELECT
        lcte.*
    FROM src_new_1 AS lcte

    QUALIFY ROW_NUMBER() OVER (PARTITION BY hk_product_productcategory_l ORDER BY ldts) = 1),

records_to_insert AS (
    

    SELECT
        
            hk_product_productcategory_l,
            hk_productcategory_h,
            hk_product_h,
            ldts,
            rsrc
    FROM earliest_hk_over_all_sources
    WHERE hk_product_productcategory_l NOT IN (SELECT * FROM distinct_target_hashkeys)
    
)

SELECT * FROM records_to_insert