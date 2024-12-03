-- models/facts/fact_order_items.sql
{{ config(materialized='incremental') }}

WITH base AS (
    SELECT
        order_id,
        product_id,
        quantity,
        _FIVETRAN_DELETED,
        _FIVETRAN_SYNCED_UTC
    FROM {{ ref('stg_sql_server_dbo__order_items') }}
)
SELECT
    order_id,
    product_id,
    quantity,
    _FIVETRAN_DELETED,
    _FIVETRAN_SYNCED_UTC
FROM base

 {% if is_incremental() %}

  where _FIVETRAN_SYNCED_UTC > (select max(_FIVETRAN_SYNCED_UTC) from {{ this }})

{% endif %}