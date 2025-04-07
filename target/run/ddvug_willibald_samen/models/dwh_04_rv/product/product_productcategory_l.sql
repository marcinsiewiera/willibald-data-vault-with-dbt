-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_productcategory_l ("HK_PRODUCT_PRODUCTCATEGORY_L", "HK_PRODUCTCATEGORY_H", "HK_PRODUCT_H", "LDTS", "RSRC")
        (
            select "HK_PRODUCT_PRODUCTCATEGORY_L", "HK_PRODUCTCATEGORY_H", "HK_PRODUCT_H", "LDTS", "RSRC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_productcategory_l__dbt_tmp
        );
    commit;