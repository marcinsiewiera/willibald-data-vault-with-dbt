
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.deliveryadress_sns
  
    
    
(
  
    "SDTS" COMMENT $$$$, 
  
    "HK_DELIVERYADRESS_H" COMMENT $$$$, 
  
    "HK_DELIVERYADRESS_D" COMMENT $$$$, 
  
    "DELIVERYADRESS_BK" COMMENT $$$$, 
  
    "HK_DELIVERYADRESS_H_2" COMMENT $$$$, 
  
    "HD_DELIVERYADRESS_WS_S" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "LDTS" COMMENT $$$$, 
  
    "ADRESSZUSATZ" COMMENT $$$$, 
  
    "HAUSNUMMER" COMMENT $$$$, 
  
    "LAND" COMMENT $$$$, 
  
    "ORT" COMMENT $$$$, 
  
    "PLZ" COMMENT $$$$, 
  
    "STRASSE" COMMENT $$$$, 
  
    "HAS_WS_DATA" COMMENT $$$$
  
)

   as (
    



select
  deliveryadress_snp.sdts, 
  deliveryadress_snp.hk_deliveryadress_h, 
  deliveryadress_snp.hk_deliveryadress_d, 
  deliveryadress_h.deliveryadress_bk,deliveryadress_ws_s.hk_deliveryadress_h,
  deliveryadress_ws_s.hd_deliveryadress_ws_s,
  deliveryadress_ws_s.rsrc,
  deliveryadress_ws_s.ldts,
  deliveryadress_ws_s.adresszusatz,
  deliveryadress_ws_s.hausnummer,
  deliveryadress_ws_s.land,
  deliveryadress_ws_s.ort,
  deliveryadress_ws_s.plz,
  deliveryadress_ws_s.strasse,  
  lower(deliveryadress_ws_s.rsrc)<>'system' has_ws_data
 
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.deliveryadress_snp  
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_h  
on deliveryadress_h.hk_deliveryadress_h = deliveryadress_snp.hk_deliveryadress_h
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_ws_s 
on deliveryadress_snp.hk_deliveryadress_ws_s=deliveryadress_ws_s.hk_deliveryadress_h
and deliveryadress_snp.ldts_deliveryadress_ws_s=deliveryadress_ws_s.ldts 
where  
(
deliveryadress_snp.HK_deliveryadress_ws_s <>'00000000000000000000000000000000' 

)

  );

