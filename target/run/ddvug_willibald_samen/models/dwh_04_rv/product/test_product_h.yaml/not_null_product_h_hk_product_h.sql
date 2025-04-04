select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select hk_product_h
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_h
where hk_product_h is null



      
    ) dbt_internal_test