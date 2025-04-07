-- back compat for old kwarg name
  
  begin;
    
        
            
                
                
            
                
                
            
        
    

    

    merge into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_ws_s as DBT_INTERNAL_DEST
        using WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_ws_s__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.hk_position_h = DBT_INTERNAL_DEST.hk_position_h
                ) and (
                    DBT_INTERNAL_SOURCE.ldts = DBT_INTERNAL_DEST.ldts
                )

    
    when matched then update set
        "HK_POSITION_H" = DBT_INTERNAL_SOURCE."HK_POSITION_H","HD_POSITION_WS_S" = DBT_INTERNAL_SOURCE."HD_POSITION_WS_S","RSRC" = DBT_INTERNAL_SOURCE."RSRC","LDTS" = DBT_INTERNAL_SOURCE."LDTS","BESTELLUNGID" = DBT_INTERNAL_SOURCE."BESTELLUNGID","MENGE" = DBT_INTERNAL_SOURCE."MENGE","POSID" = DBT_INTERNAL_SOURCE."POSID","PREIS" = DBT_INTERNAL_SOURCE."PREIS","SPEZLIEFERADRID" = DBT_INTERNAL_SOURCE."SPEZLIEFERADRID"
    

    when not matched then insert
        ("HK_POSITION_H", "HD_POSITION_WS_S", "RSRC", "LDTS", "BESTELLUNGID", "MENGE", "POSID", "PREIS", "SPEZLIEFERADRID")
    values
        ("HK_POSITION_H", "HD_POSITION_WS_S", "RSRC", "LDTS", "BESTELLUNGID", "MENGE", "POSID", "PREIS", "SPEZLIEFERADRID")

;
    commit;