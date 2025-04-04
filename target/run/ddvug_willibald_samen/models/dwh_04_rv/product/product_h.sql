
  
    

        create or replace  table WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_h
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



    src_new_1 AS (

        SELECT
            hk_product_h AS hk_product_h,
            product_bk,
            ldts,
            rsrc
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_roadshow_bestellung src
        

    ),

    src_new_2 AS (

        SELECT
            hk_product_h AS hk_product_h,
            product_bk,
            ldts,
            rsrc
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_webshop_position src
        

    ),

    src_new_3 AS (

        SELECT
            hk_product_h AS hk_product_h,
            product_bk,
            ldts,
            rsrc
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_webshop_produkt src
        

    ),

source_new_union AS (SELECT
        hk_product_h,

        product_bk AS product_bk,
        ldts,
        rsrc
    FROM src_new_1
    UNION ALL
    SELECT
        hk_product_h,

        product_bk AS product_bk,
        ldts,
        rsrc
    FROM src_new_2
    UNION ALL
    SELECT
        hk_product_h,

        product_bk AS product_bk,
        ldts,
        rsrc
    FROM src_new_3),

earliest_hk_over_all_sources AS (
    SELECT
        lcte.*
    FROM source_new_union AS lcte

    QUALIFY ROW_NUMBER() OVER (PARTITION BY hk_product_h ORDER BY ldts) = 1),

records_to_insert AS (
    SELECT
        
        hk_product_h,
        product_bk,
        ldts,
        rsrc
    FROM earliest_hk_over_all_sources)

SELECT * FROM records_to_insert
        );
      
  