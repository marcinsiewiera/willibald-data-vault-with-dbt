
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.category_deliveryadherence_sns
  
    
    
(
  
    "SDTS" COMMENT $$$$, 
  
    "CATEGORY_DELIVERYADHERENCE_NK" COMMENT $$$$, 
  
    "LDTS" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "HK_CATEGORY_DELIVERYADHERENCE_D" COMMENT $$$$, 
  
    "CDM_CATEGORY_DELIVERYADHERENCE_NK" COMMENT $$$$, 
  
    "CDM_HD_CATEGORY_DELIVERYADHERENCE_MISC_RS" COMMENT $$$$, 
  
    "CDM_COUNT_DAYS_FROM" COMMENT $$$$, 
  
    "CDM_COUNT_DAYS_TO" COMMENT $$$$, 
  
    "CDM_NAME" COMMENT $$$$
  
)

   as (
    select 
	  category_deliveryadherence_snp.sdts
	, category_deliveryadherence_r.category_deliveryadherence_nk
	, category_deliveryadherence_r.ldts 
	, category_deliveryadherence_r.rsrc
	, category_deliveryadherence_snp.hk_category_deliveryadherence_d
    , category_deliveryadherence_misc_rs.CATEGORY_DELIVERYADHERENCE_NK as cdm_CATEGORY_DELIVERYADHERENCE_NK,
  category_deliveryadherence_misc_rs.HD_CATEGORY_DELIVERYADHERENCE_MISC_RS as cdm_HD_CATEGORY_DELIVERYADHERENCE_MISC_RS,
  category_deliveryadherence_misc_rs.COUNT_DAYS_FROM as cdm_COUNT_DAYS_FROM,
  category_deliveryadherence_misc_rs.COUNT_DAYS_TO as cdm_COUNT_DAYS_TO,
  category_deliveryadherence_misc_rs.NAME as cdm_NAME
from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_05_sn.category_deliveryadherence_snp category_deliveryadherence_snp
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.category_deliveryadherence_r category_deliveryadherence_r 
	on  category_deliveryadherence_snp.hk_category_deliveryadherence_misc_rs=category_deliveryadherence_r.category_deliveryadherence_nk
inner join WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.category_deliveryadherence_misc_rs category_deliveryadherence_misc_rs
	on  category_deliveryadherence_snp.hk_category_deliveryadherence_misc_rs  =category_deliveryadherence_misc_rs.category_deliveryadherence_nk
	and category_deliveryadherence_snp.ldts_category_deliveryadherence_misc_rs=category_deliveryadherence_misc_rs.ldts
INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.category_deliveryadherence_misc_sts
	ON category_deliveryadherence_snp.hk_category_deliveryadherence_misc_sts=category_deliveryadherence_misc_sts.category_deliveryadherence_nk
	AND category_deliveryadherence_snp.ldts_category_deliveryadherence_misc_sts = category_deliveryadherence_misc_sts.ldts
WHERE  category_deliveryadherence_misc_sts.cdc <>'D'
  );

