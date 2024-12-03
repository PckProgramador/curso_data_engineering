-- tests/generic/test_order_total_coherency.sql

SELECT
    *
FROM
    {{ model }}
WHERE
    order_total < (order_cost + shipping_cost)
