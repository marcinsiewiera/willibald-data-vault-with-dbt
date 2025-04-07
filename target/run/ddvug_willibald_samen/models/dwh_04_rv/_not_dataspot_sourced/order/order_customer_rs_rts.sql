-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_customer_rs_rts ("HK_ORDER_CUSTOMER_L", "LDTS", "RSRC", "STG")
        (
            select "HK_ORDER_CUSTOMER_L", "LDTS", "RSRC", "STG"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_customer_rs_rts__dbt_tmp
        );
    commit;