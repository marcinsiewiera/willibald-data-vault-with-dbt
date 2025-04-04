
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_err.pre_stg_error_misc
  
    
    
(
  
    "ROW_NUMBER" COMMENT $$$$, 
  
    "LDTS" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "RAW_DATA" COMMENT $$$$, 
  
    "CHK_ALL_MSG" COMMENT $$$$, 
  
    "IS_CHECK_OK" COMMENT $$$$
  
)

   as (
    select ROW_NUMBER, ldts_source as LDTS, rsrc_source as RSRC, raw_data, CHK_ALL_MSG, true as IS_CHECK_OK
from  WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_misc_kategorie_termintreue
where not is_check_ok
  );

