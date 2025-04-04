



select
  position_product_snp.sdts, 
  position_product_snp.hk_position_product_l, 
  position_product_snp.hk_position_product_d, 
  position_product_l.hk_product_h,
position_product_l.hk_position_h
,
position_product_rs_es.ldts as ldts_position_product_rs_es,

position_product_rs_es.rsrc as rsrc_position_product_rs_es,

position_product_ws_es.ldts as ldts_position_product_ws_es,

position_product_ws_es.rsrc as rsrc_position_product_ws_es
 
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.position_product_snp  
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_product_l  
on position_product_l.hk_position_product_l = position_product_snp.hk_position_product_l
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_product_rs_es 
on position_product_snp.hk_position_product_rs_es=position_product_rs_es.hk_position_product_l
and position_product_snp.ldts_position_product_rs_es=position_product_rs_es.ldts
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_product_ws_es 
on position_product_snp.hk_position_product_ws_es=position_product_ws_es.hk_position_product_l
and position_product_snp.ldts_position_product_ws_es=position_product_ws_es.ldts 
where  
(
position_product_snp.HK_position_product_rs_es <>'00000000000000000000000000000000' 
OR position_product_snp.HK_position_product_ws_es <>'00000000000000000000000000000000' 

)
AND
    ((position_product_rs_es.cdc <>'D' and position_product_rs_es.hk_position_product_l <>'00000000000000000000000000000000')
 OR (position_product_ws_es.cdc <>'D' and position_product_ws_es.hk_position_product_l <>'00000000000000000000000000000000')
)
  