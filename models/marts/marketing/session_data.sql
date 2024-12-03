{{ config(materialized='incremental') }}

WITH event_data AS (
    SELECT 
        EVENT_ID,
        PAGE_URL,
        EVENT_TYPE,
        USER_ID,
        PRODUCT_ID, 
        SESSION_ID,
        CREATED_AT,
        ORDER_ID,
        _FIVETRAN_DELETED, 
       _FIVETRAN_SYNCED_UTC
    FROM {{ ref('stg_sql_server_dbo__events') }}  -- Referencia al modelo stg_events
),

session_info AS (
    SELECT 
        SESSION_ID,
        USER_ID,
        MIN(CREATED_AT) AS session_start,  -- Inicio de la sesión
        MAX(CREATED_AT) AS session_end,    -- Fin de la sesión
        DATEDIFF(second, MIN(CREATED_AT), MAX(CREATED_AT)) AS session_duration_seconds,  -- Duración en segundos
        COUNT(DISTINCT PAGE_URL) AS pages_viewed,  -- Número de páginas vistas (distintas URL)
        
        -- Contar eventos específicos
        SUM(CASE WHEN EVENT_TYPE = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart_events,
        SUM(CASE WHEN EVENT_TYPE = 'checkout' THEN 1 ELSE 0 END) AS checkout_events,
        SUM(CASE WHEN EVENT_TYPE = 'package_shipped' THEN 1 ELSE 0 END) AS package_shipped_events
        
    FROM event_data
    WHERE event_type NOT LIKE 'package_shipped'
    GROUP BY SESSION_ID, USER_ID
)

SELECT 
    si.SESSION_ID,
    si.USER_ID,
    si.session_start,
    si.session_end,
    si.session_duration_seconds,
    si.pages_viewed,
    si.add_to_cart_events,
    si.checkout_events,
    si.package_shipped_events
FROM session_info si

{% if is_incremental() %}
    -- Solo cargar eventos que no estén en la tabla de destino
    WHERE si.session_start > (SELECT MAX(session_start) FROM {{ this }})
{% endif %}
