-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_product_ws_sts ("HK_POSITION_PRODUCT_L", "LDTS", "RSRC", "CDC")
        (
            select "HK_POSITION_PRODUCT_L", "LDTS", "RSRC", "CDC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_product_ws_sts__dbt_tmp
        );
    commit;