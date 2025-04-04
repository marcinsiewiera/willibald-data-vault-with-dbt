





with validation_errors as (

    select
        hk_order_h, sdts
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.order_sns
    group by hk_order_h, sdts
    having count(*) > 1

)

select *
from validation_errors


