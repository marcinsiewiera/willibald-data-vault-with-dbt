select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

with child as (
    select hk_order_h as from_field
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_ws_s
    where hk_order_h is not null
),

parent as (
    select hk_order_h as to_field
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_h
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



      
    ) dbt_internal_test