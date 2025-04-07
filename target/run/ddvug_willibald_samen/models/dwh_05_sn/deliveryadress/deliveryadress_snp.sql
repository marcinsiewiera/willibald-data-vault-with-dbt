-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.deliveryadress_snp ("TYPE", "RSRC", "HK_DELIVERYADRESS_D", "HK_DELIVERYADRESS_H", "SDTS", "HK_DELIVERYADRESS_WS_S", "LDTS_DELIVERYADRESS_WS_S")
        (
            select "TYPE", "RSRC", "HK_DELIVERYADRESS_D", "HK_DELIVERYADRESS_H", "SDTS", "HK_DELIVERYADRESS_WS_S", "LDTS_DELIVERYADRESS_WS_S"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.deliveryadress_snp__dbt_tmp
        );
    commit;