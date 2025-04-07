-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_product_l ("HK_POSITION_PRODUCT_L", "HK_PRODUCT_H", "HK_POSITION_H", "LDTS", "RSRC")
        (
            select "HK_POSITION_PRODUCT_L", "HK_PRODUCT_H", "HK_POSITION_H", "LDTS", "RSRC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_product_l__dbt_tmp
        );
    commit;