
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_07_inmt.fact_error
  
    
    
(
  
    "RSRC" COMMENT $$$$, 
  
    "ERROR_TYPE" COMMENT $$$$, 
  
    "ERROR_ROW_NUMBER" COMMENT $$$$, 
  
    "SOURCE_SYSTEM" COMMENT $$$$, 
  
    "CHK_ALL_MSG" COMMENT $$$$, 
  
    "ERROR_RAW" COMMENT $$$$
  
)

   as (
    with cte_error_sats as
(
    select hk_error_h, hd_error_s, rsrc, ldts, raw_data, to_varchar(chk_all_msg) AS chk_all_msg, 'Misc' as source_system
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_err.error_msc_s msc
    where not rsrc in ('SYSTEM','ERROR')
    union
    select hk_error_h, hd_error_s, rsrc, ldts, raw_data, to_varchar(chk_all_msg) AS chk_all_msg, 'WebShop' as source_system
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_err.error_ws_s ws
    where not rsrc in ('SYSTEM','ERROR')
    union 
    select hk_error_h, hd_error_s, rsrc, ldts, raw_data, to_varchar(chk_all_msg) AS chk_all_msg, 'RoadShow' as source_system
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_err.error_rs_s rs
    where not rsrc in ('SYSTEM','ERROR')
)
select    error_file_bk as rsrc
        , case 
            when trim(lower(chk_all_msg)) like '%key_check%' and trim(lower(chk_all_msg)) like '%dub_check%' then 'Key-Error/Duplicate'
            when trim(lower(chk_all_msg)) like '%dub_check%' then 'Duplicate'
            when trim(lower(chk_all_msg)) like '%key_check%' then 'Key-Error'
            else 'Type-Error'
          end as error_type   
        , try_to_number(error_row_no_bk, 18,0) as error_row_number
        , source_system
        , replace(replace(lower(chk_all_msg), '; duplicate',''), '; key-error','') as chk_all_msg
        , raw_data as error_raw
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_err.error_h h
left join cte_error_sats s
    on h.hk_error_h = s.hk_error_h
where not h.rsrc in ('SYSTEM','ERROR')
  );

