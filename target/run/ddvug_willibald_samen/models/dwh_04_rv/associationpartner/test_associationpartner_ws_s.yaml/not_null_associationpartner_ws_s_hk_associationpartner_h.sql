select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select hk_associationpartner_h
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.associationpartner_ws_s
where hk_associationpartner_h is null



      
    ) dbt_internal_test