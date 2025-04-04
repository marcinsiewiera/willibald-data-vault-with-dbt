





with validation_errors as (

    select
        hk_position_h
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_h
    group by hk_position_h
    having count(*) > 1

)

select *
from validation_errors


