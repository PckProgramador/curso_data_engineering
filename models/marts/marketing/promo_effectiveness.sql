{{ config(materialized='table') }}

WITH promo_orders AS (
    SELECT
         p.promo_name,
        COUNT(DISTINCT o.order_id) AS total_orders_with_promo,
        SUM(p.discount) AS total_discount_given, 
        SUM(o.order_total) AS total_sales_with_promo,
        AVG(o.order_total) AS average_order_value_with_promo
    FROM
        {{ ref('stg_sql_server_dbo__orders') }} o
    LEFT JOIN
        {{ ref('stg_sql_server_dbo__promos') }} p
    ON
        o.promo_id = p.promo_name
    GROUP BY
     p.promo_name
)

SELECT
    po.promo_name,
    po.total_orders_with_promo,
    po.total_discount_given,
    po.total_sales_with_promo,
    po.average_order_value_with_promo,
    p.status_promo AS promo_status, 
    p._fivetran_synced_utc 
FROM
    promo_orders po
LEFT JOIN
    {{ ref('stg_sql_server_dbo__promos') }} p
ON
    po.promo_name = p.promo_name
