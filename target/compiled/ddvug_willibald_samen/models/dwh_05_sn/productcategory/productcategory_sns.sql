



select
  productcategory_snp.sdts, 
  productcategory_snp.hk_productcategory_h, 
  productcategory_snp.hk_productcategory_d, 
  productcategory_h.productcategory_bk,productcategory_ws_s.hk_productcategory_h,
  productcategory_ws_s.hd_productcategory_ws_s,
  productcategory_ws_s.rsrc,
  productcategory_ws_s.ldts,
  productcategory_ws_s.name,  
  lower(productcategory_ws_s.rsrc)<>'system' has_ws_data
 
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.productcategory_snp  
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.productcategory_h  
on productcategory_h.hk_productcategory_h = productcategory_snp.hk_productcategory_h
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.productcategory_ws_s 
on productcategory_snp.hk_productcategory_ws_s=productcategory_ws_s.hk_productcategory_h
and productcategory_snp.ldts_productcategory_ws_s=productcategory_ws_s.ldts 
where  
(
productcategory_snp.HK_productcategory_ws_s <>'00000000000000000000000000000000' 

)
