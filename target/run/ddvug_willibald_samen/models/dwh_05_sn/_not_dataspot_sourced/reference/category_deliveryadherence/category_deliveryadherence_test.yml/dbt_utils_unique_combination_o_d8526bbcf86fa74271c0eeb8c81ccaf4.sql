select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      





with validation_errors as (

    select
        category_deliveryadherence_nk, sdts
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.category_deliveryadherence_sns
    group by category_deliveryadherence_nk, sdts
    having count(*) > 1

)

select *
from validation_errors



      
    ) dbt_internal_test