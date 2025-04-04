
  
    

        create or replace  table WILLIBALD_DATA_VAULT_WITH_DBT.dwh_07_inmt.dim_associationpartner
         as
        (
select 
hk_associationpartner_d
, associationpartner_bk
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.associationpartner_sns
        );
      
  