-- models/facts/fact_events.sql
{{ config(materialized='incremental') }}

WITH base AS (
    SELECT
        event_id,
        user_id,
        product_id,
        session_id,
        order_id,
        event_type,
        created_at,
        _FIVETRAN_DELETED,
        _FIVETRAN_SYNCED_UTC
    FROM {{ ref('stg_sql_server_dbo__events') }}
)
SELECT
    event_id,
    user_id,
    product_id,
    session_id,
    order_id,
    event_type,
    created_at,
    _FIVETRAN_DELETED,
    _FIVETRAN_SYNCED_UTC
FROM base

{% if is_incremental() %}

  where _FIVETRAN_SYNCED_UTC > (select max(_FIVETRAN_SYNCED_UTC) from {{ this }})

{% endif %}