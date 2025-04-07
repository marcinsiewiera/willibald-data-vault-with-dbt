-- back compat for old kwarg name
  
  begin;
    
        
            
                
                
            
                
                
            
        
    

    

    merge into WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_ws_s as DBT_INTERNAL_DEST
        using WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_ws_s__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE.hk_customer_h = DBT_INTERNAL_DEST.hk_customer_h
                ) and (
                    DBT_INTERNAL_SOURCE.ldts = DBT_INTERNAL_DEST.ldts
                )

    
    when matched then update set
        "HK_CUSTOMER_H" = DBT_INTERNAL_SOURCE."HK_CUSTOMER_H","HD_CUSTOMER_WS_S" = DBT_INTERNAL_SOURCE."HD_CUSTOMER_WS_S","RSRC" = DBT_INTERNAL_SOURCE."RSRC","LDTS" = DBT_INTERNAL_SOURCE."LDTS","EMAIL" = DBT_INTERNAL_SOURCE."EMAIL","GEBURTSDATUM" = DBT_INTERNAL_SOURCE."GEBURTSDATUM","GESCHLECHT" = DBT_INTERNAL_SOURCE."GESCHLECHT","GUELTIGBIS" = DBT_INTERNAL_SOURCE."GUELTIGBIS","KKFIRMA" = DBT_INTERNAL_SOURCE."KKFIRMA","KREDITKARTE" = DBT_INTERNAL_SOURCE."KREDITKARTE","MOBIL" = DBT_INTERNAL_SOURCE."MOBIL","NAME" = DBT_INTERNAL_SOURCE."NAME","TELEFON" = DBT_INTERNAL_SOURCE."TELEFON","VORNAME" = DBT_INTERNAL_SOURCE."VORNAME"
    

    when not matched then insert
        ("HK_CUSTOMER_H", "HD_CUSTOMER_WS_S", "RSRC", "LDTS", "EMAIL", "GEBURTSDATUM", "GESCHLECHT", "GUELTIGBIS", "KKFIRMA", "KREDITKARTE", "MOBIL", "NAME", "TELEFON", "VORNAME")
    values
        ("HK_CUSTOMER_H", "HD_CUSTOMER_WS_S", "RSRC", "LDTS", "EMAIL", "GEBURTSDATUM", "GESCHLECHT", "GUELTIGBIS", "KKFIRMA", "KREDITKARTE", "MOBIL", "NAME", "TELEFON", "VORNAME")

;
    commit;