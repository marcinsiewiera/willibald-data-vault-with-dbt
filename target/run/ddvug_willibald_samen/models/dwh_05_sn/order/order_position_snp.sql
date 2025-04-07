-- back compat for old kwarg name
  
  begin;
    

        insert into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.order_position_snp ("TYPE", "RSRC", "HK_ORDER_POSITION_D", "HK_ORDER_POSITION_L", "SDTS", "HK_ORDER_POSITION_RS_STS", "LDTS_ORDER_POSITION_RS_STS", "HK_ORDER_POSITION_WS_STS", "LDTS_ORDER_POSITION_WS_STS")
        (
            select "TYPE", "RSRC", "HK_ORDER_POSITION_D", "HK_ORDER_POSITION_L", "SDTS", "HK_ORDER_POSITION_RS_STS", "LDTS_ORDER_POSITION_RS_STS", "HK_ORDER_POSITION_WS_STS", "LDTS_ORDER_POSITION_WS_STS"
            from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.order_position_snp__dbt_tmp
        );
    commit;