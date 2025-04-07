-- back compat for old kwarg name
  
  begin;
    
        
            
                
                
            
                
                
            
        
    

    

    merge into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_ws_s as DBT_INTERNAL_DEST
        using WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_ws_s__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.hk_deliveryadress_h = DBT_INTERNAL_DEST.hk_deliveryadress_h
                ) and (
                    DBT_INTERNAL_SOURCE.ldts = DBT_INTERNAL_DEST.ldts
                )

    
    when matched then update set
        "HK_DELIVERYADRESS_H" = DBT_INTERNAL_SOURCE."HK_DELIVERYADRESS_H","HD_DELIVERYADRESS_WS_S" = DBT_INTERNAL_SOURCE."HD_DELIVERYADRESS_WS_S","RSRC" = DBT_INTERNAL_SOURCE."RSRC","LDTS" = DBT_INTERNAL_SOURCE."LDTS","ADRESSZUSATZ" = DBT_INTERNAL_SOURCE."ADRESSZUSATZ","HAUSNUMMER" = DBT_INTERNAL_SOURCE."HAUSNUMMER","LAND" = DBT_INTERNAL_SOURCE."LAND","ORT" = DBT_INTERNAL_SOURCE."ORT","PLZ" = DBT_INTERNAL_SOURCE."PLZ","STRASSE" = DBT_INTERNAL_SOURCE."STRASSE"
    

    when not matched then insert
        ("HK_DELIVERYADRESS_H", "HD_DELIVERYADRESS_WS_S", "RSRC", "LDTS", "ADRESSZUSATZ", "HAUSNUMMER", "LAND", "ORT", "PLZ", "STRASSE")
    values
        ("HK_DELIVERYADRESS_H", "HD_DELIVERYADRESS_WS_S", "RSRC", "LDTS", "ADRESSZUSATZ", "HAUSNUMMER", "LAND", "ORT", "PLZ", "STRASSE")

;
    commit;