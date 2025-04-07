-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.customer_snp ("TYPE", "RSRC", "HK_CUSTOMER_D", "HK_CUSTOMER_H", "SDTS", "HK_CUSTOMER_WS_LA_MS", "LDTS_CUSTOMER_WS_LA_MS", "HK_CUSTOMER_WS_S", "LDTS_CUSTOMER_WS_S", "HK_CUSTOMER_WS_STS", "LDTS_CUSTOMER_WS_STS")
        (
            select "TYPE", "RSRC", "HK_CUSTOMER_D", "HK_CUSTOMER_H", "SDTS", "HK_CUSTOMER_WS_LA_MS", "LDTS_CUSTOMER_WS_LA_MS", "HK_CUSTOMER_WS_S", "LDTS_CUSTOMER_WS_S", "HK_CUSTOMER_WS_STS", "LDTS_CUSTOMER_WS_STS"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.customer_snp__dbt_tmp
        );
    commit;