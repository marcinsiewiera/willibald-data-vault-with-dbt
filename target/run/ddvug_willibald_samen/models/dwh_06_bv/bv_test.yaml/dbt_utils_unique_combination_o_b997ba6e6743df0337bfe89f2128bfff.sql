select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      





with validation_errors as (

    select
        reporting_date, hk_order_h, hk_position_h
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_06_bv.sales_bb
    group by reporting_date, hk_order_h, hk_position_h
    having count(*) > 1

)

select *
from validation_errors



      
    ) dbt_internal_test