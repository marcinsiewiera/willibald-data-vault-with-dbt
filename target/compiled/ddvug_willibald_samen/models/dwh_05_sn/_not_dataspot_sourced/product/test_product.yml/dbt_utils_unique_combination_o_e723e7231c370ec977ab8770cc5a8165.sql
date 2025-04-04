





with validation_errors as (

    select
        hk_product_h, sdts
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.product_snp
    group by hk_product_h, sdts
    having count(*) > 1

)

select *
from validation_errors


