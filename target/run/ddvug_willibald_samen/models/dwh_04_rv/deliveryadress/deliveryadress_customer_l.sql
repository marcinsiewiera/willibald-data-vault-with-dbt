-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_customer_l ("HK_DELIVERYADRESS_CUSTOMER_L", "HK_DELIVERYADRESS_H", "HK_CUSTOMER_H", "LDTS", "RSRC")
        (
            select "HK_DELIVERYADRESS_CUSTOMER_L", "HK_DELIVERYADRESS_H", "HK_CUSTOMER_H", "LDTS", "RSRC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_customer_l__dbt_tmp
        );
    commit;