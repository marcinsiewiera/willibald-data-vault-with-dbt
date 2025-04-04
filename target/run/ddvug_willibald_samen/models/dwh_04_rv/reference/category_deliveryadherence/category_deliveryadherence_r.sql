
  
    

        create or replace  table WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.category_deliveryadherence_r
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
            category_deliveryadherence_nk,
            ldts,
            rsrc
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_misc_kategorie_termintreue src

    ),

earliest_ref_key_over_all_sources AS (
    SELECT
        lcte.*
    FROM src_new_1 AS lcte

    QUALIFY ROW_NUMBER() OVER (PARTITION BY category_deliveryadherence_nk ORDER BY ldts) = 1),

records_to_insert AS (
    SELECT
        
        category_deliveryadherence_nk,
        ldts,
        rsrc
    FROM earliest_ref_key_over_all_sources)

SELECT * FROM records_to_insert
        );
      
  