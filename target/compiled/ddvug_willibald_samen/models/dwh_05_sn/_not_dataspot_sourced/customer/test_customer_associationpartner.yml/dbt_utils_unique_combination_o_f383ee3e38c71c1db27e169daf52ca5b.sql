





with validation_errors as (

    select
        hk_customer_h, hk_associationpartner_h, sdts
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.customer_associationpartner_sns
    group by hk_customer_h, hk_associationpartner_h, sdts
    having count(*) > 1

)

select *
from validation_errors


