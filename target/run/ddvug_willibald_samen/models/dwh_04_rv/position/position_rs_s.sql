-- back compat for old kwarg name
  
  begin;
    
        
            
                
                
            
                
                
            
        
    

    

    merge into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_rs_s as DBT_INTERNAL_DEST
        using WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_rs_s__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.hk_position_h = DBT_INTERNAL_DEST.hk_position_h
                ) and (
                    DBT_INTERNAL_SOURCE.ldts = DBT_INTERNAL_DEST.ldts
                )

    
    when matched then update set
        "HK_POSITION_H" = DBT_INTERNAL_SOURCE."HK_POSITION_H","HD_POSITION_RS_S" = DBT_INTERNAL_SOURCE."HD_POSITION_RS_S","RSRC" = DBT_INTERNAL_SOURCE."RSRC","LDTS" = DBT_INTERNAL_SOURCE."LDTS","BESTELLUNGID" = DBT_INTERNAL_SOURCE."BESTELLUNGID","GUELTIGBIS" = DBT_INTERNAL_SOURCE."GUELTIGBIS","KAUFDATUM" = DBT_INTERNAL_SOURCE."KAUFDATUM","KKFIRMA" = DBT_INTERNAL_SOURCE."KKFIRMA","KREDITKARTE" = DBT_INTERNAL_SOURCE."KREDITKARTE","MENGE" = DBT_INTERNAL_SOURCE."MENGE","PREIS" = DBT_INTERNAL_SOURCE."PREIS","PRODUKTID" = DBT_INTERNAL_SOURCE."PRODUKTID","RABATT" = DBT_INTERNAL_SOURCE."RABATT"
    

    when not matched then insert
        ("HK_POSITION_H", "HD_POSITION_RS_S", "RSRC", "LDTS", "BESTELLUNGID", "GUELTIGBIS", "KAUFDATUM", "KKFIRMA", "KREDITKARTE", "MENGE", "PREIS", "PRODUKTID", "RABATT")
    values
        ("HK_POSITION_H", "HD_POSITION_RS_S", "RSRC", "LDTS", "BESTELLUNGID", "GUELTIGBIS", "KAUFDATUM", "KKFIRMA", "KREDITKARTE", "MENGE", "PREIS", "PRODUKTID", "RABATT")

;
    commit;