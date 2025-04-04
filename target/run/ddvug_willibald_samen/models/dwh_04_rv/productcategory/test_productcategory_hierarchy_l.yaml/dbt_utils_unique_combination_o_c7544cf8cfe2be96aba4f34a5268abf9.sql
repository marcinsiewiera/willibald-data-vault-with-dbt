select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      





with validation_errors as (

    select
        hk_productcategory_parent_h, hk_productcategory_h
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.productcategory_hierarchy_l
    group by hk_productcategory_parent_h, hk_productcategory_h
    having count(*) > 1

)

select *
from validation_errors



      
    ) dbt_internal_test