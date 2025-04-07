-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_h ("HK_DELIVERYADRESS_H", "DELIVERYADRESS_BK", "LDTS", "RSRC")
        (
            select "HK_DELIVERYADRESS_H", "DELIVERYADRESS_BK", "LDTS", "RSRC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_h__dbt_tmp
        );
    commit;