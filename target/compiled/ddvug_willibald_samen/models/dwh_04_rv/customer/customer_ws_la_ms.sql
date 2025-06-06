



    
    WITH


source_data AS (

    SELECT
        hk_customer_h,
        hd_customer_ws_la_ms as hd_customer_ws_la_ms,
        
        rsrc,
        ldts,
        von,
        adresszusatz,
        bis,
        hausnummer,
        land,
        ort,
        plz,
        strasse
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_webshop_wohnort
    WHERE ldts > (
        SELECT
            MAX(ldts) FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_ws_la_ms
        WHERE ldts != TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')
    )

),


latest_entries_in_sat AS (

    SELECT
        hk_customer_h,
        hd_customer_ws_la_ms
    FROM 
        WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_ws_la_ms
    QUALIFY ROW_NUMBER() OVER(PARTITION BY hk_customer_h ORDER BY ldts DESC) = 1  
),


deduped_row_hashdiff AS (

  SELECT 
    hk_customer_h,
    ldts,
    hd_customer_ws_la_ms
  FROM source_data
  QUALIFY CASE
            WHEN hd_customer_ws_la_ms = LAG(hd_customer_ws_la_ms) OVER (PARTITION BY hk_customer_h ORDER BY ldts) THEN FALSE
            ELSE TRUE
          END
),


deduped_rows AS (

  SELECT 
    source_data.hk_customer_h,
    source_data.hd_customer_ws_la_ms,
    source_data.rsrc
        , source_data.ldts
        , source_data.von
        , source_data.adresszusatz
        , source_data.bis
        , source_data.hausnummer
        , source_data.land
        , source_data.ort
        , source_data.plz
        , source_data.strasse
        
  FROM source_data
  INNER JOIN deduped_row_hashdiff
    ON source_data.hk_customer_h = deduped_row_hashdiff.hk_customer_h
    AND source_data.ldts = deduped_row_hashdiff.ldts
    AND source_data.hd_customer_ws_la_ms = deduped_row_hashdiff.hd_customer_ws_la_ms

),

records_to_insert AS (

    SELECT
        deduped_rows.hk_customer_h,
        deduped_rows.hd_customer_ws_la_ms,
        deduped_rows.rsrc
        , deduped_rows.ldts
        , deduped_rows.von
        , deduped_rows.adresszusatz
        , deduped_rows.bis
        , deduped_rows.hausnummer
        , deduped_rows.land
        , deduped_rows.ort
        , deduped_rows.plz
        , deduped_rows.strasse
        
    FROM deduped_rows
    WHERE NOT EXISTS (
        SELECT 1
        FROM latest_entries_in_sat
        WHERE latest_entries_in_sat.hk_customer_h = deduped_rows.hk_customer_h
            AND latest_entries_in_sat.hd_customer_ws_la_ms = deduped_rows.hd_customer_ws_la_ms 
            )

    )

SELECT * FROM records_to_insert