





with validation_errors as (

    select
        category_deliveryadherence_nk, ldts
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.category_deliveryadherence_misc_rs
    group by category_deliveryadherence_nk, ldts
    having count(*) > 1

)

select *
from validation_errors


