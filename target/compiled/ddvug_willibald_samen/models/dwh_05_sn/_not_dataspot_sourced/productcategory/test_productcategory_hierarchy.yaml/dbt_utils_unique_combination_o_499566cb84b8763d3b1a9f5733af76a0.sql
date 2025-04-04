





with validation_errors as (

    select
        hk_productcategory_hierarchy_l, sdts
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.productcategory_hierarchy_snp
    group by hk_productcategory_hierarchy_l, sdts
    having count(*) > 1

)

select *
from validation_errors


