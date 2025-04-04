select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select hk_order_h
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_ws_s
where hk_order_h is null



      
    ) dbt_internal_test