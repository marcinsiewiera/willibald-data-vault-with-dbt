





with validation_errors as (

    select
        hk_deliveryservice_h, ldts
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryservice_ws_s
    group by hk_deliveryservice_h, ldts
    having count(*) > 1

)

select *
from validation_errors


