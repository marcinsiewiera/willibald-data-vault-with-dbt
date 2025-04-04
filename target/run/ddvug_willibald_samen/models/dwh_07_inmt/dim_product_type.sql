
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_07_inmt.dim_product_type
  
    
    
(
  
    "PRODUCT_TYPE_NK" COMMENT $$$$, 
  
    "LDTS" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "BEZEICHNUNG" COMMENT $$$$
  
)

   as (
    
SELECT  *
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.product_type_sns s
  );

