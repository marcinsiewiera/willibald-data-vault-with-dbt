





with validation_errors as (

    select
        hk_customer_h
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_h
    group by hk_customer_h
    having count(*) > 1

)

select *
from validation_errors


