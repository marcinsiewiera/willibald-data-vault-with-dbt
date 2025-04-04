
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.control_snap_v1
  
    
    
(
  
    "SDTS" COMMENT $$$$, 
  
    "REPLACEMENT_SDTS" COMMENT $$$$, 
  
    "CAPTION" COMMENT $$$$, 
  
    "IS_HOURLY" COMMENT $$$$, 
  
    "IS_DAILY" COMMENT $$$$, 
  
    "IS_WEEKLY" COMMENT $$$$, 
  
    "IS_MONTHLY" COMMENT $$$$, 
  
    "IS_YEARLY" COMMENT $$$$, 
  
    "IS_CURRENT_YEAR" COMMENT $$$$, 
  
    "IS_LAST_YEAR" COMMENT $$$$, 
  
    "IS_ROLLING_YEAR" COMMENT $$$$, 
  
    "IS_LAST_ROLLING_YEAR" COMMENT $$$$, 
  
    "COMMENT" COMMENT $$$$, 
  
    "REPLACEMENT_ESDTS" COMMENT $$$$, 
  
    "IS_LATEST" COMMENT $$$$, 
  
    "IS_ACTIVE" COMMENT $$$$
  
)

   as (
    with control_snap_v1 as
(
WITH 

latest_row AS (

    SELECT
        sdts
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.control_snap_v0
    ORDER BY sdts DESC
    LIMIT 1

), 

virtual_logic AS (
    
    SELECT
        c.sdts,
        c.replacement_sdts,
        c.force_active,
        CASE 
            WHEN
            (DATE_TRUNC('DAY', c.sdts::DATE) BETWEEN CURRENT_DATE() - INTERVAL '7 DAY' AND CURRENT_DATE()) OR            
              ((DATE_TRUNC('DAY', c.sdts::DATE) BETWEEN CURRENT_DATE() - INTERVAL '0 YEAR' AND CURRENT_DATE()) AND (c.is_weekly = TRUE)) OR            
              ((DATE_TRUNC('DAY', c.sdts::DATE) BETWEEN CURRENT_DATE() - INTERVAL '1 YEAR' AND CURRENT_DATE()) AND (c.is_monthly = TRUE)) OR
              (c.is_yearly = TRUE)
            THEN TRUE
            ELSE FALSE
        END AS is_active,

        CASE
            WHEN l.sdts IS NULL THEN FALSE
            ELSE TRUE
        END AS is_latest,

        c.caption,
        c.is_hourly,
        c.is_daily,
        c.is_weekly,
        c.is_monthly,
        c.is_yearly,
        CASE
            WHEN EXTRACT(YEAR FROM c.sdts) = EXTRACT(YEAR FROM CURRENT_DATE()) THEN TRUE
            ELSE FALSE
        END AS is_current_year,
        CASE
            WHEN EXTRACT(YEAR FROM c.sdts) = EXTRACT(YEAR FROM CURRENT_DATE())-1 THEN TRUE
            ELSE FALSE
        END AS is_last_year,
        CASE
            WHEN DATE_TRUNC('DAY', c.sdts::DATE) BETWEEN (CURRENT_DATE() - INTERVAL '1 YEAR') AND CURRENT_DATE() THEN TRUE
            ELSE FALSE
        END AS is_rolling_year,
        CASE
            WHEN DATE_TRUNC('DAY', c.sdts::DATE) BETWEEN (CURRENT_DATE() - INTERVAL '2 YEAR') AND (CURRENT_DATE() - INTERVAL '1 YEAR') THEN TRUE
            ELSE FALSE
        END AS is_last_rolling_year,
        c.comment
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.control_snap_v0 c
    LEFT JOIN latest_row l
    ON c.sdts = l.sdts
),

active_logic_combined AS (

    SELECT 
        sdts,
        replacement_sdts,
        CASE
            WHEN force_active AND is_active THEN TRUE
            WHEN NOT force_active OR NOT is_active THEN FALSE
        END AS is_active,
        is_latest, 
        caption,
        is_hourly,
        is_daily,
        is_weekly,
        is_monthly,
        is_yearly,
        is_current_year,
        is_last_year,
        is_rolling_year,
        is_last_rolling_year,
        comment
    FROM virtual_logic

)

SELECT * FROM active_logic_combined
),
load_sdts as
(
    select sdts, 
            max(sdts) over () = sdts as is_latest
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_sdts
),
cte_esdts as
(
    select * 
        , COALESCE(LEAD(replacement_sdts - INTERVAL '1 MICROSECOND') OVER ( ORDER BY  replacement_sdts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) AS replacement_esdts
    from control_snap_v1
)
select    cte_esdts.* exclude (is_latest, is_active)  
        , l.is_latest
        , true as is_active
from load_sdts l
left join cte_esdts
    on l.sdts between cte_esdts.replacement_sdts and cte_esdts.replacement_esdts
  );

