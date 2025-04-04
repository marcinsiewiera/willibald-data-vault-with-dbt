



select
  deliveryservice_snp.sdts, 
  deliveryservice_snp.hk_deliveryservice_h, 
  deliveryservice_snp.hk_deliveryservice_d, 
  deliveryservice_h.deliveryservice_bk,deliveryservice_ws_s.hk_deliveryservice_h,
  deliveryservice_ws_s.hd_deliveryservice_ws_s,
  deliveryservice_ws_s.rsrc,
  deliveryservice_ws_s.ldts,
  deliveryservice_ws_s.email,
  deliveryservice_ws_s.fax,
  deliveryservice_ws_s.hausnummer,
  deliveryservice_ws_s.land,
  deliveryservice_ws_s.name,
  deliveryservice_ws_s.ort,
  deliveryservice_ws_s.plz,
  deliveryservice_ws_s.strasse,
  deliveryservice_ws_s.telefon,  
  lower(deliveryservice_ws_s.rsrc)<>'system' has_ws_data
,
deliveryservice_ws_sts.ldts as ldts_deliveryservice_ws_sts,

deliveryservice_ws_sts.rsrc as rsrc_deliveryservice_ws_sts
 
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.deliveryservice_snp  
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryservice_h  
on deliveryservice_h.hk_deliveryservice_h = deliveryservice_snp.hk_deliveryservice_h
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryservice_ws_s 
on deliveryservice_snp.hk_deliveryservice_ws_s=deliveryservice_ws_s.hk_deliveryservice_h
and deliveryservice_snp.ldts_deliveryservice_ws_s=deliveryservice_ws_s.ldts
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryservice_ws_sts 
on deliveryservice_snp.hk_deliveryservice_ws_sts=deliveryservice_ws_sts.hk_deliveryservice_h
and deliveryservice_snp.ldts_deliveryservice_ws_sts=deliveryservice_ws_sts.ldts 
where  
(
deliveryservice_snp.HK_deliveryservice_ws_s <>'00000000000000000000000000000000' 
OR deliveryservice_snp.HK_deliveryservice_ws_sts <>'00000000000000000000000000000000' 

)
AND
    ((deliveryservice_ws_sts.cdc <>'D' and deliveryservice_ws_sts.hk_deliveryservice_h <>'00000000000000000000000000000000')
)
  