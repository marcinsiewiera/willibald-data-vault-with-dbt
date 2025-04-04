select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      





with validation_errors as (

    select
        sdts, hk_productcategory_d
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_06_bv.productcategory_bs
    group by sdts, hk_productcategory_d
    having count(*) > 1

)

select *
from validation_errors



      
    ) dbt_internal_test