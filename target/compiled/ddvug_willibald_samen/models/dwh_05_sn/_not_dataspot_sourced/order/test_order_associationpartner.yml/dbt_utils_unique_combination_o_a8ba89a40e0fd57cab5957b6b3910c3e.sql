





with validation_errors as (

    select
        hk_order_associationpartner_l, sdts
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.order_associationpartner_snp
    group by hk_order_associationpartner_l, sdts
    having count(*) > 1

)

select *
from validation_errors


