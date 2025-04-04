

WITH
cte_load_date as
(
  SELECT file_ldts as ldts
  FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_00_meta.meta_load
  WHERE table_name = 'load_webshop_lieferung'
  qualify max(ldts) OVER (PARTITION BY TABLE_NAME) = ldts
),
cte_load AS
(
    SELECT
        lieferadrid
    , lieferdienstid
    , bestellungid
    , posid
        , ldts_source as ldts
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_lieferung
    where is_check_ok
)
        
, cte_deliveryadress as
(
        SELECT
            deliveryadress_h.hk_deliveryadress_h, IFF(deliveryadress_bk != '(unknown)', deliveryadress_bk, NULL) as lieferadrid
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_h deliveryadress_h
)
        
, cte_deliveryservice as
(
        SELECT
            deliveryservice_h.hk_deliveryservice_h, IFF(deliveryservice_bk != '(unknown)', deliveryservice_bk, NULL) as lieferdienstid
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryservice_h deliveryservice_h
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
    , posid, position_ws_s.ldts, COALESCE(LEAD(position_ws_s.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_position_h.hk_position_h  ORDER BY position_ws_s.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_position_h
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.position_ws_s position_ws_s
            ON cte_position_h.hk_position_h = position_ws_s.hk_position_h
        WHERE position_ws_s.hk_position_h <> '00000000000000000000000000000000'
    ) 
    SELECT  
        cte_position_h.hk_position_h
        , cte_position_ws_s.bestellungid
        , cte_position_ws_s.posid
        , d.ldts
    FROM cte_load_date d
    CROSS JOIN cte_position_h
    INNER JOIN  cte_position_ws_s
        ON cte_position_ws_s.hk_position_h = cte_position_h.hk_position_h
        AND d.ldts between cte_position_ws_s.ldts AND cte_position_ws_s.ledts
)
        
, cte_delivery as
(
        SELECT hk_deliveryadress_h
    , hk_deliveryservice_h
    , hk_order_h
    , hk_position_h
        , cte_load_date.ldts as ldts
        FROM cte_load_date
        CROSS JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.delivery_nhl delivery_nhl
        WHERE  delivery_nhl.ldts <= cte_load_date.ldts
)
,
cte_target as
(   
    SELECT
    cte_deliveryadress.lieferadrid
    , cte_deliveryservice.lieferdienstid
    , cte_order.bestellungid
    , cte_position.posid, cte_load_date.ldts
    FROM cte_load_date 
    INNER JOIN cte_delivery
        ON cte_delivery.ldts = cte_load_date.ldts
    INNER JOIN  cte_deliveryadress 
        ON cte_delivery.hk_deliveryadress_h = cte_deliveryadress.hk_deliveryadress_h
    INNER JOIN  cte_deliveryservice 
        ON cte_delivery.hk_deliveryservice_h = cte_deliveryservice.hk_deliveryservice_h
    INNER JOIN  cte_order 
        ON cte_delivery.hk_order_h = cte_order.hk_order_h
    INNER JOIN  cte_position 
        ON cte_delivery.hk_position_h = cte_position.hk_position_h
        AND cte_position.ldts =  cte_load_date.ldts
)
(
    select
            lieferadrid
    , lieferdienstid
    , bestellungid
    , posid
            , ldts
    from cte_load
    MINUS
    select
            lieferadrid
    , lieferdienstid
    , bestellungid
    , posid
            , ldts
    from cte_target
)    
UNION
(
    select
            lieferadrid
    , lieferdienstid
    , bestellungid
    , posid
            , ldts
    from cte_target
    minus
    select
            lieferadrid
    , lieferdienstid
    , bestellungid
    , posid
            , ldts
    from cte_load
)
