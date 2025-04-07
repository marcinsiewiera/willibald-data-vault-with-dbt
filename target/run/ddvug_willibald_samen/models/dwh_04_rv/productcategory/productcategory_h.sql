-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.productcategory_h ("HK_PRODUCTCATEGORY_H", "PRODUCTCATEGORY_BK", "LDTS", "RSRC")
        (
            select "HK_PRODUCTCATEGORY_H", "PRODUCTCATEGORY_BK", "LDTS", "RSRC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.productcategory_h__dbt_tmp
        );
    commit;