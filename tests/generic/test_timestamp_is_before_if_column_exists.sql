-- tests/generic/test_timestamp_is_before_if_column_exists.sql

{% if 'column_2' in adapter.get_columns_in_relation(model) %}
    SELECT
        *
    FROM
        {{ model }}
    WHERE
        {{ column_1 }} >= {{ column_2 }}
{% else %}
    SELECT
        'No column_2 found, skipping test' AS message
    LIMIT 1
{% endif %}
