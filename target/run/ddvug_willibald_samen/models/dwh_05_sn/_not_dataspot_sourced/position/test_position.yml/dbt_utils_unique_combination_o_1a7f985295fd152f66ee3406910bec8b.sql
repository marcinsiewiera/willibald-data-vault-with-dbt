select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      





with validation_errors as (

    select
        hk_position_h, sdts
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.position_sns
    group by hk_position_h, sdts
    having count(*) > 1

)

select *
from validation_errors



      
    ) dbt_internal_test