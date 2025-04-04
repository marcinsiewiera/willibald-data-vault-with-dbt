
  
    

        create or replace  table WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.control_snap_v0
         as
        (with s0data as
(
WITH 

initial_timestamps AS (
    
    SELECT
        DATEADD(DAY, SEQ4(), 
        TIMESTAMPADD(SECOND, EXTRACT(SECOND FROM TO_TIME('23:59:59')), 
            TIMESTAMPADD(MINUTE, EXTRACT(MINUTE FROM TO_TIME('23:59:59')), 
                TIMESTAMPADD(HOUR, EXTRACT(HOUR FROM TO_TIME('23:59:59')), TO_DATE('2022-01-01', 'YYYY-MM-DD')))
                ))::TIMESTAMP AS sdts
    FROM 
        TABLE(GENERATOR(ROWCOUNT => 100000))
    WHERE 
        sdts <= CURRENT_TIMESTAMP

),

enriched_timestamps AS (

    SELECT
        sdts as sdts,
        TRUE as force_active,
        sdts AS replacement_sdts,
        CONCAT('Snapshot ', DATE(sdts)) AS caption,
        CASE
            WHEN EXTRACT(MINUTE FROM sdts) = 0 AND EXTRACT(SECOND FROM sdts) = 0 THEN TRUE
            ELSE FALSE
        END AS is_hourly,
        CASE
            WHEN EXTRACT(MINUTE FROM sdts) = 0 AND EXTRACT(SECOND FROM sdts) = 0 AND EXTRACT(HOUR FROM sdts) = 0 THEN TRUE
            ELSE FALSE
        END AS is_daily,
        CASE
            WHEN EXTRACT(DAYOFWEEK FROM  sdts) = 1 THEN TRUE
            ELSE FALSE
        END AS is_weekly,
        CASE
            WHEN EXTRACT(DAY FROM sdts) = 1 THEN TRUE
            ELSE FALSE
        END AS is_monthly,
        CASE
            WHEN EXTRACT(DAY FROM sdts) = 1 AND EXTRACT(MONTH FROM sdts) = 1 THEN TRUE
            ELSE FALSE
        END AS is_yearly,
        NULL AS comment
    FROM initial_timestamps

)

SELECT * FROM enriched_timestamps 
)
select    date_trunc(day, sdts) as replacement_sdts
        , * exclude replacement_sdts
       
from s0data                               
where sdts  < dateadd(day, 1, date_trunc(day, sysdate()))
        );
      
  