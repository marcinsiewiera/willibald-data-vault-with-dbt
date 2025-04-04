



    
    
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
        hk_position_h,
        hd_position_rs_s as hd_position_rs_s,
        
        rsrc,
        ldts,
        bestellungid,
        gueltigbis,
        kaufdatum,
        kkfirma,
        kreditkarte,
        menge,
        preis,
        produktid,
        rabatt
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_roadshow_bestellung
),




deduplicated_numbered_source AS (

    SELECT
    hk_position_h,
    hd_position_rs_s,
    
        rsrc,
        ldts,
        bestellungid,
        gueltigbis,
        kaufdatum,
        kkfirma,
        kreditkarte,
        menge,
        preis,
        produktid,
        rabatt
    
    FROM source_data
    QUALIFY
        CASE
            WHEN hd_position_rs_s = LAG(hd_position_rs_s) OVER(PARTITION BY hk_position_h ORDER BY ldts) THEN FALSE
            ELSE TRUE
        END
),


records_to_insert AS (

    SELECT
    hk_position_h,
    hd_position_rs_s,
    
        rsrc,
        ldts,
        bestellungid,
        gueltigbis,
        kaufdatum,
        kkfirma,
        kreditkarte,
        menge,
        preis,
        produktid,
        rabatt
    FROM deduplicated_numbered_source

    )

SELECT * FROM records_to_insert