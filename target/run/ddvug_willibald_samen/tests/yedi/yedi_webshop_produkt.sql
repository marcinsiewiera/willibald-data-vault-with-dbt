select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      

WITH
cte_load_date as
(
  SELECT file_ldts as ldts
  FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_00_meta.meta_load
  WHERE table_name = 'load_webshop_produkt'
  qualify max(ldts) OVER (PARTITION BY TABLE_NAME) = ldts
),
cte_load AS
(
    SELECT
        produktid
    , bezeichnung
    , pflanzabstand
    , pflanzort
    , preis
    , typ
    , umfang
    , katid
        , ldts_source as ldts
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_produkt
    where is_check_ok
)
        
, cte_product as
(
    with cte_product_h as
    (
        SELECT
            product_h.hk_product_h, IFF(product_bk != '(unknown)', product_bk, NULL) as produktid
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_h product_h
    )
    ,cte_product_ws_s as
    (
        SELECT    
              cte_product_h.hk_product_h
            , bezeichnung
    , pflanzabstand
    , pflanzort
    , preis
    , typ
    , umfang, product_ws_s.ldts, COALESCE(LEAD(product_ws_s.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_product_h.hk_product_h  ORDER BY product_ws_s.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_product_h
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_ws_s product_ws_s
            ON cte_product_h.hk_product_h = product_ws_s.hk_product_h
        WHERE product_ws_s.hk_product_h <> '00000000000000000000000000000000'
    )
    ,cte_product_ws_sts as
    (SELECT * FROM 
        (
        SELECT    
              cte_product_h.hk_product_h, product_ws_sts.ldts, product_ws_sts.cdc, COALESCE(LEAD(product_ws_sts.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_product_h.hk_product_h  ORDER BY product_ws_sts.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_product_h
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_ws_sts product_ws_sts
            ON cte_product_h.hk_product_h = product_ws_sts.hk_product_h
        )
        WHERE cdc <> 'D'
    ) 
    SELECT  
        cte_product_h.hk_product_h
        , cte_product_h.produktid
        , cte_product_ws_s.bezeichnung
        , cte_product_ws_s.pflanzabstand
        , cte_product_ws_s.pflanzort
        , cte_product_ws_s.preis
        , cte_product_ws_s.typ
        , cte_product_ws_s.umfang
        , d.ldts
    FROM cte_load_date d
    CROSS JOIN cte_product_h
    INNER JOIN  cte_product_ws_s
        ON cte_product_ws_s.hk_product_h = cte_product_h.hk_product_h
        AND d.ldts between cte_product_ws_s.ldts AND cte_product_ws_s.ledts
    INNER JOIN  cte_product_ws_sts
        ON cte_product_ws_sts.hk_product_h = cte_product_h.hk_product_h
        AND d.ldts between cte_product_ws_sts.ldts AND cte_product_ws_sts.ledts
)
        
, cte_productcategory as
(
        SELECT
            productcategory_h.hk_productcategory_h, IFF(productcategory_bk != '(unknown)', productcategory_bk, NULL) as katid
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.productcategory_h productcategory_h
)
        
, cte_product_productcategory as
(
    with cte_product_productcategory_l as
    (
        SELECT
            product_productcategory_l.hk_product_productcategory_l, hk_productcategory_h
    , hk_product_h
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_productcategory_l product_productcategory_l
    )
    ,cte_product_productcategory_ws_sts as
    (SELECT * FROM 
        (
        SELECT    
              cte_product_productcategory_l.hk_product_productcategory_l, product_productcategory_ws_sts.ldts, product_productcategory_ws_sts.cdc, COALESCE(LEAD(product_productcategory_ws_sts.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_product_productcategory_l.hk_product_productcategory_l  ORDER BY product_productcategory_ws_sts.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_product_productcategory_l
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_productcategory_ws_sts product_productcategory_ws_sts
            ON cte_product_productcategory_l.hk_product_productcategory_l = product_productcategory_ws_sts.hk_product_productcategory_l
        )
        WHERE cdc <> 'D'
    ) 
    SELECT  
        cte_product_productcategory_l.hk_product_productcategory_l
        , cte_product_productcategory_l.hk_productcategory_h
        , cte_product_productcategory_l.hk_product_h
        , d.ldts
    FROM cte_load_date d
    CROSS JOIN cte_product_productcategory_l
    INNER JOIN  cte_product_productcategory_ws_sts
        ON cte_product_productcategory_ws_sts.hk_product_productcategory_l = cte_product_productcategory_l.hk_product_productcategory_l
        AND d.ldts between cte_product_productcategory_ws_sts.ldts AND cte_product_productcategory_ws_sts.ledts
)
,
cte_target as
(   
    SELECT
    cte_product.produktid
    , cte_product.bezeichnung
    , cte_product.pflanzabstand
    , cte_product.pflanzort
    , cte_product.preis
    , cte_product.typ
    , cte_product.umfang
    , cte_productcategory.katid, cte_load_date.ldts
    FROM cte_load_date 
    INNER JOIN cte_product_productcategory
        ON cte_product_productcategory.ldts = cte_load_date.ldts
    INNER JOIN  cte_productcategory 
        ON cte_product_productcategory.hk_productcategory_h = cte_productcategory.hk_productcategory_h
    INNER JOIN  cte_product 
        ON cte_product_productcategory.hk_product_h = cte_product.hk_product_h
        AND cte_product.ldts =  cte_load_date.ldts
)
(
    select
            produktid
    , bezeichnung
    , pflanzabstand
    , pflanzort
    , preis
    , typ
    , umfang
    , katid
            , ldts
    from cte_load
    MINUS
    select
            produktid
    , bezeichnung
    , pflanzabstand
    , pflanzort
    , preis
    , typ
    , umfang
    , katid
            , ldts
    from cte_target
)    
UNION
(
    select
            produktid
    , bezeichnung
    , pflanzabstand
    , pflanzort
    , preis
    , typ
    , umfang
    , katid
            , ldts
    from cte_target
    minus
    select
            produktid
    , bezeichnung
    , pflanzabstand
    , pflanzort
    , preis
    , typ
    , umfang
    , katid
            , ldts
    from cte_load
)

      
    ) dbt_internal_test