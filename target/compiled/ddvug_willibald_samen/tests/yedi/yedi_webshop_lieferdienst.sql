

WITH
cte_load_date as
(
  SELECT file_ldts as ldts
  FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_00_meta.meta_load
  WHERE table_name = 'load_webshop_lieferdienst'
  qualify max(ldts) OVER (PARTITION BY TABLE_NAME) = ldts
),
cte_load AS
(
    SELECT
        lieferdienstid
    , email
    , fax
    , hausnummer
    , land
    , name
    , ort
    , plz
    , strasse
    , telefon
        , ldts_source as ldts
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_lieferdienst
    where is_check_ok
)
        
, cte_deliveryservice as
(
    with cte_deliveryservice_h as
    (
        SELECT
            deliveryservice_h.hk_deliveryservice_h, IFF(deliveryservice_bk != '(unknown)', deliveryservice_bk, NULL) as lieferdienstid
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryservice_h deliveryservice_h
    )
    ,cte_deliveryservice_ws_s as
    (
        SELECT    
              cte_deliveryservice_h.hk_deliveryservice_h
            , email
    , fax
    , hausnummer
    , land
    , name
    , ort
    , plz
    , strasse
    , telefon, deliveryservice_ws_s.ldts, COALESCE(LEAD(deliveryservice_ws_s.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_deliveryservice_h.hk_deliveryservice_h  ORDER BY deliveryservice_ws_s.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_deliveryservice_h
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryservice_ws_s deliveryservice_ws_s
            ON cte_deliveryservice_h.hk_deliveryservice_h = deliveryservice_ws_s.hk_deliveryservice_h
        WHERE deliveryservice_ws_s.hk_deliveryservice_h <> '00000000000000000000000000000000'
    )
    ,cte_deliveryservice_ws_sts as
    (SELECT * FROM 
        (
        SELECT    
              cte_deliveryservice_h.hk_deliveryservice_h, deliveryservice_ws_sts.ldts, deliveryservice_ws_sts.cdc, COALESCE(LEAD(deliveryservice_ws_sts.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_deliveryservice_h.hk_deliveryservice_h  ORDER BY deliveryservice_ws_sts.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_deliveryservice_h
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.deliveryservice_ws_sts deliveryservice_ws_sts
            ON cte_deliveryservice_h.hk_deliveryservice_h = deliveryservice_ws_sts.hk_deliveryservice_h
        )
        WHERE cdc <> 'D'
    ) 
    SELECT  
        cte_deliveryservice_h.hk_deliveryservice_h
        , cte_deliveryservice_h.lieferdienstid
        , cte_deliveryservice_ws_s.email
        , cte_deliveryservice_ws_s.fax
        , cte_deliveryservice_ws_s.hausnummer
        , cte_deliveryservice_ws_s.land
        , cte_deliveryservice_ws_s.name
        , cte_deliveryservice_ws_s.ort
        , cte_deliveryservice_ws_s.plz
        , cte_deliveryservice_ws_s.strasse
        , cte_deliveryservice_ws_s.telefon
        , d.ldts
    FROM cte_load_date d
    CROSS JOIN cte_deliveryservice_h
    INNER JOIN  cte_deliveryservice_ws_s
        ON cte_deliveryservice_ws_s.hk_deliveryservice_h = cte_deliveryservice_h.hk_deliveryservice_h
        AND d.ldts between cte_deliveryservice_ws_s.ldts AND cte_deliveryservice_ws_s.ledts
    INNER JOIN  cte_deliveryservice_ws_sts
        ON cte_deliveryservice_ws_sts.hk_deliveryservice_h = cte_deliveryservice_h.hk_deliveryservice_h
        AND d.ldts between cte_deliveryservice_ws_sts.ldts AND cte_deliveryservice_ws_sts.ledts
)
,
cte_target as
(   
    SELECT
    cte_deliveryservice.lieferdienstid
    , cte_deliveryservice.email
    , cte_deliveryservice.fax
    , cte_deliveryservice.hausnummer
    , cte_deliveryservice.land
    , cte_deliveryservice.name
    , cte_deliveryservice.ort
    , cte_deliveryservice.plz
    , cte_deliveryservice.strasse
    , cte_deliveryservice.telefon 
         , cte_load_date.ldts
    FROM cte_load_date
    INNER JOIN  cte_deliveryservice 
        ON cte_load_date.ldts = cte_deliveryservice.ldts
            
)
(
    select
            lieferdienstid
    , email
    , fax
    , hausnummer
    , land
    , name
    , ort
    , plz
    , strasse
    , telefon
            , ldts
    from cte_load
    MINUS
    select
            lieferdienstid
    , email
    , fax
    , hausnummer
    , land
    , name
    , ort
    , plz
    , strasse
    , telefon
            , ldts
    from cte_target
)    
UNION
(
    select
            lieferdienstid
    , email
    , fax
    , hausnummer
    , land
    , name
    , ort
    , plz
    , strasse
    , telefon
            , ldts
    from cte_target
    minus
    select
            lieferdienstid
    , email
    , fax
    , hausnummer
    , land
    , name
    , ort
    , plz
    , strasse
    , telefon
            , ldts
    from cte_load
)
