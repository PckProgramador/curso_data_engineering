{% test valid_email(model, column_name) %}
    
    with invalid_emails as (
        select 
            {{ column_name }} 
        from {{ model }}
        where {{ column_name }} not like '%_@__%.__%' -- Expresión regular simple para correos
    )
    
    select *
    from invalid_emails

{% endtest %}
