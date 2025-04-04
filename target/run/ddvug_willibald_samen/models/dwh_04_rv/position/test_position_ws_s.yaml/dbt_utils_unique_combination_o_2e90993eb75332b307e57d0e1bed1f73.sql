select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      





with validation_errors as (

    select
        hk_position_h, ldts
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_ws_s
    group by hk_position_h, ldts
    having count(*) > 1

)

select *
from validation_errors



      
    ) dbt_internal_test