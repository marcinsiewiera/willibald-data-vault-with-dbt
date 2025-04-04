


WITH


cte_current_sts as
(
    select    '00000000000000000000000000000000' as hk_product_h
            , '' rsrc
            , TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') ldts
            , 'I' as cdc
)
,
cte_current_sts_not_deleted as
(
  select  cte_current_sts.hk_product_h, cte_current_sts.rsrc, cte_current_sts.ldts
  from cte_current_sts
  where cdc <> 'D'
)
, cte_max_rv_ldts AS
(
    SELECT COALESCE(max(ldts), TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS') ) ldts 
    FROM cte_current_sts_not_deleted
)
, cte_stage AS
(
    select src.hk_product_h, src.rsrc, src.ldts
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_webshop_produkt src
    CROSS JOIN cte_max_rv_ldts
    where not src.ldts in (TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS'), TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS'))
    AND src.ldts > cte_max_rv_ldts.ldts
)
, cte_rv_stage_union as
(
    select cte_current_sts_not_deleted.hk_product_h, cte_current_sts_not_deleted.rsrc, cte_current_sts_not_deleted.ldts
    from cte_current_sts_not_deleted
    UNION
    (
        select cte_stage.hk_product_h, cte_stage.rsrc, cte_stage.ldts
        from cte_stage
    )
)
, cte_dat_dom as
(
    select distinct src.ldts
    from WILLIBALD_DATA_VAULT_WITH_DBT.dwh_03_stage.stg_webshop_produkt src
    CROSS JOIN cte_max_rv_ldts
    where not src.ldts in (TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS'), TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS'))
    AND src.ldts > cte_max_rv_ldts.ldts 
)
, cte_key_dom as
(
    select cte_rv_stage_union.hk_product_h
    from cte_rv_stage_union
)
, cte_key_dat_dom as
(
    select distinct  cte_key_dom.hk_product_h
                    , cte_dat_dom.ldts
                    from cte_key_dom 
    cross join cte_dat_dom
), cte_data_join as
(
    select
          cte_key_dat_dom.hk_product_h dom_key
        , cte_key_dat_dom.ldts as dom_ldts
        , cte_rv_stage_union.ldts as stage_ldts, lag(cte_key_dat_dom.ldts) over (partition by  cte_key_dat_dom.hk_product_h order by  cte_key_dat_dom.ldts) as prev_dom_ldts
        , lag(cte_rv_stage_union.ldts) over (partition by  cte_key_dat_dom.hk_product_h order by  cte_key_dat_dom.ldts) as prev_stage_ldts
        , cte_rv_stage_union.rsrc
    from cte_key_dat_dom 
    left join cte_rv_stage_union 
         on cte_key_dat_dom.ldts = cte_rv_stage_union.ldts
         and cte_key_dat_dom.hk_product_h = cte_rv_stage_union.hk_product_h
    where 1=1
)
, cte_data_interpretation as
(
    select
      dom_key
    , dom_ldts
    , stage_ldts, prev_dom_ldts
    , prev_stage_ldts
    , CASE WHEN stage_ldts IS NULL AND prev_dom_ldts IS NULL
        THEN 'discard'
    WHEN COALESCE (stage_ldts, TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS'))=dom_ldts AND prev_dom_ldts IS NULL
    THEN 'I'
    WHEN COALESCE (stage_ldts, TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS'))=dom_ldts AND prev_stage_ldts IS NULL 
        THEN 'I'
        WHEN stage_ldts IS NULL AND COALESCE(prev_stage_ldts, TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS'))= COALESCE(prev_dom_ldts, TO_TIMESTAMP('0001-01-01T00:00:01', 'YYYY-MM-DDTHH24:MI:SS'))
        THEN 'D'
    
        ELSE 'discard'
        END AS cdc
    , cte_data_join.rsrc
    from cte_data_join
)
SELECT
      dom_key AS hk_product_h
    , dom_ldts AS ldts, cte_data_interpretation.rsrc
    , cdc
FROM cte_data_interpretation
WHERE cdc<>'discard'
UNION ALL
SELECT 
hk_product_h
    ,  ldts, rsrc
    , cdc
FROM cte_current_sts