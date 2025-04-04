
  
    

        create or replace  table WILLIBALD_DATA_VAULT_WITH_DBT.dwh_00_meta.meta_load
         as
        (
with current_date as
(
    SELECT SYSDATE() as ldts
)
SELECT 'load_misc_kategorie_termintreue' as table_name, l.file_ldts, coalesce(l.rowcount, 0) as rowcount, ldts
FROM current_date 
LEFT JOIN (select ldts_source as file_ldts, count(*) as rowcount from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_misc_kategorie_termintreue where is_check_ok group by ldts_source  ) l
    ON 1=1
UNION ALL
SELECT 'load_roadshow_bestellung' as table_name, l.file_ldts, coalesce(l.rowcount, 0) as rowcount, ldts
FROM current_date 
LEFT JOIN (select ldts_source as file_ldts, count(*) as rowcount from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_roadshow_bestellung where is_check_ok group by ldts_source  ) l
    ON 1=1
UNION ALL
SELECT 'load_webshop_bestellung' as table_name, l.file_ldts, coalesce(l.rowcount, 0) as rowcount, ldts
FROM current_date 
LEFT JOIN (select ldts_source as file_ldts, count(*) as rowcount from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_bestellung where is_check_ok group by ldts_source  ) l
    ON 1=1
UNION ALL
SELECT 'load_webshop_kunde' as table_name, l.file_ldts, coalesce(l.rowcount, 0) as rowcount, ldts
FROM current_date 
LEFT JOIN (select ldts_source as file_ldts, count(*) as rowcount from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_kunde where is_check_ok group by ldts_source  ) l
    ON 1=1
UNION ALL
SELECT 'load_webshop_lieferadresse' as table_name, l.file_ldts, coalesce(l.rowcount, 0) as rowcount, ldts
FROM current_date 
LEFT JOIN (select ldts_source as file_ldts, count(*) as rowcount from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_lieferadresse where is_check_ok group by ldts_source  ) l
    ON 1=1
UNION ALL
SELECT 'load_webshop_lieferdienst' as table_name, l.file_ldts, coalesce(l.rowcount, 0) as rowcount, ldts
FROM current_date 
LEFT JOIN (select ldts_source as file_ldts, count(*) as rowcount from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_lieferdienst where is_check_ok group by ldts_source  ) l
    ON 1=1
UNION ALL
SELECT 'load_webshop_lieferung' as table_name, l.file_ldts, coalesce(l.rowcount, 0) as rowcount, ldts
FROM current_date 
LEFT JOIN (select ldts_source as file_ldts, count(*) as rowcount from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_lieferung where is_check_ok group by ldts_source  ) l
    ON 1=1
UNION ALL
SELECT 'load_webshop_position' as table_name, l.file_ldts, coalesce(l.rowcount, 0) as rowcount, ldts
FROM current_date 
LEFT JOIN (select ldts_source as file_ldts, count(*) as rowcount from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_position where is_check_ok group by ldts_source  ) l
    ON 1=1
UNION ALL
SELECT 'load_webshop_produkt' as table_name, l.file_ldts, coalesce(l.rowcount, 0) as rowcount, ldts
FROM current_date 
LEFT JOIN (select ldts_source as file_ldts, count(*) as rowcount from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_produkt where is_check_ok group by ldts_source  ) l
    ON 1=1
UNION ALL
SELECT 'load_webshop_produktkategorie' as table_name, l.file_ldts, coalesce(l.rowcount, 0) as rowcount, ldts
FROM current_date 
LEFT JOIN (select ldts_source as file_ldts, count(*) as rowcount from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_produktkategorie where is_check_ok group by ldts_source  ) l
    ON 1=1
UNION ALL
SELECT 'load_webshop_ref_produkt_typ' as table_name, l.file_ldts, coalesce(l.rowcount, 0) as rowcount, ldts
FROM current_date 
LEFT JOIN (select ldts_source as file_ldts, count(*) as rowcount from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_ref_produkt_typ where is_check_ok group by ldts_source  ) l
    ON 1=1
UNION ALL
SELECT 'load_webshop_vereinspartner' as table_name, l.file_ldts, coalesce(l.rowcount, 0) as rowcount, ldts
FROM current_date 
LEFT JOIN (select ldts_source as file_ldts, count(*) as rowcount from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_vereinspartner where is_check_ok group by ldts_source  ) l
    ON 1=1
UNION ALL
SELECT 'load_webshop_wohnort' as table_name, l.file_ldts, coalesce(l.rowcount, 0) as rowcount, ldts
FROM current_date 
LEFT JOIN (select ldts_source as file_ldts, count(*) as rowcount from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_wohnort where is_check_ok group by ldts_source  ) l
    ON 1=1
        );
      
  