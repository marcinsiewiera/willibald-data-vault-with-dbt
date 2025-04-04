





with validation_errors as (

    select
        hk_productcategory_h, hk_product_h, sdts
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.product_productcategory_sns
    group by hk_productcategory_h, hk_product_h, sdts
    having count(*) > 1

)

select *
from validation_errors


