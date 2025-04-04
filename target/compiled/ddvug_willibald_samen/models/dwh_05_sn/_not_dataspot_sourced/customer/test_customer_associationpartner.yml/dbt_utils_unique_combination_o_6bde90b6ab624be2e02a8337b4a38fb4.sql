





with validation_errors as (

    select
        hk_customer_associationpartner_l, sdts
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.customer_associationpartner_snp
    group by hk_customer_associationpartner_l, sdts
    having count(*) > 1

)

select *
from validation_errors


