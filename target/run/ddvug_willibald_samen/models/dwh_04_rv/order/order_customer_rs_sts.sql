-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_customer_rs_sts ("HK_ORDER_CUSTOMER_L", "LDTS", "RSRC", "CDC")
        (
            select "HK_ORDER_CUSTOMER_L", "LDTS", "RSRC", "CDC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_customer_rs_sts__dbt_tmp
        );
    commit;