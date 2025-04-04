





with validation_errors as (

    select
        hk_productcategory_h, ldts
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.productcategory_ws_s
    group by hk_productcategory_h, ldts
    having count(*) > 1

)

select *
from validation_errors


