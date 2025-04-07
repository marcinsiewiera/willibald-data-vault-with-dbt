



    
    
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
        hk_product_h,
        hd_product_ws_s as hd_product_ws_s,
        
        rsrc,
        ldts,
        bezeichnung,
        pflanzabstand,
        pflanzort,
        preis,
        typ,
        umfang
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_webshop_produkt
    WHERE ldts > (
        SELECT
            MAX(ldts) FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_ws_s
        WHERE ldts != TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')
    )
),


latest_entries_in_sat AS (

    SELECT
        hk_product_h,
        hd_product_ws_s
    FROM 
        WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_ws_s
    QUALIFY ROW_NUMBER() OVER(PARTITION BY hk_product_h ORDER BY ldts DESC) = 1  
),


deduplicated_numbered_source AS (

    SELECT
    hk_product_h,
    hd_product_ws_s,
    
        rsrc,
        ldts,
        bezeichnung,
        pflanzabstand,
        pflanzort,
        preis,
        typ,
        umfang
    , ROW_NUMBER() OVER(PARTITION BY hk_product_h ORDER BY ldts) as rn
    FROM source_data
    QUALIFY
        CASE
            WHEN hd_product_ws_s = LAG(hd_product_ws_s) OVER(PARTITION BY hk_product_h ORDER BY ldts) THEN FALSE
            ELSE TRUE
        END
),


records_to_insert AS (

    SELECT
    hk_product_h,
    hd_product_ws_s,
    
        rsrc,
        ldts,
        bezeichnung,
        pflanzabstand,
        pflanzort,
        preis,
        typ,
        umfang
    FROM deduplicated_numbered_source
    WHERE NOT EXISTS (
        SELECT 1
        FROM latest_entries_in_sat
        WHERE latest_entries_in_sat.hk_product_h = deduplicated_numbered_source.hk_product_h
            AND latest_entries_in_sat.hd_product_ws_s = deduplicated_numbered_source.hd_product_ws_s
            AND deduplicated_numbered_source.rn = 1)

    )

SELECT * FROM records_to_insert