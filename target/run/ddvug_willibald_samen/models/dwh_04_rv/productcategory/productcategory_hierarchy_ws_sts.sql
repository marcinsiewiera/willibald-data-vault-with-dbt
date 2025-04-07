-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.productcategory_hierarchy_ws_sts ("HK_PRODUCTCATEGORY_HIERARCHY_L", "LDTS", "RSRC", "CDC")
        (
            select "HK_PRODUCTCATEGORY_HIERARCHY_L", "LDTS", "RSRC", "CDC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.productcategory_hierarchy_ws_sts__dbt_tmp
        );
    commit;