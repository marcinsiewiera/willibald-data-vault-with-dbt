

WITH
cte_load_date as
(
  SELECT file_ldts as ldts
  FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_00_meta.meta_load
  WHERE table_name = 'load_webshop_kunde'
  qualify max(ldts) OVER (PARTITION BY TABLE_NAME) = ldts
),
cte_load AS
(
    SELECT
        vereinspartnerid
    , kundeid
    , email
    , geburtsdatum
    , geschlecht
    , gueltigbis
    , kkfirma
    , kreditkarte
    , mobil
    , name
    , telefon
    , vorname
        , ldts_source as ldts
    FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_02_load.load_webshop_kunde
    where is_check_ok
)
        
, cte_associationpartner as
(
        SELECT
            associationpartner_h.hk_associationpartner_h, IFF(associationpartner_bk != '(unknown)', associationpartner_bk, NULL) as vereinspartnerid
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.associationpartner_h associationpartner_h
)
        
, cte_customer as
(
    with cte_customer_h as
    (
        SELECT
            customer_h.hk_customer_h, IFF(customer_bk != '(unknown)', customer_bk, NULL) as kundeid
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_h customer_h
    )
    ,cte_customer_ws_s as
    (
        SELECT    
              cte_customer_h.hk_customer_h
            , email
    , geburtsdatum
    , geschlecht
    , gueltigbis
    , kkfirma
    , kreditkarte
    , mobil
    , name
    , telefon
    , vorname, customer_ws_s.ldts, COALESCE(LEAD(customer_ws_s.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_customer_h.hk_customer_h  ORDER BY customer_ws_s.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_customer_h
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_ws_s customer_ws_s
            ON cte_customer_h.hk_customer_h = customer_ws_s.hk_customer_h
        WHERE customer_ws_s.hk_customer_h <> '00000000000000000000000000000000'
    )
    ,cte_customer_ws_sts as
    (SELECT * FROM 
        (
        SELECT    
              cte_customer_h.hk_customer_h, customer_ws_sts.ldts, customer_ws_sts.cdc, COALESCE(LEAD(customer_ws_sts.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_customer_h.hk_customer_h  ORDER BY customer_ws_sts.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_customer_h
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_ws_sts customer_ws_sts
            ON cte_customer_h.hk_customer_h = customer_ws_sts.hk_customer_h
        )
        WHERE cdc <> 'D'
    ) 
    SELECT  
        cte_customer_h.hk_customer_h
        , cte_customer_h.kundeid
        , cte_customer_ws_s.email
        , cte_customer_ws_s.geburtsdatum
        , cte_customer_ws_s.geschlecht
        , cte_customer_ws_s.gueltigbis
        , cte_customer_ws_s.kkfirma
        , cte_customer_ws_s.kreditkarte
        , cte_customer_ws_s.mobil
        , cte_customer_ws_s.name
        , cte_customer_ws_s.telefon
        , cte_customer_ws_s.vorname
        , d.ldts
    FROM cte_load_date d
    CROSS JOIN cte_customer_h
    INNER JOIN  cte_customer_ws_s
        ON cte_customer_ws_s.hk_customer_h = cte_customer_h.hk_customer_h
        AND d.ldts between cte_customer_ws_s.ldts AND cte_customer_ws_s.ledts
    INNER JOIN  cte_customer_ws_sts
        ON cte_customer_ws_sts.hk_customer_h = cte_customer_h.hk_customer_h
        AND d.ldts between cte_customer_ws_sts.ldts AND cte_customer_ws_sts.ledts
)
        
, cte_customer_associationpartner as
(
    with cte_customer_associationpartner_l as
    (
        SELECT
            customer_associationpartner_l.hk_customer_associationpartner_l, hk_customer_h
    , hk_associationpartner_h
        FROM WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_associationpartner_l customer_associationpartner_l
    )
    ,cte_customer_associationpartner_ws_sts as
    (SELECT * FROM 
        (
        SELECT    
              cte_customer_associationpartner_l.hk_customer_associationpartner_l, customer_associationpartner_ws_sts.ldts, customer_associationpartner_ws_sts.cdc, COALESCE(LEAD(customer_associationpartner_ws_sts.ldts - INTERVAL '1 MICROSECOND') OVER (PARTITION BY cte_customer_associationpartner_l.hk_customer_associationpartner_l  ORDER BY customer_associationpartner_ws_sts.ldts),TO_TIMESTAMP('8888-12-31T23:59:59', 'YYYY-MM-DDTHH24:MI:SS')) as ledts
        FROM cte_customer_associationpartner_l
        INNER JOIN WILLIBALD_DATA_VAULT_WITH_DBT.dwh_04_rv.customer_associationpartner_ws_sts customer_associationpartner_ws_sts
            ON cte_customer_associationpartner_l.hk_customer_associationpartner_l = customer_associationpartner_ws_sts.hk_customer_associationpartner_l
        )
        WHERE cdc <> 'D'
    ) 
    SELECT  
        cte_customer_associationpartner_l.hk_customer_associationpartner_l
        , cte_customer_associationpartner_l.hk_customer_h
        , cte_customer_associationpartner_l.hk_associationpartner_h
        , d.ldts
    FROM cte_load_date d
    CROSS JOIN cte_customer_associationpartner_l
    INNER JOIN  cte_customer_associationpartner_ws_sts
        ON cte_customer_associationpartner_ws_sts.hk_customer_associationpartner_l = cte_customer_associationpartner_l.hk_customer_associationpartner_l
        AND d.ldts between cte_customer_associationpartner_ws_sts.ldts AND cte_customer_associationpartner_ws_sts.ledts
)
,
cte_target as
(   
    SELECT
    cte_associationpartner.vereinspartnerid
    , cte_customer.kundeid
    , cte_customer.email
    , cte_customer.geburtsdatum
    , cte_customer.geschlecht
    , cte_customer.gueltigbis
    , cte_customer.kkfirma
    , cte_customer.kreditkarte
    , cte_customer.mobil
    , cte_customer.name
    , cte_customer.telefon
    , cte_customer.vorname, cte_load_date.ldts
    FROM cte_load_date 
    INNER JOIN cte_customer_associationpartner
        ON cte_customer_associationpartner.ldts = cte_load_date.ldts
    INNER JOIN  cte_customer 
        ON cte_customer_associationpartner.hk_customer_h = cte_customer.hk_customer_h
        AND cte_customer.ldts =  cte_load_date.ldts
    INNER JOIN  cte_associationpartner 
        ON cte_customer_associationpartner.hk_associationpartner_h = cte_associationpartner.hk_associationpartner_h
)
(
    select
            vereinspartnerid
    , kundeid
    , email
    , geburtsdatum
    , geschlecht
    , gueltigbis
    , kkfirma
    , kreditkarte
    , mobil
    , name
    , telefon
    , vorname
            , ldts
    from cte_load
    MINUS
    select
            vereinspartnerid
    , kundeid
    , email
    , geburtsdatum
    , geschlecht
    , gueltigbis
    , kkfirma
    , kreditkarte
    , mobil
    , name
    , telefon
    , vorname
            , ldts
    from cte_target
)    
UNION
(
    select
            vereinspartnerid
    , kundeid
    , email
    , geburtsdatum
    , geschlecht
    , gueltigbis
    , kkfirma
    , kreditkarte
    , mobil
    , name
    , telefon
    , vorname
            , ldts
    from cte_target
    minus
    select
            vereinspartnerid
    , kundeid
    , email
    , geburtsdatum
    , geschlecht
    , gueltigbis
    , kkfirma
    , kreditkarte
    , mobil
    , name
    , telefon
    , vorname
            , ldts
    from cte_load
)
