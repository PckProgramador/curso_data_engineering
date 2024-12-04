{{ config(materialized='table') }}

WITH sales_by_state AS (
    SELECT
        a.STATE AS state,
        SUM(o.ORDER_TOTAL) AS total_sales,
        COUNT(o.ORDER_ID) AS order_count,
        AVG(o.ORDER_TOTAL) AS average_order_total,
        SUM(o.SHIPPING_COST) AS shipping_cost_total,
        MAX(o._FIVETRAN_SYNCED_UTC) AS _FIVETRAN_SYNCED_UTC
    FROM
        {{ ref('stg_sql_server_dbo__orders') }} o
    JOIN
        {{ ref('stg_sql_server_dbo__addresses') }} a
    ON
        o.ADDRESS_ID = a.ADDRESS_ID
    WHERE
        o._FIVETRAN_DELETED = FALSE  -- Solo incluir registros no eliminados
    GROUP BY
        a.STATE
)
SELECT
    state,
    total_sales,
    order_count,
    average_order_total,
    shipping_cost_total,
    _FIVETRAN_SYNCED_UTC
FROM
    sales_by_state
ORDER BY
    total_sales DESC
