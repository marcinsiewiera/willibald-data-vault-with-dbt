





with validation_errors as (

    select
        hk_position_product_l, sdts
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.position_product_snp
    group by hk_position_product_l, sdts
    having count(*) > 1

)

select *
from validation_errors


