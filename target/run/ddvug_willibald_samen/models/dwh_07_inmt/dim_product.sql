
  
    

        create or replace  table WILLIBALD_DATA_VAULT_WITH_DBT.dwh_07_inmt.dim_product
         as
        (
select 
hk_product_d 
, product_bk 
, bezeichnung 
, umfang 
, typ 
, preis
, pflanzort
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.product_sns
        );
      
  