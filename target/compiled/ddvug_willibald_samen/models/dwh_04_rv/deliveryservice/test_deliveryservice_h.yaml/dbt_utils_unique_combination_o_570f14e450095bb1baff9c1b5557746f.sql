





with validation_errors as (

    select
        hk_deliveryservice_h
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryservice_h
    group by hk_deliveryservice_h
    having count(*) > 1

)

select *
from validation_errors


