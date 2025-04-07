-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_position_l ("HK_ORDER_POSITION_L", "HK_POSITION_H", "HK_ORDER_H", "LDTS", "RSRC")
        (
            select "HK_ORDER_POSITION_L", "HK_POSITION_H", "HK_ORDER_H", "LDTS", "RSRC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_position_l__dbt_tmp
        );
    commit;