-- back compat for old kwarg name
  
  begin;
    
        
            
                
                
            
                
                
            
        
    

    

    merge into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.associationpartner_ws_s as DBT_INTERNAL_DEST
        using WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.associationpartner_ws_s__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.hk_associationpartner_h = DBT_INTERNAL_DEST.hk_associationpartner_h
                ) and (
                    DBT_INTERNAL_SOURCE.ldts = DBT_INTERNAL_DEST.ldts
                )

    
    when matched then update set
        "HK_ASSOCIATIONPARTNER_H" = DBT_INTERNAL_SOURCE."HK_ASSOCIATIONPARTNER_H","HD_ASSOCIATIONPARTNER_WS_S" = DBT_INTERNAL_SOURCE."HD_ASSOCIATIONPARTNER_WS_S","RSRC" = DBT_INTERNAL_SOURCE."RSRC","LDTS" = DBT_INTERNAL_SOURCE."LDTS","KUNDEIDVEREIN" = DBT_INTERNAL_SOURCE."KUNDEIDVEREIN","RABATT1" = DBT_INTERNAL_SOURCE."RABATT1","RABATT2" = DBT_INTERNAL_SOURCE."RABATT2","RABATT3" = DBT_INTERNAL_SOURCE."RABATT3"
    

    when not matched then insert
        ("HK_ASSOCIATIONPARTNER_H", "HD_ASSOCIATIONPARTNER_WS_S", "RSRC", "LDTS", "KUNDEIDVEREIN", "RABATT1", "RABATT2", "RABATT3")
    values
        ("HK_ASSOCIATIONPARTNER_H", "HD_ASSOCIATIONPARTNER_WS_S", "RSRC", "LDTS", "KUNDEIDVEREIN", "RABATT1", "RABATT2", "RABATT3")

;
    commit;