
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.position_sns
  
    
    
(
  
    "SDTS" COMMENT $$$$, 
  
    "HK_POSITION_H" COMMENT $$$$, 
  
    "HK_POSITION_D" COMMENT $$$$, 
  
    "POSITION_BK" COMMENT $$$$, 
  
    "HK_POSITION_H_RS" COMMENT $$$$, 
  
    "HD_POSITION_RS_S_RS" COMMENT $$$$, 
  
    "RSRC_RS" COMMENT $$$$, 
  
    "LDTS_RS" COMMENT $$$$, 
  
    "BESTELLUNGID_RS" COMMENT $$$$, 
  
    "GUELTIGBIS_RS" COMMENT $$$$, 
  
    "KAUFDATUM_RS" COMMENT $$$$, 
  
    "KKFIRMA_RS" COMMENT $$$$, 
  
    "KREDITKARTE_RS" COMMENT $$$$, 
  
    "MENGE_RS" COMMENT $$$$, 
  
    "PREIS_RS" COMMENT $$$$, 
  
    "PRODUKTID_RS" COMMENT $$$$, 
  
    "RABATT_RS" COMMENT $$$$, 
  
    "HAS_RS_DATA" COMMENT $$$$, 
  
    "HK_POSITION_H_2" COMMENT $$$$, 
  
    "HD_POSITION_WS_S" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "LDTS" COMMENT $$$$, 
  
    "BESTELLUNGID" COMMENT $$$$, 
  
    "MENGE" COMMENT $$$$, 
  
    "POSID" COMMENT $$$$, 
  
    "PREIS" COMMENT $$$$, 
  
    "SPEZLIEFERADRID" COMMENT $$$$, 
  
    "HAS_WS_DATA" COMMENT $$$$, 
  
    "LDTS_POSITION_RS_STS" COMMENT $$$$, 
  
    "RSRC_POSITION_RS_STS" COMMENT $$$$, 
  
    "LDTS_POSITION_WS_STS" COMMENT $$$$, 
  
    "RSRC_POSITION_WS_STS" COMMENT $$$$
  
)

   as (
    



select
  position_snp.sdts, 
  position_snp.hk_position_h, 
  position_snp.hk_position_d, 
  position_h.position_bk,position_rs_s.hk_position_h as hk_position_h_rs,
  position_rs_s.hd_position_rs_s as hd_position_rs_s_rs,
  position_rs_s.rsrc as rsrc_rs,
  position_rs_s.ldts as ldts_rs,
  position_rs_s.bestellungid as bestellungid_rs,
  position_rs_s.gueltigbis as gueltigbis_rs,
  position_rs_s.kaufdatum as kaufdatum_rs,
  position_rs_s.kkfirma as kkfirma_rs,
  position_rs_s.kreditkarte as kreditkarte_rs,
  position_rs_s.menge as menge_rs,
  position_rs_s.preis as preis_rs,
  position_rs_s.produktid as produktid_rs,
  position_rs_s.rabatt as rabatt_rs,  
  lower(position_rs_s.rsrc)<>'system' has_rs_data,
position_ws_s.hk_position_h,
  position_ws_s.hd_position_ws_s,
  position_ws_s.rsrc,
  position_ws_s.ldts,
  position_ws_s.bestellungid,
  position_ws_s.menge,
  position_ws_s.posid,
  position_ws_s.preis,
  position_ws_s.spezlieferadrid,  
  lower(position_ws_s.rsrc)<>'system' has_ws_data
,
position_rs_sts.ldts as ldts_position_rs_sts,

position_rs_sts.rsrc as rsrc_position_rs_sts,

position_ws_sts.ldts as ldts_position_ws_sts,

position_ws_sts.rsrc as rsrc_position_ws_sts
 
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.position_snp  
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_h  
on position_h.hk_position_h = position_snp.hk_position_h
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_rs_s 
on position_snp.hk_position_rs_s=position_rs_s.hk_position_h
and position_snp.ldts_position_rs_s=position_rs_s.ldts
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_rs_sts 
on position_snp.hk_position_rs_sts=position_rs_sts.hk_position_h
and position_snp.ldts_position_rs_sts=position_rs_sts.ldts
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_ws_s 
on position_snp.hk_position_ws_s=position_ws_s.hk_position_h
and position_snp.ldts_position_ws_s=position_ws_s.ldts
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_ws_sts 
on position_snp.hk_position_ws_sts=position_ws_sts.hk_position_h
and position_snp.ldts_position_ws_sts=position_ws_sts.ldts 
where  
(
position_snp.HK_position_rs_s <>'00000000000000000000000000000000' 
OR position_snp.HK_position_rs_sts <>'00000000000000000000000000000000' 
OR position_snp.HK_position_ws_s <>'00000000000000000000000000000000' 
OR position_snp.HK_position_ws_sts <>'00000000000000000000000000000000' 

)
AND
    ((position_rs_sts.cdc <>'D' and position_rs_sts.hk_position_h <>'00000000000000000000000000000000')
 OR (position_ws_sts.cdc <>'D' and position_ws_sts.hk_position_h <>'00000000000000000000000000000000')
)
  
  );

