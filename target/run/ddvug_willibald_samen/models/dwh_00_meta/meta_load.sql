begin;
    
        
        
        delete from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_00_meta.meta_load
        where (ldts) in (
            select distinct ldts
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_00_meta.meta_load__dbt_tmp
        );

    

    insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_00_meta.meta_load ("TABLE_NAME", "FILE_LDTS", "ROWCOUNT", "LDTS")
    (
        select "TABLE_NAME", "FILE_LDTS", "ROWCOUNT", "LDTS"
        from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_00_meta.meta_load__dbt_tmp
    );
    commit;