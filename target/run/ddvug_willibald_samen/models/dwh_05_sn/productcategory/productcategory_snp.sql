-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.productcategory_snp ("TYPE", "RSRC", "HK_PRODUCTCATEGORY_D", "HK_PRODUCTCATEGORY_H", "SDTS", "HK_PRODUCTCATEGORY_WS_S", "LDTS_PRODUCTCATEGORY_WS_S")
        (
            select "TYPE", "RSRC", "HK_PRODUCTCATEGORY_D", "HK_PRODUCTCATEGORY_H", "SDTS", "HK_PRODUCTCATEGORY_WS_S", "LDTS_PRODUCTCATEGORY_WS_S"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.productcategory_snp__dbt_tmp
        );
    commit;