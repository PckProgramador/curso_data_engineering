-- models/facts/fact_orders.sql
{{ config(materialized='incremental') }}

WITH base AS (
    SELECT
        order_id,
        user_id,
        address_id,
        promo_id,
        shipping_service,
        shipping_cost,
        order_cost,
        order_total,
        created_at,
        estimated_delivery_at,
        delivered_at,
        status_order,
        _FIVETRAN_DELETED,
        _FIVETRAN_SYNCED_UTC
    FROM {{ ref('stg_sql_server_dbo__orders') }}
)
SELECT
    order_id,
    user_id,
    address_id,
    promo_id,
    shipping_service,
    shipping_cost,
    order_cost,
    order_total,
    created_at,
    estimated_delivery_at,
    delivered_at,
    status_order,
    _FIVETRAN_DELETED,
    _FIVETRAN_SYNCED_UTC
FROM base


 {% if is_incremental() %}

  where _FIVETRAN_SYNCED_UTC > (select max(_FIVETRAN_SYNCED_UTC) from {{ this }})

{% endif %}