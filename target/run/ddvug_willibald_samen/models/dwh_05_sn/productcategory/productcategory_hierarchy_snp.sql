-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.productcategory_hierarchy_snp ("TYPE", "RSRC", "HK_PRODUCTCATEGORY_HIERARCHY_D", "HK_PRODUCTCATEGORY_HIERARCHY_L", "SDTS", "HK_PRODUCTCATEGORY_HIERARCHY_WS_STS", "LDTS_PRODUCTCATEGORY_HIERARCHY_WS_STS")
        (
            select "TYPE", "RSRC", "HK_PRODUCTCATEGORY_HIERARCHY_D", "HK_PRODUCTCATEGORY_HIERARCHY_L", "SDTS", "HK_PRODUCTCATEGORY_HIERARCHY_WS_STS", "LDTS_PRODUCTCATEGORY_HIERARCHY_WS_STS"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.productcategory_hierarchy_snp__dbt_tmp
        );
    commit;