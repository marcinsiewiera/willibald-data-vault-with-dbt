





with validation_errors as (

    select
        hk_order_customer_l, sdts
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.order_customer_snp
    group by hk_order_customer_l, sdts
    having count(*) > 1

)

select *
from validation_errors


