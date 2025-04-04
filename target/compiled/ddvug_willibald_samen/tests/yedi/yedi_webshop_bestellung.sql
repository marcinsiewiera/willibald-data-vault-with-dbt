

WITH
cte_load_date as
(
  SELECT file_ldts as ldts
  FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_00_meta.meta_load
  WHERE table_name = 'load_webshop_bestellung'
  qualify max(ldts) OVER (PARTITION BY TABLE_NAME) = ldts
),
cte_load AS
(
    SELECT
        kundeid
    , bestellungid
    , allglieferadrid
    , bestelldatum
    , rabatt
    , wunschdatum
        , ldts_source as ldts
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_bestellung
    where is_check_ok
)
        
, cte_customer as
(
        SELECT
            customer_h.hk_customer_h, IFF(customer_bk != '(unknown)', customer_bk, NULL) as kundeid
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_h customer_h
)
        
, cte_order as
(
    with cte_order_h as
    (
        SELECT
            order_h.hk_order_h, IFF(order_bk != '(unknown)', order_bk, NULL) as bestellungid
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_h order_h
    )
    ,cte_order_ws_s as
    (
        SELECT    
              cte_order_h.hk_order_h
            , allglieferadrid
    , bestelldatum
    , rabatt
    , wunschdatum, order_ws_s.ldts, COALESCE(LEAD(order_ws_s.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_order_h.hk_order_h  ORDER BY order_ws_s.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_order_h
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_ws_s order_ws_s
            ON cte_order_h.hk_order_h = order_ws_s.hk_order_h
        WHERE order_ws_s.hk_order_h <> '00000000000000000000000000000000'
    )
    ,cte_order_ws_sts as
    (SELECT * FROM 
        (
        SELECT    
              cte_order_h.hk_order_h, order_ws_sts.ldts, order_ws_sts.cdc, COALESCE(LEAD(order_ws_sts.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_order_h.hk_order_h  ORDER BY order_ws_sts.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_order_h
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_ws_sts order_ws_sts
            ON cte_order_h.hk_order_h = order_ws_sts.hk_order_h
        )
        WHERE cdc <> 'D'
    ) 
    SELECT  
        cte_order_h.hk_order_h
        , cte_order_h.bestellungid
        , cte_order_ws_s.allglieferadrid
        , cte_order_ws_s.bestelldatum
        , cte_order_ws_s.rabatt
        , cte_order_ws_s.wunschdatum
        , d.ldts
    FROM cte_load_date d
    CROSS JOIN cte_order_h
    INNER JOIN  cte_order_ws_s
        ON cte_order_ws_s.hk_order_h = cte_order_h.hk_order_h
        AND d.ldts between cte_order_ws_s.ldts AND cte_order_ws_s.ledts
    INNER JOIN  cte_order_ws_sts
        ON cte_order_ws_sts.hk_order_h = cte_order_h.hk_order_h
        AND d.ldts between cte_order_ws_sts.ldts AND cte_order_ws_sts.ledts
)
        
, cte_order_customer as
(
    with cte_order_customer_l as
    (
        SELECT
            order_customer_l.hk_order_customer_l, hk_order_h
    , hk_customer_h
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_customer_l order_customer_l
    )
    ,cte_order_customer_ws_sts as
    (SELECT * FROM 
        (
        SELECT    
              cte_order_customer_l.hk_order_customer_l, order_customer_ws_sts.ldts, order_customer_ws_sts.cdc, COALESCE(LEAD(order_customer_ws_sts.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_order_customer_l.hk_order_customer_l  ORDER BY order_customer_ws_sts.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_order_customer_l
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.order_customer_ws_sts order_customer_ws_sts
            ON cte_order_customer_l.hk_order_customer_l = order_customer_ws_sts.hk_order_customer_l
        )
        WHERE cdc <> 'D'
    ) 
    SELECT  
        cte_order_customer_l.hk_order_customer_l
        , cte_order_customer_l.hk_order_h
        , cte_order_customer_l.hk_customer_h
        , d.ldts
    FROM cte_load_date d
    CROSS JOIN cte_order_customer_l
    INNER JOIN  cte_order_customer_ws_sts
        ON cte_order_customer_ws_sts.hk_order_customer_l = cte_order_customer_l.hk_order_customer_l
        AND d.ldts between cte_order_customer_ws_sts.ldts AND cte_order_customer_ws_sts.ledts
)
,
cte_target as
(   
    SELECT
    cte_customer.kundeid
    , cte_order.bestellungid
    , cte_order.allglieferadrid
    , cte_order.bestelldatum
    , cte_order.rabatt
    , cte_order.wunschdatum, cte_load_date.ldts
    FROM cte_load_date 
    INNER JOIN cte_order_customer
        ON cte_order_customer.ldts = cte_load_date.ldts
    INNER JOIN  cte_order 
        ON cte_order_customer.hk_order_h = cte_order.hk_order_h
        AND cte_order.ldts =  cte_load_date.ldts
    INNER JOIN  cte_customer 
        ON cte_order_customer.hk_customer_h = cte_customer.hk_customer_h
)
(
    select
            kundeid
    , bestellungid
    , allglieferadrid
    , bestelldatum
    , rabatt
    , wunschdatum
            , ldts
    from cte_load
    MINUS
    select
            kundeid
    , bestellungid
    , allglieferadrid
    , bestelldatum
    , rabatt
    , wunschdatum
            , ldts
    from cte_target
)    
UNION
(
    select
            kundeid
    , bestellungid
    , allglieferadrid
    , bestelldatum
    , rabatt
    , wunschdatum
            , ldts
    from cte_target
    minus
    select
            kundeid
    , bestellungid
    , allglieferadrid
    , bestelldatum
    , rabatt
    , wunschdatum
            , ldts
    from cte_load
)
