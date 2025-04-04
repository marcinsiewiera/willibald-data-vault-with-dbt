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
  WHERE table_name = 'load_webshop_position'
  qualify max(ldts) OVER (PARTITION BY TABLE_NAME) = ldts
),
cte_load AS
(
    SELECT
        bestellungid
    , posid
    , menge
    , preis
    , spezlieferadrid
    , produktid
        , ldts_source as ldts
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_position
    where is_check_ok
)
        
, cte_order as
(
        SELECT
            order_h.hk_order_h, IFF(order_bk != '(unknown)', order_bk, NULL) as bestellungid
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_h order_h
)
, cte_position as
(
    with cte_position_h as
    (
        SELECT
            position_h.hk_position_h
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_h position_h
    )
    ,cte_position_ws_s as
    (
        SELECT    
              cte_position_h.hk_position_h
            , bestellungid
    , menge
    , posid
    , preis
    , spezlieferadrid, position_ws_s.ldts, COALESCE(LEAD(position_ws_s.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_position_h.hk_position_h  ORDER BY position_ws_s.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_position_h
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_ws_s position_ws_s
            ON cte_position_h.hk_position_h = position_ws_s.hk_position_h
        WHERE position_ws_s.hk_position_h <> '00000000000000000000000000000000'
    )
    ,cte_position_ws_sts as
    (SELECT * FROM 
        (
        SELECT    
              cte_position_h.hk_position_h, position_ws_sts.ldts, position_ws_sts.cdc, COALESCE(LEAD(position_ws_sts.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_position_h.hk_position_h  ORDER BY position_ws_sts.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_position_h
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_ws_sts position_ws_sts
            ON cte_position_h.hk_position_h = position_ws_sts.hk_position_h
        )
        WHERE cdc <> 'D'
    ) 
    SELECT  
        cte_position_h.hk_position_h
        , cte_position_ws_s.bestellungid
        , cte_position_ws_s.menge
        , cte_position_ws_s.posid
        , cte_position_ws_s.preis
        , cte_position_ws_s.spezlieferadrid
        , d.ldts
    FROM cte_load_date d
    CROSS JOIN cte_position_h
    INNER JOIN  cte_position_ws_s
        ON cte_position_ws_s.hk_position_h = cte_position_h.hk_position_h
        AND d.ldts between cte_position_ws_s.ldts AND cte_position_ws_s.ledts
    INNER JOIN  cte_position_ws_sts
        ON cte_position_ws_sts.hk_position_h = cte_position_h.hk_position_h
        AND d.ldts between cte_position_ws_sts.ldts AND cte_position_ws_sts.ledts
)
        
, cte_product as
(
        SELECT
            product_h.hk_product_h, IFF(product_bk != '(unknown)', product_bk, NULL) as produktid
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.product_h product_h
)
        
, cte_order_position as
(
    with cte_order_position_l as
    (
        SELECT
            order_position_l.hk_order_position_l, hk_position_h
    , hk_order_h
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_position_l order_position_l
    )
    ,cte_order_position_ws_sts as
    (SELECT * FROM 
        (
        SELECT    
              cte_order_position_l.hk_order_position_l, order_position_ws_sts.ldts, order_position_ws_sts.cdc, COALESCE(LEAD(order_position_ws_sts.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_order_position_l.hk_order_position_l  ORDER BY order_position_ws_sts.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_order_position_l
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_position_ws_sts order_position_ws_sts
            ON cte_order_position_l.hk_order_position_l = order_position_ws_sts.hk_order_position_l
        )
        WHERE cdc <> 'D'
    ) 
    SELECT  
        cte_order_position_l.hk_order_position_l
        , cte_order_position_l.hk_position_h
        , cte_order_position_l.hk_order_h
        , d.ldts
    FROM cte_load_date d
    CROSS JOIN cte_order_position_l
    INNER JOIN  cte_order_position_ws_sts
        ON cte_order_position_ws_sts.hk_order_position_l = cte_order_position_l.hk_order_position_l
        AND d.ldts between cte_order_position_ws_sts.ldts AND cte_order_position_ws_sts.ledts
)
        
, cte_position_product as
(
    with cte_position_product_l as
    (
        SELECT
            position_product_l.hk_position_product_l, hk_product_h
    , hk_position_h
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_product_l position_product_l
    )
    ,cte_position_product_ws_sts as
    (SELECT * FROM 
        (
        SELECT    
              cte_position_product_l.hk_position_product_l, position_product_ws_sts.ldts, position_product_ws_sts.cdc, COALESCE(LEAD(position_product_ws_sts.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_position_product_l.hk_position_product_l  ORDER BY position_product_ws_sts.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_position_product_l
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_product_ws_sts position_product_ws_sts
            ON cte_position_product_l.hk_position_product_l = position_product_ws_sts.hk_position_product_l
        )
        WHERE cdc <> 'D'
    ) 
    SELECT  
        cte_position_product_l.hk_position_product_l
        , cte_position_product_l.hk_product_h
        , cte_position_product_l.hk_position_h
        , d.ldts
    FROM cte_load_date d
    CROSS JOIN cte_position_product_l
    INNER JOIN  cte_position_product_ws_sts
        ON cte_position_product_ws_sts.hk_position_product_l = cte_position_product_l.hk_position_product_l
        AND d.ldts between cte_position_product_ws_sts.ldts AND cte_position_product_ws_sts.ledts
)
,
cte_target as
(   
    SELECT
    cte_order.bestellungid
    , cte_position.menge
    , cte_position.posid
    , cte_position.preis
    , cte_position.spezlieferadrid
    , cte_product.produktid, cte_load_date.ldts
    FROM cte_load_date 
    INNER JOIN cte_order_position
        ON cte_order_position.ldts = cte_load_date.ldts
    INNER JOIN  cte_position 
        ON cte_order_position.hk_position_h = cte_position.hk_position_h
        AND cte_position.ldts =  cte_load_date.ldts
    INNER JOIN  cte_order 
        ON cte_order_position.hk_order_h = cte_order.hk_order_h 
    INNER JOIN cte_position_product
        ON cte_position_product.ldts = cte_load_date.ldts
        AND cte_position_product.hk_position_h = cte_position.hk_position_h
    INNER JOIN  cte_product 
        ON cte_position_product.hk_product_h = cte_product.hk_product_h
)
(
    select
            bestellungid
    , posid
    , menge
    , preis
    , spezlieferadrid
    , produktid
            , ldts
    from cte_load
    MINUS
    select
            bestellungid
    , posid
    , menge
    , preis
    , spezlieferadrid
    , produktid
            , ldts
    from cte_target
)    
UNION
(
    select
            bestellungid
    , posid
    , menge
    , preis
    , spezlieferadrid
    , produktid
            , ldts
    from cte_target
    minus
    select
            bestellungid
    , posid
    , menge
    , preis
    , spezlieferadrid
    , produktid
            , ldts
    from cte_load
)

      
    ) dbt_internal_test