select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select hk_productcategory_h
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.productcategory_ws_s
where hk_productcategory_h is null



      
    ) dbt_internal_test