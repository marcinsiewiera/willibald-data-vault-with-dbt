-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_h ("HK_POSITION_H", "POSITION_BK", "LDTS", "RSRC")
        (
            select "HK_POSITION_H", "POSITION_BK", "LDTS", "RSRC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_h__dbt_tmp
        );
    commit;