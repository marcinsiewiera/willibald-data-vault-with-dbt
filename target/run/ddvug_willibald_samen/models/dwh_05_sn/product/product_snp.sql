-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.product_snp ("TYPE", "RSRC", "HK_PRODUCT_D", "HK_PRODUCT_H", "SDTS", "HK_PRODUCT_WS_S", "LDTS_PRODUCT_WS_S", "HK_PRODUCT_WS_STS", "LDTS_PRODUCT_WS_STS")
        (
            select "TYPE", "RSRC", "HK_PRODUCT_D", "HK_PRODUCT_H", "SDTS", "HK_PRODUCT_WS_S", "LDTS_PRODUCT_WS_S", "HK_PRODUCT_WS_STS", "LDTS_PRODUCT_WS_STS"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.product_snp__dbt_tmp
        );
    commit;