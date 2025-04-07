-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_productcategory_ws_sts ("HK_PRODUCT_PRODUCTCATEGORY_L", "LDTS", "RSRC", "CDC")
        (
            select "HK_PRODUCT_PRODUCTCATEGORY_L", "LDTS", "RSRC", "CDC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_productcategory_ws_sts__dbt_tmp
        );
    commit;