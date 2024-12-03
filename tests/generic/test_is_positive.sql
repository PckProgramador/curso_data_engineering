-- tests/test_is_positive.sql

{% test is_positive(column_name) %}

with validation as (
    select
        {{ column_name }} as positive_field
    from {{ this }}  -- 'this' hace referencia al modelo actual
),

validation_errors as (
    select
        positive_field
    from validation
    where positive_field <= 0
)

select *
from validation_errors

{% endtest %}
