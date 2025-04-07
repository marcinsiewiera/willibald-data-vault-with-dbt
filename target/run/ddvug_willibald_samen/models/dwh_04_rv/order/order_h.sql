-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_h ("HK_ORDER_H", "ORDER_BK", "LDTS", "RSRC")
        (
            select "HK_ORDER_H", "ORDER_BK", "LDTS", "RSRC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_h__dbt_tmp
        );
    commit;