-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.associationpartner_customer_ws_sts ("HK_ASSOCIATIONPARTNER_CUSTOMER_L", "LDTS", "RSRC", "CDC")
        (
            select "HK_ASSOCIATIONPARTNER_CUSTOMER_L", "LDTS", "RSRC", "CDC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.associationpartner_customer_ws_sts__dbt_tmp
        );
    commit;