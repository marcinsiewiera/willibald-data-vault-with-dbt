
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.customer_sns
  
    
    
(
  
    "SDTS" COMMENT $$$$, 
  
    "HK_CUSTOMER_H" COMMENT $$$$, 
  
    "HK_CUSTOMER_D" COMMENT $$$$, 
  
    "CUSTOMER_BK" COMMENT $$$$, 
  
    "HK_CUSTOMER_H_2" COMMENT $$$$, 
  
    "HD_CUSTOMER_WS_S" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "LDTS" COMMENT $$$$, 
  
    "EMAIL" COMMENT $$$$, 
  
    "GEBURTSDATUM" COMMENT $$$$, 
  
    "GESCHLECHT" COMMENT $$$$, 
  
    "GUELTIGBIS" COMMENT $$$$, 
  
    "KKFIRMA" COMMENT $$$$, 
  
    "KREDITKARTE" COMMENT $$$$, 
  
    "MOBIL" COMMENT $$$$, 
  
    "NAME" COMMENT $$$$, 
  
    "TELEFON" COMMENT $$$$, 
  
    "VORNAME" COMMENT $$$$, 
  
    "HAS_WS_DATA" COMMENT $$$$, 
  
    "LDTS_CUSTOMER_WS_STS" COMMENT $$$$, 
  
    "RSRC_CUSTOMER_WS_STS" COMMENT $$$$
  
)

   as (
    



select
  customer_snp.sdts, 
  customer_snp.hk_customer_h, 
  customer_snp.hk_customer_d, 
  customer_h.customer_bk,customer_ws_s.hk_customer_h,
  customer_ws_s.hd_customer_ws_s,
  customer_ws_s.rsrc,
  customer_ws_s.ldts,
  customer_ws_s.email,
  customer_ws_s.geburtsdatum,
  customer_ws_s.geschlecht,
  customer_ws_s.gueltigbis,
  customer_ws_s.kkfirma,
  customer_ws_s.kreditkarte,
  customer_ws_s.mobil,
  customer_ws_s.name,
  customer_ws_s.telefon,
  customer_ws_s.vorname,  
  lower(customer_ws_s.rsrc)<>'system' has_ws_data
,
customer_ws_sts.ldts as ldts_customer_ws_sts,

customer_ws_sts.rsrc as rsrc_customer_ws_sts
 
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.customer_snp  
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_h  
on customer_h.hk_customer_h = customer_snp.hk_customer_h
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_ws_s 
on customer_snp.hk_customer_ws_s=customer_ws_s.hk_customer_h
and customer_snp.ldts_customer_ws_s=customer_ws_s.ldts
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_ws_sts 
on customer_snp.hk_customer_ws_sts=customer_ws_sts.hk_customer_h
and customer_snp.ldts_customer_ws_sts=customer_ws_sts.ldts 
where  
(
customer_snp.HK_customer_ws_s <>'00000000000000000000000000000000' 
OR customer_snp.HK_customer_ws_sts <>'00000000000000000000000000000000' 

)
AND
    ((customer_ws_sts.cdc <>'D' and customer_ws_sts.hk_customer_h <>'00000000000000000000000000000000')
)
  
  );

