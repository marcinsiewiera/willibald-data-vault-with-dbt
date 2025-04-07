-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_associationpartner_l ("HK_CUSTOMER_ASSOCIATIONPARTNER_L", "HK_CUSTOMER_H", "HK_ASSOCIATIONPARTNER_H", "LDTS", "RSRC")
        (
            select "HK_CUSTOMER_ASSOCIATIONPARTNER_L", "HK_CUSTOMER_H", "HK_ASSOCIATIONPARTNER_H", "LDTS", "RSRC"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_associationpartner_l__dbt_tmp
        );
    commit;