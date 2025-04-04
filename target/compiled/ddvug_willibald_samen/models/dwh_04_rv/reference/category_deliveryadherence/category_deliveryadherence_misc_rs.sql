





    
    
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
        
        category_deliveryadherence_nk,
        
        hd_category_deliveryadherence_misc_rs as hd_category_deliveryadherence_misc_rs,
        
        rsrc,
        ldts,
        count_days_from,
        count_days_to,
        name
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_misc_kategorie_termintreue
),




deduplicated_numbered_source AS (

    SELECT
    
    category_deliveryadherence_nk,
    
    hd_category_deliveryadherence_misc_rs,
    
        rsrc,
        ldts,
        count_days_from,
        count_days_to,
        name
    
    FROM source_data
    QUALIFY
        CASE
            WHEN hd_category_deliveryadherence_misc_rs = LAG(hd_category_deliveryadherence_misc_rs) OVER(PARTITION BY category_deliveryadherence_nk ORDER BY ldts) THEN FALSE
            ELSE TRUE
        END
),


records_to_insert AS (

    SELECT
    
    category_deliveryadherence_nk,
    
    hd_category_deliveryadherence_misc_rs,
    
        rsrc,
        ldts,
        count_days_from,
        count_days_to,
        name
    FROM deduplicated_numbered_source

    )

SELECT * FROM records_to_insert