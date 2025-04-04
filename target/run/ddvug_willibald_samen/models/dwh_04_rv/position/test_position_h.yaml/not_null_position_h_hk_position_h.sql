select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select hk_position_h
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_h
where hk_position_h is null



      
    ) dbt_internal_test