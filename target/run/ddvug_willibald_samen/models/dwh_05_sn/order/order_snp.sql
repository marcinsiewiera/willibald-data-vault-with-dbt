-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.order_snp ("TYPE", "RSRC", "HK_ORDER_D", "HK_ORDER_H", "SDTS", "HK_ORDER_RS_STS", "LDTS_ORDER_RS_STS", "HK_ORDER_WS_S", "LDTS_ORDER_WS_S", "HK_ORDER_WS_STS", "LDTS_ORDER_WS_STS")
        (
            select "TYPE", "RSRC", "HK_ORDER_D", "HK_ORDER_H", "SDTS", "HK_ORDER_RS_STS", "LDTS_ORDER_RS_STS", "HK_ORDER_WS_S", "LDTS_ORDER_WS_S", "HK_ORDER_WS_STS", "LDTS_ORDER_WS_STS"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.order_snp__dbt_tmp
        );
    commit;