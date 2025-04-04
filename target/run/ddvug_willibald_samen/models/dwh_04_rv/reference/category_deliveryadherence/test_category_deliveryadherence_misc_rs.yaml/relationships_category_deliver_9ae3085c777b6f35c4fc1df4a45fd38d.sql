select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

with child as (
    select category_deliveryadherence_nk as from_field
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.category_deliveryadherence_misc_rs
    where category_deliveryadherence_nk is not null
),

parent as (
    select category_deliveryadherence_nk as to_field
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.category_deliveryadherence_r
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



      
    ) dbt_internal_test