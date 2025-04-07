begin;
    
        
        
        delete from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_sdts
        where (sdts) in (
            select distinct sdts
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_sdts__dbt_tmp
        );

    

    insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_sdts ("SDTS", "IS_ACTIVE")
    (
        select "SDTS", "IS_ACTIVE"
        from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_sdts__dbt_tmp
    );
    commit;