
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.product_type_sns
  
    
    
(
  
    "PRODUCT_TYPE_NK" COMMENT $$$$, 
  
    "LDTS" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "BEZEICHNUNG" COMMENT $$$$
  
)

   as (
    select 
	  --control_snap_v1.sdts
	  product_type_ws_rs.product_type_nk
	, product_type_ws_rs.ldts 
	, product_type_ws_rs.rsrc
    , product_type_ws_rs.bezeichnung
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_type_ws_rs product_type_ws_rs
  );

