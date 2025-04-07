-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_err.error_h ("HK_ERROR_H", "ERROR_ROW_NO_BK", "ERROR_FILE_BK", "LDTS", "RSRC")
        (
            select "HK_ERROR_H", "ERROR_ROW_NO_BK", "ERROR_FILE_BK", "LDTS", "RSRC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_err.error_h__dbt_tmp
        );
    commit;