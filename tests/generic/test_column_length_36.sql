-- tests/generic/test_column_length_36.sql

SELECT
    *
FROM
    {{ model }}
WHERE
    LENGTH({{ column_name }}) != 36
