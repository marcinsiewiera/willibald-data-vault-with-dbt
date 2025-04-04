





with validation_errors as (

    select
        hk_deliveryadress_h, hk_customer_h
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_customer_l
    group by hk_deliveryadress_h, hk_customer_h
    having count(*) > 1

)

select *
from validation_errors


