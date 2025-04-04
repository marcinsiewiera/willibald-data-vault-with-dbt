
  create or replace   view WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_productcategory_ws_es
  
    
    
(
  
    "HK_PRODUCT_PRODUCTCATEGORY_L" COMMENT $$$$, 
  
    "HK_PRODUCT_H" COMMENT $$$$, 
  
    "HK_PRODUCTCATEGORY_H" COMMENT $$$$, 
  
    "LDTS" COMMENT $$$$, 
  
    "LEDTS" COMMENT $$$$, 
  
    "IS_ACTIVE" COMMENT $$$$, 
  
    "RSRC" COMMENT $$$$, 
  
    "CDC" COMMENT $$$$, 
  
    "IS_CURRENT" COMMENT $$$$
  
)

   as (
    


 

-- depends_on: WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_productcategory_l


with union_sts as
(	
	SELECT *
	FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_productcategory_ws_sts
), ledts_calculation as 
(
	select 
		  union_sts.hk_product_productcategory_l
		, product_productcategory_l.hk_product_h
		, product_productcategory_l.hk_productcategory_h
		, union_sts.ldts, coalesce(lead(union_sts.ldts- interval '1 microsecond') over (partition by product_productcategory_l.hk_product_h order by union_sts.ldts),to_timestamp('8888-12-31t23:59:59', 'yyyy-mm-ddthh24:mi:ss')) as ledts
		, row_number() over (partition by product_productcategory_l.hk_product_h order by union_sts.ldts desc) =1 is_active, union_sts.rsrc 
	, union_sts.cdc
	from union_sts
	inner join  WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_productcategory_l 
		on union_sts.hk_product_productcategory_l=product_productcategory_l.hk_product_productcategory_l)
select
*
, CASE WHEN ledts = TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')
	THEN TRUE
	ELSE FALSE
END AS IS_CURRENT


from ledts_calculation
where cdc<>'D'


  );

