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
  WHERE table_name = 'load_webshop_lieferadresse'
  qualify max(ldts) OVER (PARTITION BY TABLE_NAME) = ldts
),
cte_load AS
(
    SELECT
        kundeid
    , lieferadrid
    , adresszusatz
    , hausnummer
    , land
    , ort
    , plz
    , strasse
        , ldts_source as ldts
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_lieferadresse
    where is_check_ok
)
        
, cte_customer as
(
        SELECT
            customer_h.hk_customer_h, IFF(customer_bk != '(unknown)', customer_bk, NULL) as kundeid
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_h customer_h
)
        
, cte_deliveryadress as
(
    with cte_deliveryadress_h as
    (
        SELECT
            deliveryadress_h.hk_deliveryadress_h, IFF(deliveryadress_bk != '(unknown)', deliveryadress_bk, NULL) as lieferadrid
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_h deliveryadress_h
    )
    ,cte_deliveryadress_ws_s as
    (
        SELECT    
              cte_deliveryadress_h.hk_deliveryadress_h
            , adresszusatz
    , hausnummer
    , land
    , ort
    , plz
    , strasse, deliveryadress_ws_s.ldts, COALESCE(LEAD(deliveryadress_ws_s.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_deliveryadress_h.hk_deliveryadress_h  ORDER BY deliveryadress_ws_s.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_deliveryadress_h
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_ws_s deliveryadress_ws_s
            ON cte_deliveryadress_h.hk_deliveryadress_h = deliveryadress_ws_s.hk_deliveryadress_h
        WHERE deliveryadress_ws_s.hk_deliveryadress_h <> '00000000000000000000000000000000'
    ) 
    SELECT  
        cte_deliveryadress_h.hk_deliveryadress_h
        , cte_deliveryadress_h.lieferadrid
        , cte_deliveryadress_ws_s.adresszusatz
        , cte_deliveryadress_ws_s.hausnummer
        , cte_deliveryadress_ws_s.land
        , cte_deliveryadress_ws_s.ort
        , cte_deliveryadress_ws_s.plz
        , cte_deliveryadress_ws_s.strasse
        , d.ldts
    FROM cte_load_date d
    CROSS JOIN cte_deliveryadress_h
    INNER JOIN  cte_deliveryadress_ws_s
        ON cte_deliveryadress_ws_s.hk_deliveryadress_h = cte_deliveryadress_h.hk_deliveryadress_h
        AND d.ldts between cte_deliveryadress_ws_s.ldts AND cte_deliveryadress_ws_s.ledts
)
        
, cte_deliveryadress_customer as
(
    with cte_deliveryadress_customer_l as
    (
        SELECT
            deliveryadress_customer_l.hk_deliveryadress_customer_l, hk_deliveryadress_h
    , hk_customer_h
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_customer_l deliveryadress_customer_l
    )
    ,cte_deliveryadress_customer_ws_sts as
    (SELECT * FROM 
        (
        SELECT    
              cte_deliveryadress_customer_l.hk_deliveryadress_customer_l, deliveryadress_customer_ws_sts.ldts, deliveryadress_customer_ws_sts.cdc, COALESCE(LEAD(deliveryadress_customer_ws_sts.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_deliveryadress_customer_l.hk_deliveryadress_customer_l  ORDER BY deliveryadress_customer_ws_sts.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_deliveryadress_customer_l
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryadress_customer_ws_sts deliveryadress_customer_ws_sts
            ON cte_deliveryadress_customer_l.hk_deliveryadress_customer_l = deliveryadress_customer_ws_sts.hk_deliveryadress_customer_l
        )
        WHERE cdc <> 'D'
    ) 
    SELECT  
        cte_deliveryadress_customer_l.hk_deliveryadress_customer_l
        , cte_deliveryadress_customer_l.hk_deliveryadress_h
        , cte_deliveryadress_customer_l.hk_customer_h
        , d.ldts
    FROM cte_load_date d
    CROSS JOIN cte_deliveryadress_customer_l
    INNER JOIN  cte_deliveryadress_customer_ws_sts
        ON cte_deliveryadress_customer_ws_sts.hk_deliveryadress_customer_l = cte_deliveryadress_customer_l.hk_deliveryadress_customer_l
        AND d.ldts between cte_deliveryadress_customer_ws_sts.ldts AND cte_deliveryadress_customer_ws_sts.ledts
)
,
cte_target as
(   
    SELECT
    cte_customer.kundeid
    , cte_deliveryadress.lieferadrid
    , cte_deliveryadress.adresszusatz
    , cte_deliveryadress.hausnummer
    , cte_deliveryadress.land
    , cte_deliveryadress.ort
    , cte_deliveryadress.plz
    , cte_deliveryadress.strasse, cte_load_date.ldts
    FROM cte_load_date 
    INNER JOIN cte_deliveryadress_customer
        ON cte_deliveryadress_customer.ldts = cte_load_date.ldts
    INNER JOIN  cte_deliveryadress 
        ON cte_deliveryadress_customer.hk_deliveryadress_h = cte_deliveryadress.hk_deliveryadress_h
        AND cte_deliveryadress.ldts =  cte_load_date.ldts
    INNER JOIN  cte_customer 
        ON cte_deliveryadress_customer.hk_customer_h = cte_customer.hk_customer_h
)
(
    select
            kundeid
    , lieferadrid
    , adresszusatz
    , hausnummer
    , land
    , ort
    , plz
    , strasse
            , ldts
    from cte_load
    MINUS
    select
            kundeid
    , lieferadrid
    , adresszusatz
    , hausnummer
    , land
    , ort
    , plz
    , strasse
            , ldts
    from cte_target
)    
UNION
(
    select
            kundeid
    , lieferadrid
    , adresszusatz
    , hausnummer
    , land
    , ort
    , plz
    , strasse
            , ldts
    from cte_target
    minus
    select
            kundeid
    , lieferadrid
    , adresszusatz
    , hausnummer
    , land
    , ort
    , plz
    , strasse
            , ldts
    from cte_load
)

      
    ) dbt_internal_test