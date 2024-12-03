{{ config(materialized='incremental') }}

 SELECT 
    cast(EVENT_ID as varchar(36)) as EVENT_ID,
    PAGE_URL,
    EVENT_TYPE,
    cast(USER_ID as varchar(36)) as USER_ID,
    cast(PRODUCT_ID as varchar(36)) as PRODUCT_ID, 
    cast(SESSION_ID as varchar(36)) as SESSION_ID,
    CONVERT_TIMEZONE('UTC', CREATED_AT) as CREATED_AT,
    ORDER_ID,
        CASE
        WHEN _FIVETRAN_DELETED is null then false
        else true
        END as _FIVETRAN_DELETED, -- cambiamos de null a false 
        CONVERT_TIMEZONE('UTC', _FIVETRAN_SYNCED) AS _FIVETRAN_SYNCED_UTC
    FROM {{ source('sql_server_dbo', 'events') }} 

  {% if is_incremental() %}

  where _FIVETRAN_SYNCED_UTC > (select max(_FIVETRAN_SYNCED_UTC) from {{ this }})

{% endif %}