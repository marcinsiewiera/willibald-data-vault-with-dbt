





with validation_errors as (

    select
        hk_position_h, hk_order_h
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_position_l
    group by hk_position_h, hk_order_h
    having count(*) > 1

)

select *
from validation_errors


