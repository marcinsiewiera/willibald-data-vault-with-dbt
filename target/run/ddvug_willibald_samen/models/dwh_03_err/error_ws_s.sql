-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_err.error_ws_s ("HK_ERROR_H", "HD_ERROR_S", "RSRC", "LDTS", "RAW_DATA", "CHK_ALL_MSG")
        (
            select "HK_ERROR_H", "HD_ERROR_S", "RSRC", "LDTS", "RAW_DATA", "CHK_ALL_MSG"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_err.error_ws_s__dbt_tmp
        );
    commit;