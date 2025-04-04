select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select hk_productcategory_d
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_06_bv.productcategory_bs
where hk_productcategory_d is null



      
    ) dbt_internal_test