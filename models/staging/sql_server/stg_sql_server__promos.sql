{{
  config(
    materialized='table'
  )
}}


WITH promos_cte AS (
    SELECT 
    PROMO_ID,
	DISCOUNT,
    -- Usamos CASE para cambiar el valor del campo STATUS
    CASE 
        WHEN TRIM(STATUS) = 'active' THEN true
        WHEN TRIM(STATUS) = 'inactive' THEN false
        ELSE false  -- Pongo false para estandarizar los null a false, significa que no se pueden aplicar
    END AS STATUS,
    COALESCE(_FIVETRAN_DELETED, false) AS IS_DELETED, 
    _FIVETRAN_SYNCED AS SYNC_DATE
FROM 
    {{ source('sql_server_dbo', 'promos') }}

)

SELECT
    *
FROM 
    promos_cte;
