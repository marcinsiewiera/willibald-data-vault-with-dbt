-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.productcategory_hierarchy_l ("HK_PRODUCTCATEGORY_HIERARCHY_L", "HK_PRODUCTCATEGORY_PARENT_H", "HK_PRODUCTCATEGORY_H", "LDTS", "RSRC")
        (
            select "HK_PRODUCTCATEGORY_HIERARCHY_L", "HK_PRODUCTCATEGORY_PARENT_H", "HK_PRODUCTCATEGORY_H", "LDTS", "RSRC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.productcategory_hierarchy_l__dbt_tmp
        );
    commit;