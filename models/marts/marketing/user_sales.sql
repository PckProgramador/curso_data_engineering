{{ config(materialized='table') }}

-- models/gold/user_purchase_summary.sql

WITH user_order_details AS (
    SELECT
        u.user_id,
        u.first_name,
        u.last_name,
        u.email,
        u.phone_number,
        u.created_at AS user_created_at,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(o.order_total) AS total_spent,
        SUM(o.shipping_cost) AS total_shipping_cost,
        SUM(CASE WHEN p.discount IS NULL THEN 0 ELSE p.discount END) AS total_discount,
        SUM(oi.quantity) AS total_products,
        COUNT(DISTINCT oi.product_id) AS total_unique_products
    FROM
        {{ ref('stg_sql_server_dbo__users') }} u
    LEFT JOIN
        {{ ref('stg_sql_server_dbo__orders') }} o
    ON
        u.user_id = o.user_id
    LEFT JOIN
        {{ ref('stg_sql_server_dbo__order_items') }} oi
    ON
        o.order_id = oi.order_id
    LEFT JOIN
        {{ ref('stg_sql_server_dbo__promos') }} p
    ON
        o.promo_id = p.promo_id
    WHERE
        o._FIVETRAN_DELETED = FALSE  -- Solo pedidos no eliminados
    GROUP BY
        u.user_id, u.first_name, u.last_name, u.email, u.phone_number, u.created_at
)
SELECT
    user_id,
    first_name,
    last_name,
    email,
    phone_number,
    user_created_at,
    total_orders,
    total_spent,
    total_shipping_cost,
    total_discount,
    total_products,
    total_unique_products
FROM
    user_order_details
ORDER BY
    total_spent DESC, total_orders DESC