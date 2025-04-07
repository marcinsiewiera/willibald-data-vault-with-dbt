-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryservice_h ("HK_DELIVERYSERVICE_H", "DELIVERYSERVICE_BK", "LDTS", "RSRC")
        (
            select "HK_DELIVERYSERVICE_H", "DELIVERYSERVICE_BK", "LDTS", "RSRC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryservice_h__dbt_tmp
        );
    commit;