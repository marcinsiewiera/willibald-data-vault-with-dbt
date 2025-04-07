-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_h ("HK_CUSTOMER_H", "CUSTOMER_BK", "LDTS", "RSRC")
        (
            select "HK_CUSTOMER_H", "CUSTOMER_BK", "LDTS", "RSRC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_h__dbt_tmp
        );
    commit;