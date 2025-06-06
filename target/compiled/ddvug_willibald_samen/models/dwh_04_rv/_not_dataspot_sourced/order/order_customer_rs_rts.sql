
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



    distinct_concated_target AS (

        SELECT
        CONCAT(hk_order_customer_l,'||',ldts,'||',rsrc
) as concat
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_customer_rs_rts
    ),
src_new_1 AS (
            SELECT DISTINCT
                hk_order_customer_l AS hk_order_customer_l,
                ldts,
                CAST(rsrc AS STRING) AS rsrc,
                CAST(UPPER('stg_roadshow_bestellung') AS STRING) AS stg
            FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_roadshow_bestellung src
                WHERE src.ldts > (
            SELECT MAX(ldts)
            FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_customer_rs_rts
            WHERE ldts != TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')
            )
        ),





records_to_insert AS (

    SELECT
    
        hk_order_customer_l,
        ldts,
        rsrc,
        stg
    FROM src_new_1
    WHERE ldts != TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS') 
    AND ldts != TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS')
        AND CONCAT(hk_order_customer_l,'||',ldts,'||',rsrc
) NOT IN (SELECT * FROM distinct_concated_target)
    
)

SELECT * FROM records_to_insert
                                