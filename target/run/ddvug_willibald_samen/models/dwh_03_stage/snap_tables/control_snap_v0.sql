-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.control_snap_v0 ("REPLACEMENT_SDTS", "SDTS", "FORCE_ACTIVE", "CAPTION", "IS_HOURLY", "IS_DAILY", "IS_WEEKLY", "IS_MONTHLY", "IS_YEARLY", "COMMENT")
        (
            select "REPLACEMENT_SDTS", "SDTS", "FORCE_ACTIVE", "CAPTION", "IS_HOURLY", "IS_DAILY", "IS_WEEKLY", "IS_MONTHLY", "IS_YEARLY", "COMMENT"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.control_snap_v0__dbt_tmp
        );
    commit;