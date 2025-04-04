
  
    

        create or replace  table WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_err.error_ws_s
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


source_data AS (

    SELECT
        hk_error_h,
        hd_error_s as hd_error_s,
        
        rsrc,
        ldts,
        raw_data,
        chk_all_msg
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_err.stg_error_webshop
),




deduplicated_numbered_source AS (

    SELECT
    hk_error_h,
    hd_error_s,
    
        rsrc,
        ldts,
        raw_data,
        chk_all_msg
    
    FROM source_data
    QUALIFY
        CASE
            WHEN hd_error_s = LAG(hd_error_s) OVER(PARTITION BY hk_error_h ORDER BY ldts) THEN FALSE
            ELSE TRUE
        END
),


records_to_insert AS (

    SELECT
    hk_error_h,
    hd_error_s,
    
        rsrc,
        ldts,
        raw_data,
        chk_all_msg
    FROM deduplicated_numbered_source

    )

SELECT * FROM records_to_insert
        );
      
  