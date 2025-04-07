-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.associationpartner_customer_l ("HK_ASSOCIATIONPARTNER_CUSTOMER_L", "HK_CUSTOMER_H", "HK_ASSOCIATIONPARTNER_H", "LDTS", "RSRC")
        (
            select "HK_ASSOCIATIONPARTNER_CUSTOMER_L", "HK_CUSTOMER_H", "HK_ASSOCIATIONPARTNER_H", "LDTS", "RSRC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.associationpartner_customer_l__dbt_tmp
        );
    commit;