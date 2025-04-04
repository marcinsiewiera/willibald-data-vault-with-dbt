





with validation_errors as (

    select
        hk_associationpartner_h
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.associationpartner_h
    group by hk_associationpartner_h
    having count(*) > 1

)

select *
from validation_errors


