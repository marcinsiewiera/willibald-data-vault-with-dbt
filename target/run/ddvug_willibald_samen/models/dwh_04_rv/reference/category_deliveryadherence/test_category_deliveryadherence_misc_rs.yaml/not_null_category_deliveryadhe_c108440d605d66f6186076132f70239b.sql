select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select category_deliveryadherence_nk
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.category_deliveryadherence_misc_rs
where category_deliveryadherence_nk is null



      
    ) dbt_internal_test