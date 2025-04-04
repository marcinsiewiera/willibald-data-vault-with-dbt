



select
  associationpartner_snp.sdts, 
  associationpartner_snp.hk_associationpartner_h, 
  associationpartner_snp.hk_associationpartner_d, 
  associationpartner_h.associationpartner_bk,associationpartner_ws_s.hk_associationpartner_h,
  associationpartner_ws_s.hd_associationpartner_ws_s,
  associationpartner_ws_s.rsrc,
  associationpartner_ws_s.ldts,
  associationpartner_ws_s.kundeidverein,
  associationpartner_ws_s.rabatt1,
  associationpartner_ws_s.rabatt2,
  associationpartner_ws_s.rabatt3,  
  lower(associationpartner_ws_s.rsrc)<>'system' has_ws_data
,
associationpartner_ws_sts.ldts as ldts_associationpartner_ws_sts,

associationpartner_ws_sts.rsrc as rsrc_associationpartner_ws_sts
 
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.associationpartner_snp  
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.associationpartner_h  
on associationpartner_h.hk_associationpartner_h = associationpartner_snp.hk_associationpartner_h
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.associationpartner_ws_s 
on associationpartner_snp.hk_associationpartner_ws_s=associationpartner_ws_s.hk_associationpartner_h
and associationpartner_snp.ldts_associationpartner_ws_s=associationpartner_ws_s.ldts
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.associationpartner_ws_sts 
on associationpartner_snp.hk_associationpartner_ws_sts=associationpartner_ws_sts.hk_associationpartner_h
and associationpartner_snp.ldts_associationpartner_ws_sts=associationpartner_ws_sts.ldts 
where  
(
associationpartner_snp.HK_associationpartner_ws_s <>'00000000000000000000000000000000' 
OR associationpartner_snp.HK_associationpartner_ws_sts <>'00000000000000000000000000000000' 

)
AND
    ((associationpartner_ws_sts.cdc <>'D' and associationpartner_ws_sts.hk_associationpartner_h <>'00000000000000000000000000000000')
)
  