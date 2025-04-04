





with validation_errors as (

    select
        hk_associationpartner_h, sdts
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.associationpartner_snp
    group by hk_associationpartner_h, sdts
    having count(*) > 1

)

select *
from validation_errors


