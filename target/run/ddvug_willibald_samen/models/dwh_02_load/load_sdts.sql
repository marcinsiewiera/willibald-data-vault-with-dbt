
  
    

        create or replace  table WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_sdts
         as
        (
SELECT  date_trunc(day,ldts_source) as sdts, True as is_active
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_misc_kategorie_termintreue
where is_check_ok
UNION 
SELECT date_trunc(day,ldts_source) as sdts, True as is_active
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_roadshow_bestellung
where is_check_ok
UNION 
SELECT date_trunc(day,ldts_source) as sdts,True as is_active
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_bestellung
where is_check_ok
UNION 
SELECT date_trunc(day,ldts_source) as sdts, True as is_active
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_kunde
where is_check_ok
UNION 
SELECT date_trunc(day,ldts_source) as sdts, True as is_active
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_lieferadresse
where is_check_ok
UNION 
SELECT date_trunc(day,ldts_source) as sdts, True as is_active
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_lieferdienst
where is_check_ok
UNION 
SELECT date_trunc(day,ldts_source) as sdts, True as is_active
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_lieferung
where is_check_ok
UNION 
SELECT date_trunc(day,ldts_source) as sdts, True as is_active
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_position
where is_check_ok
UNION 
SELECT date_trunc(day,ldts_source) as sdts, True as is_active
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_produkt
where is_check_ok
UNION 
SELECT date_trunc(day,ldts_source) as sdts, True as is_active
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_produktkategorie
where is_check_ok
UNION 
SELECT date_trunc(day,ldts_source) as sdts, True as is_active
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_ref_produkt_typ
where is_check_ok
UNION 
SELECT date_trunc(day,ldts_source) as sdts, True as is_active
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_vereinspartner
where is_check_ok
UNION 
SELECT date_trunc(day,ldts_source) as sdts, True as is_active
FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_wohnort
where is_check_ok
        );
      
  