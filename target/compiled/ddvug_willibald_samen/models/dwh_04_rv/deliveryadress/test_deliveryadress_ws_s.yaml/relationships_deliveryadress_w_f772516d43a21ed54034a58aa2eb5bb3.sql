
    
    

with child as (
    select hk_deliveryadress_h as from_field
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_ws_s
    where hk_deliveryadress_h is not null
),

parent as (
    select hk_deliveryadress_h as to_field
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_h
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


